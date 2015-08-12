FROM beevelop/java
MAINTAINER Maik Hummel <m@ikhummel.com>

# Build-Variables
ENV ANDROID_SDK_FILENAME android-sdk_r24.3.3-linux.tgz
ENV ANDROID_SDK_URL https://dl.google.com/android/${ANDROID_SDK_FILENAME}
ENV ANDROID_BUILD_TOOLS_VERSION 22.0.1
ENV ANDROID_APIS android-10,android-15,android-16,android-17,android-18,android-19,android-20,android-21,android-22

RUN apt-get update -yqq
RUN apt-get install -yqq wget

# install 32-bit dependencies require by the android sdk
RUN dpkg --add-architecture i386
RUN apt-get update -yqq
RUN apt-get install -yqq libncurses5:i386 libstdc++6:i386 zlib1g:i386

# install Ant
RUN apt-get install -yqq ant

# install Gradle
RUN apt-get install -yqq gradle

RUN cd /opt

# Installs Android SDK
RUN wget -q ${ANDROID_SDK_URL}
RUN tar xf ${ANDROID_SDK_FILENAME}
RUN echo y | android update sdk --filter ${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION},platform-tools,tools --no-ui -a

# Set Environment Variables
ENV ANT_HOME /usr/share/ant
ENV MAVEN_HOME /usr/share/maven
ENV GRADLE_HOME /usr/share/gradle
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$ANT_HOME/bin
ENV PATH $PATH:$MAVEN_HOME/bin
ENV PATH $PATH:$GRADLE_HOME/bin

# Clean up
RUN rm ${ANDROID_SDK_FILENAME}
RUN apt-get autoremove -y
RUN apt-get clean