PROTONVERSION=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep -E .tar.gz | grep -Eo '(GE-Proton)[^/]+' | grep -m1 "")

if [ -d ~/.steam/root/compatibilitytools.d/$PROTONVERSION ]; then
    echo "$PROTONVERSION exists."
    echo "Nothing to do."
else
    # move older versions if any exist (I hope you restart your pc sometimes because an "rm" requires sudo here)
    mv ~/.steam/root/compatibilitytools.d/GE-Proton* /tmp
    # make tmp working directory
    mkdir /tmp/proton-ge-custom
    cd /tmp/proton-ge-custom
    echo "$PROTONVERSION does not exist."
    # download  tarball
    curl -sLOJ $(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep -E .tar.gz)
    # download checksum
    curl -sLOJ $(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep -E .sha512sum)
    # check tarball with checksum
    sha512sum -c *.sha512sum
    # if result is ok, continue
    # make steam directory if it does not exist
    mkdir -p ~/.steam/root/compatibilitytools.d
    # extract proton tarball to steam directory
    tar -xf GE-Proton*.tar.gz -C ~/.steam/root/compatibilitytools.d/
    mkdir -p ~/.steam/root/compatibilitytools.d/Latest-GE-Proton
    mv ~/.steam/root/compatibilitytools.d/$PROTONVERSION/* ~/.steam/root/compatibilitytools.d/Latest-GE-Proton
    rmdir ~/.steam/root/compatibilitytools.d/$PROTONVERSION
    sed -i s/$PROTONVERSION/GE-Proton/g ~/.steam/root/compatibilitytools.d/Latest-GE-Proton/compatibilitytool.vdf
    echo "New GE-Proton version added!"
fi
