@echo off
"C:\\Android\\cmake\\3.22.1\\bin\\cmake.exe" ^
  "-HC:\\src\\flutter\\packages\\flutter_tools\\gradle\\src\\main\\scripts" ^
  "-DCMAKE_SYSTEM_NAME=Android" ^
  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" ^
  "-DCMAKE_SYSTEM_VERSION=24" ^
  "-DANDROID_PLATFORM=android-24" ^
  "-DANDROID_ABI=arm64-v8a" ^
  "-DCMAKE_ANDROID_ARCH_ABI=arm64-v8a" ^
  "-DANDROID_NDK=C:\\Android\\ndk\\28.2.13676358" ^
  "-DCMAKE_ANDROID_NDK=C:\\Android\\ndk\\28.2.13676358" ^
  "-DCMAKE_TOOLCHAIN_FILE=C:\\Android\\ndk\\28.2.13676358\\build\\cmake\\android.toolchain.cmake" ^
  "-DCMAKE_MAKE_PROGRAM=C:\\Android\\cmake\\3.22.1\\bin\\ninja.exe" ^
  "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=C:\\MOBILE APP COURSE\\CuraCare\\build\\app\\intermediates\\cxx\\debug\\721x533v\\obj\\arm64-v8a" ^
  "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=C:\\MOBILE APP COURSE\\CuraCare\\build\\app\\intermediates\\cxx\\debug\\721x533v\\obj\\arm64-v8a" ^
  "-BC:\\MOBILE APP COURSE\\CuraCare\\build\\.cxx\\debug\\721x533v\\arm64-v8a" ^
  -GNinja ^
  -Wno-dev ^
  --no-warn-unused-cli ^
  "-DCMAKE_BUILD_TYPE=debug"
