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
            size     = 20
        }
    }

    network_interface {
        subnet_id = "e2lo98or94hlh59236bt"          # default-ru-central1-b
        nat       = true
    }

    metadata = {
        ssh-keys = "debian:${file("../keys/id_rsa.pub")}"       # Путь до публичного ключа SSH
    }
}