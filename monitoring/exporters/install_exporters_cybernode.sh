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

    sudo ./scripts/install_smart_exporter.sh

else
    printf "Select exporter you want to install \n[1] Cadvisor\n[2] Nginx_exporter\n[3] Node_exporter, Smart_exporter and Prometheus\n[4] Smart exporter (requires node_exporter)\n"
    read -r  OPT
    case $OPT in

    1)
    sudo ./scripts/install_cadvisor.sh
    printf "\nInstalled cadvisor\n"
    ;;

    2)
    sudo ./scripts/install_nginx_exporter.sh
    printf "\nInstalled nginx_exporter\n"
    ;;

    3)
    sudo ./scripts/install_node-exporter.sh
    sudo ./scripts/install_prometheus.sh
    sudo ./scripts/install_smart_exporter.sh
    printf "\nInstalled Node Exporter, Smart Exporter and Prometheus\n"
    ;;

    4)
    sudo ./scripts/install_smart_exporter.sh
    printf "\nInstalled smart_exporter\n"
    ;;

#    3 | 4 | 5 )
#    echo -n "Done"
#    ;;
    *)
    echo -n "Nothing selected"
    ;;
    esac
fi

