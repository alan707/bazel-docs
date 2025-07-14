---
date: '2024-01-01'
title: Android and Bazel
type: docs
weight: 1
---

This page contains resources that help you use Bazel with Android projects. It
links to a tutorial, build rules, and other information specific to building
Android projects with Bazel.

## Getting started

The following resources will help you work with Bazel on Android projects:

*  [Tutorial: Building an Android app](/start/android-app/). This
   tutorial is a good place to start learning about Bazel commands and concepts,
   and how to build Android apps with Bazel.
*  [Codelab: Building Android Apps with Bazel](https://developer.android.com/codelabs/bazel-android-intro#0).
   This codelab explains how to build Android apps with Bazel.

## Features

Bazel has Android rules for building and testing Android apps, integrating with
the SDK/NDK, and creating emulator images. There are also Bazel plugins for
Android Studio and IntelliJ.

*  [Android rules](/reference/be/android/). The Build Encyclopedia describes the rules
   for building and testing Android apps with Bazel.
*  [Integration with Android Studio](/install/ide/). Bazel is compatible with
   Android Studio using the [Android Studio with Bazel](https://ij.bazel.build/)
   plugin.
*  [`mobile-install` for Android](/docs/mobile-install/). Bazel's `mobile-install`
   feature provides automated build-and-deploy functionality for building and
   testing Android apps directly on Android devices and emulators.
*  [Android instrumentation testing](/docs/android-instrumentation-test/) on
   emulators and devices.
*  [Android NDK integration](/docs/android-ndk/). Bazel supports compiling to
   native code through direct NDK integration and the C++ rules.
*  [Android build performance](/docs/android-build-performance/). This page
   provides information on optimizing build performance for Android apps.

## Further reading

*  Integrating with dependencies from Google Maven and Maven Central with [rules_jvm_external](https://github.com/bazelbuild/rules_jvm_external).
*  Learn [How Android Builds Work in Bazel](https://blog.bazel.build/2018/02/14/how-android-builds-work-in-bazel.html).