const cm = @import("zig-cortex/cm7.zig");
const std = @import("std");
usingnamespace @import("STM32F7x7.zig");

const Pllp = enum(u2) {
    PLLP_2 = 0,
    PLLP_4 = 1,
    PLLP_6 = 2,
    PLLP_8 = 3,
};

pub const xtal = 8000000;
const max_vco_input_freq = 2000000;
const vco_input_freq = 2000000;
const pllm = (xtal + max_vco_input_freq - 1) / vco_input_freq;
const plln = pllclk / vco_input_freq;
const pllp = Pllp.PLLP_2;
const pllr = 7; // don't care, dsi clock
const pllq = pllclk / sdmmc1_clock;
const pllsain = 192;
const pllsaiq = 2; // don't care
const pllsair = 2;
const pllsaip = Pllp.PLLP_8; // don't care, more division == less power
const pllclk = 432000000;

pub const sysclk = pllclk / 2;
pub const hclk = sysclk;
pub const system_timer_clock = hclk / 8;
pub const fclk = hclk;
pub const ahb_prescaler = 1;
const ahb_prescaler_setting = 0;
pub const apb1_prescaler = 4;
const apb1_prescaler_setting = 5;
pub const apb1_peripheral_clock = hclk / apb1_prescaler;
pub const apb1_timer_clock = apb1_peripheral_clock * 2;
pub const apb2_prescaler = 2;
const apb2_prescaler_setting = 4;
pub const apb2_peripheral_clock = hclk / apb2_prescaler;
pub const apb2_timer_clock = apb2_peripheral_clock * 2;
pub const sdmmc1_clock = 48000000; // max sdmmc1 frequency
pub const lcd_clock = (((vco_input_freq * pllsain) / pllsair) / 2);
// TODO: assert at compile time

pub const sys_tick_priority = 15;

pub fn init() void {
    cm.SCB.ICache.enable();
    cm.SCB.DCache.enable();
    // all bits to priority groups, no sub-priority bits
    cm.SCB.PriorityBitsGrouping.set(.GroupPriorityBits_4);
    initSysTick();
    initClocks();
}

fn initSysTick() void {
    cm.SysTick.config(cpu.nvic_prio_bits, .External, true, true, (xtal / 1000) - 1);
    cm.SCB.Exceptions.SysTickHandler.setPriority(cpu.nvic_prio_bits, sys_tick_priority);
}

