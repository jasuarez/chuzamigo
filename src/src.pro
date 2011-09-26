TEMPLATE = app
QT += declarative
TARGET = "meneamigo"
DEPENDPATH += .
INCLUDEPATH += .

# although the app doesn't use meegotouch by itself
# linking against it removes several style warnings
CONFIG += meegotouch

# enable booster
CONFIG += qt-boostable qdeclarative-boostable

# booster flags
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic

# Use share-ui interface
CONFIG += shareuiinterface-maemo-meegotouch mdatauri

LIBS += -lmdeclarativecache

# Input
SOURCES += main.cpp \
    controller.cpp

HEADERS += \
    controller.h

OTHER_FILES += \
    qml/main.qml \
    qml/MainView.qml \
    qml/NewsModel.qml \
    qml/CommentsModel.qml \
    qml/NewsDelegate.qml \
    qml/CommentsDelegate.qml \
    qml/CommentsView.qml \
    qml/MNM.js \
    qml/Header.qml \
    qml/Divider.qml \
    qml/RefreshHeader.qml \
    qml/AboutView.qml \
    qml/workerscript.js \
    resources/icon-view-details.png \
    resources/icon-view-comments.png \
    resources/icon-meneamigo.png \
    resources/meneamigo.svg

RESOURCES += \
    res.qrc

CODECFORTR = UTF-8
TRANSLATIONS += \
    l10n/es.ts

unix {
    #VARIABLES
    isEmpty(PREFIX) {
        PREFIX = /usr
    }
    BINDIR = $$PREFIX/bin
    DATADIR =$$PREFIX/share

    DEFINES += DATADIR=\\\"$$DATADIR\\\" PKGDATADIR=\\\"$$PKGDATADIR\\\"

    #MAKE INSTALL

    INSTALLS += target desktop icon64 splash

    target.path =$$BINDIR

    desktop.path = $$DATADIR/applications
    desktop.files += $${TARGET}.desktop

    icon64.path = $$DATADIR/icons/hicolor/64x64/apps
    icon64.files += ../data/$${TARGET}.png

    splash.path = $$DATADIR/$${TARGET}/
    splash.files += ../data/mnm-splash-landscape.jpg
    splash.files += ../data/mnm-splash-portrait.jpg
}

# Rule for regenerating .qm files for translations (missing in qmake
# default ruleset, ugh!)
#
updateqm.input = TRANSLATIONS
updateqm.output = ${QMAKE_FILE_PATH}/${QMAKE_FILE_BASE}.qm
updateqm.commands = lrelease ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
updateqm.CONFIG += no_link
QMAKE_EXTRA_COMPILERS += updateqm
PRE_TARGETDEPS += compiler_updateqm_make_all
