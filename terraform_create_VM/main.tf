terraform {
  required_providers {
    yandex      = {
      source    = "yandex-cloud/yandex"
      version   = "0.77.0"
    }
  }
}

provider "yandex" {
  token     = "<OAuth>"
  cloud_id  = "<идентификатор облака>"
  folder_id = "<идентификатор каталога>"
  zone      = "<зона доступности по умолчанию>"
}

resource "yandex_compute_instance" "vm01" {
    name    = "vm01"  

    resources {
        cores   = 2                                 # ядра 
        memory  = 2                                 # ОЗУ
    }

    boot_disk {
        initialize_params {
            image_id = "fd8987mnac4uroc0d16s"       # Debian 11
        }
    }

    network_interface {
        subnet_id = yandex_vpc_subnet.subnet_terraform.id
        nat       = true
    }

    metadata = {
        user-data = "${file("./meta.yaml")}"
    }
}

resource "yandex_vpc_network" "network_terraform" {
    name    = "net_terraform"  
}

resource "yandex_vpc_subnet" "subnet_terraform" {
    name            = "sub_terraform"
    zone            = "ru-central1-b"
    network_id      = yandex_vpc_network.network_terraform.id
    v4_cidr_blocks  = ["192.168.15.0/24"]           # Внутренняя сеть
}