fn initClocks() void {
    // enable clock for power controller so
    // it can control the voltage scaling once
    // pll is enabled
    RCC_APB1ENR_Ptr.* |= RCC_APB1ENR_PWREN(1);
    // using HSE, enable first in bypass mode for resonator
    // See "Entering Over-drive mode" RM0410
    RCC_CR_Ptr.* |= RCC_CR_HSEBYP(1) | RCC_CR_HSEON(1);
    // set VOS to scale 1, highest power consumption and performance
    PWR_CR1_Ptr.* = (PWR_CR1_Ptr.* & ~@as(u32, PWR_CR1_VOS_Mask)) | PWR_CR1_VOS(3);

    var pllcfgr = RCC_PLLCFGR_Ptr.*;
    pllcfgr &= ~@as(u32, RCC_PLLCFGR_Write_Mask);
    RCC_PLLCFGR_Ptr.* |=
        pllcfgr |
        RCC_PLLCFGR_PLLM(pllm) |
        RCC_PLLCFGR_PLLR(pllr) |
        RCC_PLLCFGR_PLLQ(pllq) |
        RCC_PLLCFGR_PLLSRC(1) | // hse
        RCC_PLLCFGR_PLLP(@enumToInt(pllp)) |
        RCC_PLLCFGR_PLLN(plln);

    var pllsaicfgr = RCC_PLLSAICFGR_Ptr.*;
    pllcfgr &= ~@as(u32, RCC_PLLSAICFGR_Write_Mask);
    RCC_PLLSAICFGR_Ptr.* |=
        pllsaicfgr |
        RCC_PLLSAICFGR_PLLSAIR(pllsair) |
        RCC_PLLSAICFGR_PLLSAIQ(pllsaiq) |
        RCC_PLLSAICFGR_PLLSAIP(@enumToInt(pllsaip)) |
        RCC_PLLSAICFGR_PLLSAIN(pllsain);

    var ded_clock_1 = RCC_DCKCFGR1_Ptr.*;
    ded_clock_1 &= ~@as(u32, RCC_DCKCFGR1_Write_Mask);
    ded_clock_1 &= ~@as(u32, RCC_DCKCFGR1_PLLSAIDIVR_Mask);
    RCC_DCKCFGR1_Ptr.* =
        ded_clock_1 |
        RCC_DCKCFGR1_PLLSAIDIVR(@enumToInt(Pllp.PLLP_2));

    var ded_clock_2 = RCC_DCKCFGR2_Ptr.*;
    ded_clock_2 &= ~@as(u32, RCC_DCKCFGR2_Write_Mask);
    RCC_DCKCFGR2_Ptr.* =
        ded_clock_2 |
        RCC_DCKCFGR2_SDMMC1SEL(0) | // 48MHz Clock
        RCC_DCKCFGR2_CK48MSEL(0); // 48MHz Clock from PLL
    // enable pll
    RCC_CR_Ptr.* |= RCC_CR_PLLON(1) | RCC_CR_PLLSAION(1);
    // enable overdrive, wait for ready
    PWR_CR1_Ptr.* |= PWR_CR1_ODEN(1);
    while ((PWR_CSR1_Ptr.* & PWR_CSR1_ODRDY_Mask) == 0) {}
    // do overdrive switch, wait for completion
    PWR_CR1_Ptr.* |= PWR_CR1_ODSWEN(1);
    while ((PWR_CSR1_Ptr.* & PWR_CSR1_ODSWRDY_Mask) == 0) {}
    // select required flash latency
    // enable ART Accelerator and prefetch buffer, only for flash on ITCM
    const acr_value = Flash_ACR_ARTEN_Mask |
        Flash_ACR_PRFTEN_Mask |
        Flash_ACR_LATENCY(hclkToWaitStates(hclk));
    while (Flash_ACR_Ptr.* != acr_value) {
        // check that new number of wait states is taken into account
        Flash_ACR_Ptr.* = acr_value;
    }
    // set ahb, apb1, and apb2 prescaler
    RCC_CFGR_Ptr.* |=
        RCC_CFGR_PPRE2(apb2_prescaler_setting) |
        RCC_CFGR_PPRE1(apb1_prescaler_setting) |
        RCC_CFGR_HPRE(ahb_prescaler_setting);
    // wait for pll lock
    while ((RCC_CR_Ptr.* & (RCC_CR_PLLSAIRDY_Mask | RCC_CR_PLLRDY_Mask)) != 0) {}
    // switch system clock to pll
    while ((RCC_CFGR_Ptr.* & RCC_CFGR_SWS_Mask) != RCC_CFGR_SWS(2)) {
        RCC_CFGR_Ptr.* =
            (RCC_CFGR_Ptr.* & ~@as(u32, RCC_CFGR_SW_Mask)) |
            RCC_CFGR_SW(2);
    }
    // enable peripherals that are not generated by sytem pll
    // (lcd clock, sdmmc clock, etc)
    RCC_AHB1ENR_Ptr.* |=
        RCC_AHB1ENR_DMA2DEN(1) |
        RCC_AHB1ENR_GPIOAEN(1) |
        RCC_AHB1ENR_GPIOBEN(1) |
        RCC_AHB1ENR_GPIOCEN(1) |
        RCC_AHB1ENR_GPIODEN(1) |
        RCC_AHB1ENR_GPIOEEN(1) |
        RCC_AHB1ENR_GPIOFEN(1) |
        RCC_AHB1ENR_GPIOGEN(1) |
        RCC_AHB1ENR_GPIOHEN(1) |
        RCC_AHB1ENR_GPIOIEN(1) |
        RCC_AHB1ENR_GPIOJEN(1) |
        RCC_AHB1ENR_GPIOKEN(1);
    RCC_AHB2ENR_Ptr.* |=
        RCC_AHB2ENR_RNGEN(1) |
        RCC_AHB2ENR_JPEGEN(0); // TODO: use in graphics pipeline?
    RCC_AHB3ENR_Ptr.* |=
        RCC_AHB3ENR_FMCEN(1);
    RCC_APB1ENR_Ptr.* |=
        RCC_APB1ENR_DACEN(1) |
        RCC_APB1ENR_TIM2EN(0) |
        RCC_APB1ENR_TIM3EN(0) |
        RCC_APB1ENR_TIM4EN(0) |
        RCC_APB1ENR_TIM5EN(0) |
        RCC_APB1ENR_TIM6EN(0) |
        RCC_APB1ENR_TIM7EN(0) |
        RCC_APB1ENR_TIM12EN(0) |
        RCC_APB1ENR_TIM13EN(0) |
        RCC_APB1ENR_TIM14EN(0) |
        RCC_APB1ENR_LPTIM1EN(0);
    RCC_APB2ENR_Ptr.* |=
        RCC_APB2ENR_LTDCEN(1) |
        RCC_APB2ENR_TIM1EN(0) |
        RCC_APB2ENR_TIM8EN(0) |
        RCC_APB2ENR_TIM9EN(0) |
        RCC_APB2ENR_TIM10EN(0) |
        RCC_APB2ENR_TIM11EN(0) |
        RCC_APB2ENR_SDMMC1EN(1) |
        RCC_APB2ENR_ADC2EN(1);
}

/// This function assumes Vcc of 2.7V - 3.6V
fn hclkToWaitStates(comptime clk: comptime_int) u4 {
    if (clk <= 30000000) {
        return 0;
    } else if (clk <= 60000000) {
        return 1;
    } else if (clk <= 90000000) {
        return 2;
    } else if (clk <= 120000000) {
        return 3;
    } else if (clk <= 150000000) {
        return 4;
    } else if (clk <= 180000000) {
        return 5;
    } else if (clk <= 210000000) {
        return 6;
    } else {
        return 7;
    }
}