function update
    sudo snapper -c root create \
        --description "Gentoo world update" \
        --cleanup-algorithm number \
        --command "emerge --ask --verbose --update --deep --newuse @world"
end
