# Copyright 2023 The StableHLO Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

configure_lit_site_cfg(
        ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
        ${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py
        MAIN_CONFIG
        ${CMAKE_CURRENT_SOURCE_DIR}/lit.cfg.py
)

set(STABLEHLO_TEST_DEPENDS
        FileCheck count not
        stablehlo-opt
        stablehlo-interpreter
)
add_lit_testsuite(check-stablehlo-compatibility-lit "Running the StableHLO compatibility tests"
        ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS ${STABLEHLO_TEST_DEPENDS}
        )
set_target_properties(check-stablehlo-compatibility-lit PROPERTIES FOLDER "Tests")
add_lit_testsuites(STABLEHLO_SUITE ${CMAKE_CURRENT_SOURCE_DIR} DEPENDS ${STABLEHLO_TEST_DEPENDS})

add_dependencies(check-stablehlo check-stablehlo-compatibility-lit)

