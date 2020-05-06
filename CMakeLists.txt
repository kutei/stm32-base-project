project(stm32_prjname)
cmake_minimum_required(VERSION 3.0.2 FATAL_ERROR)

include_directories(
    Core/Inc
    Drivers/STM32F1xx_HAL_Driver/Inc
    Drivers/STM32F1xx_HAL_Driver/Inc/Legacy
    Drivers/CMSIS/Device/ST/STM32F1xx/Include
    Drivers/CMSIS/Include
)

add_subdirectory(Core)
add_subdirectory(Drivers)

enable_language(ASM)
set(APP_NAME "prjoutput.elf")
add_executable(${APP_NAME} startup_stm32f103xb.s)
target_link_libraries(${APP_NAME} core hal)
