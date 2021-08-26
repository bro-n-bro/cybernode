#/bin/bash

printf "Do you want to install all exporters (1) or just some of them (2)?\n"
read -r  CONT
echo
if [ "$CONT" = "1" ]
then

    sudo ./scripts/install_node-exporter.sh

    sudo ./scripts/install_prometheus.sh

    sudo ./scripts/install_cadvisor.sh

    sudo ./scripts/install_nginx_exporter.sh

else
    printf "Select exporter you want to install \n[1] Cadvisor\n[2] Nginx_exporter\n"
    read -r  OPT
    case $OPT in

    1)
    sudo ./scripts/install_cadvisor.sh
    echo -n "Installed cadvisor."
    ;;

    2)
    sudo ./scripts/install_nginx_exporter.sh
    echo -n "Installed nginx_exporter"
    ;;

#    3 | 4 | 5 )
#    echo -n "Done"
#    ;;

    *)
    echo -n "Nothing selected"
    ;;
    esac
fi

