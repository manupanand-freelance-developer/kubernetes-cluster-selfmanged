env="dev"
vpc_name     ="dev-private-vpc"
subnet_name  ="dev-kube-subnet"

cp_ingress={
 
    kube_api_server          =   {
                            port="6443"
                            #cidr of kube
                            }
    etcd                =   {
                            port="2379-2380"
                            #cidr of kube
                            }
    kubelet_api_sche_con_manger         =  {
                            port="10248-10260"
                            #cidr of kube
                            }
    internal               ={
                             port="65535"
                            }
    BGP_calico             ={
                             port="179"
                            }
#5473
    calico_typha          ={
                            port="5473"
                           }
    https                  ={
                            port="443"
    }
  
}
cp_udp_ingress={
                            #4789
                VXLAN       ={
                                port="4789"
                            }
                wire_guard  ={
                                port="51820-51821"
                            }
                            #UDP	51820-51821

}#IPinIP
cp_egress={  # remove outbound rule make it  0.0.0.0/0
    kubelet_api         =  {
                            port="10248-10260"
                            #cidr of kube
                            }
                            #10255
    node_port           =  {
                            port="30000-32767"
                            #cidr of kube
                            }
    BGP_calico          ={
                            port="179"
                        }
    calico_typha        ={
                            port="5473"
                         }
    https                  ={
                            port="443"
    }
}
cp_udp_egress={
    VXLAN               ={
                          port="4789"
    }
    wire_guard          ={
                        port="51820-51821"
    }
    #4789
    #UDP	51820-51821
}#IPinIP
worker_ingress={
    kubelet_api={
        port="10248-10260"
    }
    BGP_calico={
        port="179"
    }
    node_port={
        port="30000-32767"
    }
    internal={
        port="65535"
    }
    calico_typha={
        port="5473"
    }
    https={
        port="443"
    }


}
worker_udp_ingress={
    VXLAN={
        port="4789"
    }
    wire_guard={
        port="51820-51821"
    }
}
worker_egress={ # make it all onternt 0.0.0.0/0
    kube_api_server={
        port = "6433"
    }
    etcd={
        port="2379-2380"
    }
    kubelet={
        port="10248-10260"
    }
    BGP_calico={
        port="179"
    }
    calico_typha={
        port="5473"
    }
    https={
         port="443"
    }
}
worker_udp_egress={
        VXLAN={
            port="4789"
        }
        wire_guard={
            port="51820-51821"
        }
}
control_plane={
    master_node_1={
                instance_type= "c6i.large"#"t3.medium"  #intel
                policy_name=["AmazonEC2FullAccess","AmazonSSMFullAccess","AmazonS3ReadOnlyAccess","AmazonEKSClusterPolicy"]
                volume_size=30  
          }
  
}


worker_instance={
    worker-node-1={
                instance_type="t3.medium"  #intel
                policy_name=["AmazonEC2FullAccess","AmazonSSMFullAccess","AmazonS3ReadOnlyAccess","AmazonEKSWorkerNodePolicy"]
                volume_size=30  
          }
    #  worker_node_2={
    #             instance_type="t3.small" #intel
    #             policy_name=["AmazonEC2FullAccess","AmazonSSMFullAccess","AmazonS3ReadOnlyAccess","AmazonEKSWorkerNodePolicy"]
    #             volume_size=30  

    # }
    #  worker-node-2={
    #             instance_type="t3.small"  #intel
    #             policy_name=["AmazonEC2FullAccess","AmazonSSMFullAccess","AmazonS3ReadOnlyAccess","AmazonEKSWorkerNodePolicy"]
    #             volume_size=30  
        
    # }

}
