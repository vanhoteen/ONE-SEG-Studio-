"""Remove display-only blocks before generating the studio transmitter."""
def configure(cfg):
    cfg['options']['parameters']['generate_options'] = 'no_gui'
    removed = {b['name'] for b in cfg['blocks'] if b['id'].startswith('qtgui_')}
    cfg['blocks'] = [b for b in cfg['blocks'] if b['name'] not in removed]
    cfg['connections'] = [c for c in cfg['connections'] if c[0] not in removed and c[2] not in removed]
    for b in cfg['blocks']:
        if b['id'].startswith(('variable_qtgui_', 'qtgui_')):
            b['id'] = 'variable'
            b['parameters'] = {'value': b['parameters'].get('value', '0')}
    return cfg
