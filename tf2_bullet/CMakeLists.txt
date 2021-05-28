cmake_minimum_required(VERSION 3.5)
project(tf2_bullet)

# Default to C14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic -Wnon-virtual-dtor -Woverloaded-virtual)
endif()


find_package(ament_cmake REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(tf2 REQUIRED)
find_package(tf2_ros REQUIRED)

if(WIN32)
  set(BULLET_ROOT $ENV{ChocolateyInstall}/lib/bullet)
endif()
find_package(Bullet REQUIRED)

include_directories(include ${BULLET_INCLUDE_DIRS})
add_library(${PROJECT_NAME} INTERFACE)
target_include_directories(${PROJECT_NAME} INTERFACE
  "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
  "$<INSTALL_INTERFACE:include>"
)
target_include_directories(${PROJECT_NAME} SYSTEM INTERFACE
  "$<BUILD_INTERFACE:${BULLET_INCLUDE_DIRS}>"
)
target_link_libraries(${PROJECT_NAME} INTERFACE
  "$<BUILD_INTERFACE:${BULLET_LIBRARIES}>"
)

install(TARGETS ${PROJECT_NAME}
  EXPORT ${PROJECT_NAME}
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION lib
)

install(DIRECTORY include/${PROJECT_NAME}/
  DESTINATION include/${PROJECT_NAME}
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  find_package(ament_cmake_cppcheck REQUIRED)
  list(APPEND AMENT_LINT_AUTO_EXCLUDE
    ament_cmake_cppcheck
  )
  ament_lint_auto_find_test_dependencies()
  ament_cppcheck(LANGUAGE c++)

  find_package(ament_cmake_gtest REQUIRED)
  ament_add_gtest(test_bullet test/test_tf2_bullet.cpp)
  ament_target_dependencies(test_bullet
    geometry_msgs
    tf2
    tf2_ros
  )
  target_link_libraries(test_bullet ${PROJECT_NAME})
endif()

ament_export_targets(${PROJECT_NAME})
ament_package(CONFIG_EXTRAS_POST bullet-extra.cmake)
