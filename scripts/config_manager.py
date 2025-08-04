import platform
import json
import argparse
import shutil
import os
import os.path

from dataclasses import dataclass
from enum import Enum

@dataclass
class ConfigDeployDesc:
    path: str

@dataclass
class Settings:
    backup: bool = True

class Mode(Enum):
    UPDATE = 1
    DEPLOY = 2

def get_system_codename() :
    system_name = platform.system().lower()
    if system_name in ("darwin", "windows"):
        return system_name
    else:
        raise RuntimeError(f"Unknown system '{system_name}'")

def copy_file(src_path, dst_path):
    os.makedirs(os.path.dirname(dst_path), exist_ok=True)
    shutil.copy2(src_path, dst_path)

def copy_dir(src_path, dst_path):
    os.makedirs(os.path.dirname(dst_path), exist_ok=True)
    shutil.copytree(src_path, dst_path, dirs_exist_ok=True) 

def expand_path(path):
    return os.path.normpath(os.path.expanduser(os.path.expandvars((path))))

def delete_dir(dir_path):
    if not os.path.exists(dir_path):
        return

    if not os.path.isdir(dir_path):
        raise RuntimeError("{dir_path} is not a directory")

    shutil.rmtree(dir_path)

def delete_file(file_path):
    if not os.path.exists(file_path):
        return
    os.remove(file_path)

def backup_config(path):
    if not os.path.exists(path):
        return

    if os.path.isdir(path):
        dir_name = os.path.basename(path)
        backup_path = os.path.join(os.path.dirname(path), dir_name + ".bak")
        delete_dir(backup_path)
        shutil.copytree(path, backup_path, dirs_exist_ok=True) 
    else:
        backup_path = path + ".bak"
        delete_file(backup_path)
        copy_file(path, backup_path)


def deploy_config(cfg_name, cfg_path, cfg_deploy_desc, settings):
    print(f"Deploying config '{cfg_name}'")

    system_path = expand_path(cfg_deploy_desc.path)
    config_path = expand_path(cfg_path)

    if not os.path.exists(config_path):
       raise RuntimeError(f"Cannot find system path {config_path}")

    if settings.backup:
        backup_config(system_path)

    if os.path.isdir(config_path):
        delete_dir(system_path)
        copy_dir(config_path, system_path) 
    else:
        delete_file(system_path)
        copy_file(config_path, system_path)

def update_config(cfg_name, cfg_path, cfg_deploy_desc):
    print(f"Updating config '{cfg_name}'")

    system_path = expand_path(cfg_deploy_desc.path)
    config_path = expand_path(cfg_path)

    if not os.path.exists(system_path):
        raise RuntimeError(f"Cannot find system path {system_path}")

    if os.path.isdir(system_path):
        delete_dir(config_path)
        copy_dir(system_path, config_path) 
    else:
        delete_file(config_path)
        copy_file(system_path, config_path)

if __name__ == "__main__" :
    system_name = get_system_codename()
    print(f"System: {system_name}")

    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=str, dest="cfg_path", required=True)
    parser.add_argument("--mode", choices=["deploy", "update"], dest="mode", required=True)
    args = parser.parse_args()

    mode = Mode.DEPLOY if args.mode=="deploy" else  Mode.UPDATE
    cfg_path = expand_path(args.cfg_path)
    curr_dir_path = os.path.dirname(cfg_path)

    print(f"Loading config {cfg_path}")
    with open(cfg_path, "r") as f:
        config_doc = json.load(f)

    settings_elem = config_doc.get("settings") 
    settings = Settings()
    if settings_elem:
       settings = Settings(**settings_elem) 

    configs_elem = config_doc["configs"]
    for cfg_name, desc_elem in configs_elem.items():
       deploy_elem = desc_elem["deploy"].get(system_name)
       if not deploy_elem:
           continue

       deploy_system_desc = ConfigDeployDesc(**deploy_elem) 

       if mode == Mode.UPDATE:
            update_config(cfg_name = cfg_name, 
                          cfg_path = os.path.join(curr_dir_path, desc_elem["config"]),
                          cfg_deploy_desc = deploy_system_desc)
       else:
            deploy_config(cfg_name = cfg_name, 
                          cfg_path = os.path.join(curr_dir_path, desc_elem["config"]),
                          cfg_deploy_desc = deploy_system_desc,
                          settings=settings)

