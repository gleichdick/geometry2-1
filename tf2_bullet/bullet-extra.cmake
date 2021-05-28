if(WIN32)
  set(BULLET_ROOT $ENV{ChocolateyInstall}/lib/bullet)
endif()
find_package(Bullet REQUIRED)

target_include_directories(tf2_bullet::tf2_bullet SYSTEM INTERFACE
  ${BULLET_INCLUDE_DIRS}
)
target_link_libraries(tf2_bullet::tf2_bullet INTERFACE
  ${BULLET_LIBRARIES}
)
