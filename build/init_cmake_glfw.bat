::set PATH=%PATH%;C:\mingw32\bin;C:\cmake-3.6.0\bin
:: build glfw alone

cmake -G"Visual Studio 16 2019" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DIMPL_SDL=no -DLUAJIT_BIN="c:/luajit" -S ../luajit-imgui -B ../luajit-imgui/.build

rem cmd /k
