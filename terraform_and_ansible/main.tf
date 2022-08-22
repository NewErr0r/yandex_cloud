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
        cores   = 2                                            
        memory  = 2                                           
    }

    boot_disk {
        initialize_params {
            image_id = "fd8987mnac4uroc0d16s"                 
            size     = 20                                     
        }
    }

    network_interface {
        subnet_id = "e2lo98or94hlh59236bt"                    
        nat       = true
    }

    scheduling_policy {
      preemptible = true                                     
    }

    metadata = {
        ssh-keys = "debian:${file("../keys/id_rsa.pub")}"     
    }
}
    data "template_file" "inventory" {
        template = file("./_templates/inventory.tpl")
  
        vars = {
            user = "debian"
            host = join("", [yandex_compute_instance.vm01.name, " ansible_host=", yandex_compute_instance.vm01.network_interface.0.nat_ip_address])
        }
    }

    resource "local_file" "save_inventory" {
        content  = data.template_file.inventory.rendered
        filename = "./inventory"
    }