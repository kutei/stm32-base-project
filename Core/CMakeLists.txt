set(SRCS_CORE
    Src/sys.c
    Src/stm32f1xx_hal_msp.c
    Src/system_stm32f1xx.c
    Src/main.cpp
)
add_library(core STATIC ${SRCS_CORE})

set(APP_NAME "prjoutput.elf")
add_executable(${APP_NAME} startup_stm32f103xb.s Src/stm32f1xx_it.c)
target_link_libraries(${APP_NAME} core hal)
display_size(${APP_NAME})

install(TARGETS ${APP_NAME}
    RUNTIME DESTINATION bin
)
