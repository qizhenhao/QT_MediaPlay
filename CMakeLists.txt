cmake_minimum_required(VERSION 3.16)

project(fang_MediaPlayerExample LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

# if(NOT DEFINED INSTALL_EXAMPLESDIR)
#     set(INSTALL_EXAMPLESDIR "test")
# endif()

# set(INSTALL_EXAMPLEDIR "${INSTALL_EXAMPLESDIR}\test01_mediaPlayer_qml\fang_MediaPlayerExample")

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Quick QuickControls2 Svg)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(fang_MediaPlayerExample
    main.cpp
)

set(qml_files
    "Main.qml"
    "PlaylistInfo.qml"
)

qt_add_qml_module(fang_MediaPlayerExample
    URI MediaPlayerModule
    QML_FILES ${qml_files}
    QML_FILES ErrorPopup.qml
    QML_FILES PlayerMenuBar.qml
    QML_FILES UrlPopup.qml
    QML_FILES SettingsInfo.qml
    QML_FILES MetadataInfo.qml)
add_subdirectory(Config)
add_subdirectory(MediaControls)

target_link_libraries(fang_MediaPlayerExample PRIVATE
    Qt6::Core
    Qt6::Svg
    Qt6::Quick
   Configplugin
     MediaControlsplugin
)

# install(TARGETS fang_MediaPlayerExample
#     RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
#     BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
#     LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
# )
