find_package(BISON 2.7)
find_package(FLEX 2.6.4)

include_directories("../include")

FLEX_TARGET(scanner tsh.l ${PROJECT_SOURCE_DIR}/src/lex.yy.c COMPILE_FLAGS "--header-file=../include/lex.yy.h")
BISON_TARGET(parser tsh.y ${PROJECT_SOURCE_DIR}/src/tsh.tab.c COMPILE_FLAGS "--defines=../include/tsh.tab.h")
ADD_FLEX_BISON_DEPENDENCY(scanner parser)

add_executable(tsh
    tsh.c
    tsh.l
    tsh.y
    convert.c
    ${FLEX_scanner_OUTPUTS}
    ${BISON_parser_OUTPUTS}
)