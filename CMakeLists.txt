project(stm32_prjname)
cmake_minimum_required(VERSION 3.0.2 FATAL_ERROR)

enable_language(ASM)

include_directories(
    core/include
    drivers/STM32F1xx_HAL_Driver/include
    drivers/STM32F1xx_HAL_Driver/include/Legacy
    drivers/CMSIS/Device/ST/STM32F1xx/include
    drivers/CMSIS/include
)

add_subdirectory(core)
add_subdirectory(drivers)
