QT += widgets concurrent
CONFIG += c++17
CONFIG -= app_bundle
QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.15
TEMPLATE = app
TARGET = UnifiedEngineeringWorkbench
DESTDIR = work/build

INCLUDEPATH += src/backend src/frontend/app src/frontend/widgets

QMAKE_CXXFLAGS += -Wall -Wextra -Wpedantic

SOURCES += \
    src/frontend/app/main.cpp \
    src/frontend/app/mainwindow.cpp \
    src/frontend/widgets/geometry_canvas.cpp \
    src/backend/geometry/geometry_parser.cpp \
    src/backend/hardware/mock_adapters.cpp \
    src/backend/neural_network/backprop.cpp \
    src/backend/performance/batch_runner.cpp \
    src/backend/thermal/thermal_solver.cpp

HEADERS += \
    src/frontend/app/mainwindow.hpp \
    src/frontend/widgets/geometry_canvas.hpp \
    src/backend/geometry/geometry_parser.hpp \
    src/backend/hardware/mock_adapters.hpp \
    src/backend/neural_network/backprop.hpp \
    src/backend/performance/batch_runner.hpp \
    src/backend/thermal/thermal_solver.hpp
