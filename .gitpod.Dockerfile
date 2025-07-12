# .gitpod.Dockerfile
FROM gitpod/workspace-full:latest

# Android SDK + Java
USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
  openjdk-17-jdk \
  unzip \
  wget \
  lib32stdc++6 \
  lib32z1 \
  libgl1-mesa-dev \
  libgl1-mesa-glx \
  libglu1-mesa \
  && rm -rf /var/lib/apt/lists/*

# Install Android command-line tools
ENV ANDROID_SDK_ROOT=/opt/android-sdk
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools

WORKDIR $ANDROID_SDK_ROOT/cmdline-tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O sdk.zip && \
  unzip sdk.zip && \
  rm sdk.zip && \
  mv cmdline-tools latest && \
  mkdir cmdline-tools && \
  mv latest cmdline-tools/

# Accept licenses and install build tools
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/bin:$ANDROID_SDK_ROOT/platform-tools
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Set environment variables
ENV PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
