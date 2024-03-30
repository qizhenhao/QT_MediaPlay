qt_add_library(MediaControls STATIC)

target_link_libraries(MediaControls PRIVATE Qt6::Quick)

qt_add_qml_module(MediaControls
    URI MediaControls
    VERSION 1.0
    QML_FILES MediaControlsControls.qml
    RESOURCES ../icons/Add_file.svg ../icons/Add_file_Dark.svg ../icons/Cancel_Button.svg ../icons/Default_CoverArt.svg ../icons/Error.svg ../icons/FullScreen_Icon.svg ../icons/FullScreen_Icon_Dark.svg ../icons/Load_Button.svg ../icons/Loop_Icon.svg ../icons/Loop_Icon_Dark.svg ../icons/Loop_Playlist.svg ../icons/Menu_Icon.svg ../icons/Menu_Icon_Dark.svg ../icons/Movie_Active.svg ../icons/Movie_Icon.svg ../icons/Movie_Icon_Dark.svg ../icons/Music_Active.svg ../icons/Music_Icon.svg ../icons/Music_Icon_Dark.svg ../icons/Mute_Icon.svg ../icons/Mute_Icon_Dark.svg ../icons/Next_Icon.svg ../icons/Next_Icon_Dark.svg ../icons/Play_Icon.svg ../icons/Playlist_Active.svg ../icons/Playlist_Icon.svg ../icons/Playlist_Icon_Dark.svg ../icons/Previous_Icon.svg ../icons/Previous_Icon_Dark.svg ../icons/Rate_Icon.svg ../icons/Rate_Icon_Dark.svg ../icons/Settings_Icon.svg ../icons/Settings_Icon_Dark.svg ../icons/Shadow.png ../icons/Shadow@2x.png ../icons/Shuffle_Active.svg ../icons/Shuffle_Icon.svg ../icons/Shuffle_Icon_Dark.svg ../icons/Single_Loop.svg ../icons/Stop_Icon.svg ../icons/Trash_Icon.svg ../icons/Trash_Icon_Dark.svg ../icons/Volume_Icon.svg ../icons/Volume_Icon_Dark.svg ../icons/Warning_Icon.svg

    QML_FILES CustomButton.qml
    QML_FILES AudioControl.qml
    QML_FILES CustomSlider.qml
    QML_FILES PlaybackControl.qml
    QML_FILES PlaybackRateControl.qml
    QML_FILES PlaybackSeekControl.qml

       # "AudioControl.qml"
       # "PlaybackSeekControl.qml"
       # "PlaybackRateControl.qml"
       # "PlaybackControl.qml"
       # "CustomSlider.qml"
       # "CustomRadioButton.qml"


)
