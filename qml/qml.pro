TEMPLATE = app
TARGET = sailbook

load(ubuntu-click)

QT += qml quick

SOURCES += main.cpp

RESOURCES += sailbook.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  sailbook.apparmor \
               sailbook.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               sailbook.desktop

#specify where the config files are installed to
config_files.path = /sailbook
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /sailbook
desktop_file.files = $$OUT_PWD/Sailbook.desktop
desktop_file.CONFIG += no_check_exist
INSTALLS+=desktop_file

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

DISTFILES += \
qml/UCSComponents/EmptyState.qml \
qml/UCSComponents/RadialAction.qml \
Uqml/CSComponents/RadialBottomEdge.qml \
qml/Main.qml \
qml/actions/Copy.qml \
qml/actions/CopyImage.qml \
qml/actions/CopyLink.qml \
qml/actions/SaveImage.qml \
qml/actions/ShareLink.qml \
qml/MimeTypeMapper.js \
qml/Downloader.qml \
qml/FileExtensionMapper.js \
qml/ContentDownloadDialog.qml \
qml/ContentShareDialog.qml \
qml/Share.qml \
qml/PickerDialog.qml \
qml/config.js \
qml/AboutPage.qml
