set(SRCS_HAL
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_gpio_ex.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_tim.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_tim_ex.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_rcc.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_rcc_ex.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_gpio.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_dma.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_cortex.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_pwr.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_flash.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_flash_ex.c
    STM32F1xx_HAL_Driver/src/stm32f1xx_hal_exti.c
)

add_library(hal STATIC ${SRCS_HAL})
