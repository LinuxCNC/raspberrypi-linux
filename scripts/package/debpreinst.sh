cat <<EOF
#!/bin/sh

set -e

# Pass maintainer script parameters to hook scripts
export DEB_MAINT_PARAMS="\$*"

# Tell initramfs builder whether it's wanted
export INITRD=$want_initrd

mkdir -p /usr/share/rpikernelhack/overlays
mkdir -p /boot/overlays

EOF


(cd $tmpdir/boot; find . -type f) | while read fn; do
	dfn=/usr/share/rpikernelhack/"$fn"
	echo dpkg-divert --package rpikernelhack --rename --divert "$dfn" "/boot/$fn"
done

cat <<EOF
test -d $debhookdir/$script.d && run-parts --arg="$version" --arg="/$installed_image_path" $debhookdir/$script.d
exit 0
EOF
