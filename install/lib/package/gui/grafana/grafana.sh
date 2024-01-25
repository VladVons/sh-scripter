PreInstall()
{
    File="grafana-enterprise_10.3.1_amd64.deb"

    wget "https://dl.grafana.com/enterprise/release/$File"
    dpkg -i $File
    rm $File
}
