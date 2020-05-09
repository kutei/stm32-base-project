set(CMAKE_SYSTEM_NAME Generic)

# compiler settings
set(CMAKE_C_COMPILER    arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER  arm-none-eabi-g++)
set(CMAKE_EXE_LINKER    arm-none-eabi-g++)

# library compile setting
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# parameter - CPU ARCH
set(CPU_ARCH "cortex-m3" CACHE STRING "CPU ARCHETECTURE")
if(CPU_ARCH MATCHES "^cortex-m[34]$")
    message("CPU_ARCH: ${CPU_ARCH}")
else()
    message(FATAL_ERROR "Value of CPU_ARCH is invalid.: [${CPU_ARCH}]")
endif()
string(SUBSTRING ${CPU_ARCH} 8 1 CORTEX_NUMBER)

# parameter - CPU NAME
set(CPU_NAME "STM32F103xB" CACHE STRING "NAME OF CPU")
if(CPU_NAME MATCHES "^STM32F.....$")
    message("CPU_NAME: ${CPU_NAME}")
else()
    message(FATAL_ERROR "Value of CPU_NAME is invalid.: [${CPU_NAME}]")
endif()

# CMAKE_XXX_FLAGSを設定
unset(CMAKE_C_FLAGS)
set(ARM_CMAKE_FLAGS "-mthumb -mcpu=${CPU_ARCH} -D${CPU_NAME} -DARM_MATH_CM${CORTEX_NUMBER}")
set(ARM_CMAKE_FLAGS "${ARM_CMAKE_FLAGS} -fsingle-precision-constant -ffunction-sections -fdata-sections")
set(ARM_CMAKE_FLAGS "${ARM_CMAKE_FLAGS} -mslow-flash-data")
set(ARM_CMAKE_FLAGS "${ARM_CMAKE_FLAGS} -g3 -Wall -Wextra -Werror")
set(ARM_CMAKE_FLAGS "${ARM_CMAKE_FLAGS} -DUSE_HAL_DRIVER")
set(ARM_CMAKE_FLAGS "${ARM_CMAKE_FLAGS} '-D__weak=__attribute__((weak))' '-D__packed=__attribute__((__packed__))'")
set(CMAKE_C_FLAGS "${ARM_CMAKE_FLAGS}" CACHE STRING "" FORCE)

unset(CMAKE_AS_FLAGS CACHE)
set(CMAKE_AS_FLAGS "${CMAKE_C_FLAGS} -x assembler-with-cpp" CACHE STRING "" FORCE)

unset(CMAKE_CXX_FLAGS CACHE)
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -fno-use-cxa-atexit -fno-exceptions -fno-rtti" CACHE STRING "" FORCE)

# If you implement systemcall manually, delete "--specs=nosys.specs" option
unset(CMAKE_EXE_LINKER_FLAGS CACHE)
set(CMAKE_EXE_LINKER_FLAGS
    "${CMAKE_CXX_FLAGS} -L ${CMAKE_SOURCE_DIR} -T STM32F103C8Tx_FLASH.ld \
    -lc -lm --specs=nosys.specs -Xlinker --gc-sections -Wl,-Map=${CMAKE_PROJECT_NAME}.map"
    CACHE STRING "" FORCE
)

function(display_size APP_NAME)
    add_custom_command(TARGET ${APP_NAME} POST_BUILD
        COMMAND arm-none-eabi-size --format=berkeley "${APP_NAME}"
    )
endfunction()
