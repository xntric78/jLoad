#!/bin/bash
#
# jmeter-ec2 - Install Script (Runs on remote ec2 server)
#

function install_jmeter_plugins() {
    echo "Installing plugins..."
    wget -q -O ~/JMeterPlugins-Extras.jar https://s3.amazonaws.com/jmeter-ec2/JMeterPlugins-Extras.jar
    wget -q -O ~/JMeterPlugins-Standard.jar https://s3.amazonaws.com/jmeter-ec2/JMeterPlugins-Standard.jar
    mv ~/JMeterPlugins*.jar "$JMETER_HOME$JMETER_VERSION/lib/ext/"

    echo "Installing JMeter Plugins Manager"
    wget -q -O - https://jmeter-plugins.org/get/ > ~/jmeter-plugins-manager.jar
    mv ~/jmeter-plugins-manager.jar "$JMETER_HOME$JMETER_VERSION/lib/ext/"
    wget -q -O ~/cmdrunner-2.0.jar https://repo1.maven.org/maven2/kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar
    mv cmdrunner-2.0.jar "$JMETER_HOME$JMETER_VERSION/lib/"

    java -cp "$JMETER_HOME$JMETER_VERSION/lib/ext/jmeter-plugins-manager.jar" org.jmeterplugins.repository.PluginManagerCMDInstaller

    # "$JMETER_HOME$JMETER_VERSION/bin/PluginsManagerCMD.sh install jpgc-graphs-basic,jpgc-graphs-additional,jpgc-autostop,jpgc-sense,blazemeter-debugger,jpgc-cmd,jpgc-graphs-composite,jpgc-csl,jpgc-functions,jpgc-casutg,jpgc-dbmon,jpgc-graphs-dist,jpgc-dummy,jmeter-ftp,jpgc-filterresults,jpgc-ffw,jpgc-ggl,jmeter-http,jpgc-httpraw,jpgc-sts,jpgc-hadoop,jpgc-fifo,jmeter-jdbc,jpgc-jms"
    #
    # "$JMETER_HOME$JMETER_VERSION/bin/PluginsManagerCMD.sh install jmeter-jms,jpgc-jmxmon,jmeter-core,jpgc-json,jmeter-junit,jmeter-java,jpgc-graphs-vs,jmeter-ldap,jpgc-lockfile,jmeter-mail,jpgc-mergeresults,jmeter-mongodb,jpgc-oauth,jmeter-native,jpgc-pde,jpgc-prmctl,jpgc-perfmon,jpgc-plugins-manager,jpgc-webdriver,jpgc-synthesis,jmeter-tcp,jpgc-plancheck,jpgc-tst,jpgc-udp,jpgc-csvars,jmeter-components,jpgc-wsc,jpgc-xml,jpgc-standard"
}

function install_java() {
    echo "Updating yum..."
    #yum-config-manager --enable epel
    #yum update -y

    echo "Installing java 1.8..."
    yum install java-1.8.0-openjdk-devel -y

    echo "Removing java 1.7..."
    yum remove java-1.7.0-openjdk -y

    echo "Java installed"
}

function install_jmeter() {
    # ------------------------------------------------
    #      Decide where to download jmeter from
    #
    # Order of preference:
    #   1. S3, if we have a copy of the file
    #   2. Mirror, if the desired version is current
    #   3. Archive, as a backup
    # ------------------------------------------------
    if [ $(curl -sI https://s3.amazonaws.com/jmeter-ec2/$JMETER_VERSION.tgz | grep -c "403 Forbidden") -eq "0" ] ; then
        # We have a copy on S3 so use that
        echo "Downloading jmeter from S3..."
        wget -q -O ~/$JMETER_VERSION.tgz https://s3.amazonaws.com/jmeter-ec2/$JMETER_VERSION.tgz
    elif [ $(echo $(curl -s 'http://www.apache.org/dist/jmeter/binaries/') | grep -c "$JMETER_VERSION") -gt "0" ] ; then
        # Nothing found on S3 but this is the current version of jmeter so use the preferred mirror to download
        echo "downloading jmeter from a Mirror..."
        wget -q -O ~/$JMETER_VERSION.tgz "http://www.apache.org/dyn/closer.cgi?filename=jmeter/binaries/$JMETER_VERSION.tgz&action=download"
    else
        # Fall back to the archive server
        echo "Downloading jmeter from Apache Archive..."
        wget -q -O ~/$JMETER_VERSION.tgz http://archive.apache.org/dist/jmeter/binaries/$JMETER_VERSION.tgz
    fi
    # Untar downloaded file
    echo "Unpacking jmeter..."
    tar -xzf ~/$JMETER_VERSION.tgz -C $JMETER_HOME
    # install jmeter-plugins [http://code.google.com/p/jmeter-plugins/]
    install_jmeter_plugins
    echo "Jmeter installed"

    #"ln -s $JMETER_HOME$JMETER_VERSION/ $JMETER_HOMEjmeter"
}

JMETER_VERSION="apache-jmeter-3.2"
JMETER_HOME=/opt/
cd ~

# Java

install_java
install_jmeter
