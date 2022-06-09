import yaml
import argparse
from util.log import create_logger
from model.model import LAMPMultiLabelClassifier

def main(opt):
    instructions = yaml.full_load(open(opt["instruction_file_path"]))
    logger = create_logger(instructions["log_dir"])
    lamp_config = yaml.full_load(open(opt["model_instructions"]))

    logger.log(level=20, msg=f"==== INSTRUCTIONS USED === ")
    logger.log(level=20, msg=instructions)
    logger.log(level=20, msg=f"==== ================= === ")

    # load word embedding matrix
    word2vec_weights = None

    # create model
    model = LAMPMultiLabelClassifier(lamp_config=lamp_config, word2vec_weights=word2vec_weights)
    # start training / visualization


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Image-to-Image Translation')
    parser.add_argument(
        '--instruction',
        type=str,
        dest="instruction_file_path",
        default="configs/basic_instructions.yaml"
    )
    parser.add_argument(
        "--override_args",
        action='append',
        type=lambda kv: {kv.split("=")[0]: kv.split("=")[1]},
        dest='override_args')

    opt = parser.parse_args().__dict__

    if opt["override_args"]:
        opt["override_args"] = dict(pair for d in opt["override_args"] for pair in d.items())
    print(opt)

    main(opt)