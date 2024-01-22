import configparser
def get_variables(config_path="./config.ini"):
    config = configparser.ConfigParser()
    config.read(config_path)

    variables = {}
    print(config.sections)
    for section in config.sections():
        for key, value in config.items(section):
            var = "%s.%s" % (section, key)
            variables[var] = value
    return variables