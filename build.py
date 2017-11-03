import os
import sys
import shutil
#from subprocess import call
import subprocess

try:
    NDK_ROOT = os.environ['NDK_ROOT']
except KeyError, e:
    print "NDK_ROOT should be set for Android build"
    exit(1)
    
# set up envs
ANDROID_ROOT = "E:/workspace/android/cmake_build_ndk"
ANDROID_TOOLCHAIN_FILE = ANDROID_ROOT + "/android-cmake/android.toolchain.cmake"
ANDROID_NATIVE_API_LEVEL = 21
ANDROID_BUILD_JOBS = 2
ANDROID_ABIS = ["armeabi-v7a", "arm64-v8a"]

print "Android Build Root:", ANDROID_ROOT
print "Android NDK Root:", NDK_ROOT
print "Android Native API Level:", ANDROID_NATIVE_API_LEVEL
print "ANDROID_ABIS", ANDROID_ABIS


def build_project(ANDROID_ABI):
    SOURCE_ROOT = ANDROID_ROOT + "/native_project"
    SOURCE_BUILD = SOURCE_ROOT + "/build/" + ANDROID_ABI
    if not os.path.exists(SOURCE_BUILD):
        os.makedirs(SOURCE_BUILD)
    os.chdir(SOURCE_BUILD)
    print os.curdir
    print "ANDROID_ABI", ANDROID_ABI
    if sys.platform.startswith('win'):
        shell = True
    else:
        shell = False
    cmdlst = ["cmake", 
          "-DCMAKE_TOOLCHAIN_FILE="+ANDROID_TOOLCHAIN_FILE, 
          "-DANDROID_NDK="+NDK_ROOT,
          "-DANDROID_ABI="+ANDROID_ABI,
          "-DANDROID_NATIVE_API_LEVEL="+str(ANDROID_NATIVE_API_LEVEL),
          "-DCMAKE_BUILD_TYPE=Release",
          "-DANDROID_EXTRA_LIBRARY_PATH="+ANDROID_ROOT+"/"+ANDROID_ABI+"-install",
          "-G", "Unix Makefiles",
          SOURCE_ROOT]
    print " ".join(cmdlst)
    #call(cmdlst)
    p = subprocess.Popen(cmdlst, shell=shell)
    output = p.communicate()[0]
    print output
    subprocess.call(["make", "-j"+str(ANDROID_BUILD_JOBS)])
    
    
for ANDROID_ABI in ANDROID_ABIS:
    print "=" * 50
    print "build for", ANDROID_ABI
    build_project(ANDROID_ABI)

