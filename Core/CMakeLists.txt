set(SRCS_CORE
    Src/sys.c
    Src/stm32f1xx_it.c
    Src/stm32f1xx_hal_msp.c
    Src/system_stm32f1xx.c
    Src/main.cpp
)

add_library(core STATIC ${SRCS_CORE})
