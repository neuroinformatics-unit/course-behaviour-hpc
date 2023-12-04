"""
This script downloads all the pretrained tensorflow models that are available 
for DeepLabCut and saves them within the DeepLabCut installation directory
so that they don't have to be downloaded when creating a new project.

We use this script for the DeepLabCut module on the HPC, because users don't have
permission to write to the default directory. This needs to be run only once per
module version by the module maintainer, and then users can create projects
without running into permission errors.

Notes:
- the list of available models may have to be updated manually if new models
are added by DeepLabCut.
- the script needs to run with the module loaded, because it uses some DeepLabCut
functions to find the installation directory and to download the models.
- if you are running this script on a local machine, you should first activate
the conda environment that contains DeepLabCut.
"""

import deeplabcut as dlc
from pathlib import Path


project_dir = Path("/ceph/neuroinformatics/neuroinformatics/sirmpilatzen/DLC_HPC_test_data")
config_file_path = project_dir / "config.yaml"

DLC_PARENT_PATH = Path(dlc.auxiliaryfunctions.get_deeplabcut_path())
PRETRAINED_MODELS_DIR = DLC_PARENT_PATH / "pose_estimation_tensorflow" / "models" / "pretrained"
print(f"\nPretrained models directory: {PRETRAINED_MODELS_DIR}")

ALL_NET_TYPES = [
    "resnet_50",
    "resnet_101",
    "resnet_152",
    "mobilenet_v2_1.0",
    "mobilenet_v2_0.75",
    "mobilenet_v2_0.5",
    "mobilenet_v2_0.35",
    "efficientnet-b0",
    "efficientnet-b1",
    "efficientnet-b2",
    "efficientnet-b3",
    "efficientnet-b4",
    "efficientnet-b5",
    "efficientnet-b6",
]

def model_is_downloaded(net_type: str):
    """Check if the specified model type exists in the 
    pretrained models directory
    
    Parameters
    ----------
    net_type : str
        The type of model to check for.
    """

    if net_type in ["resnet_50", "resnet_101", "resnet_152"]:
        net_type = net_type.replace("resnet", "resnet_v1")
    for file_or_folder in PRETRAINED_MODELS_DIR.iterdir():
        if net_type in file_or_folder.name:
            return True
    return False


for net_type in ALL_NET_TYPES:

    if model_is_downloaded(net_type):
        print(f"Model for {net_type} has already been downloaded.\n")
    else:
        dlc.create_training_dataset(config_file_path, net_type=net_type)
        if model_is_downloaded(net_type):
            print(f"Model for {net_type} was downloaded succesfully.\n")
        else:
            print(f"Failed to download model for {net_type}.\n")
