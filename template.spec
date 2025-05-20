# -*- mode: python ; coding: utf-8 -*-
import sys
sys.setrecursionlimit(5000)

block_cipher = None


a = Analysis(
    ['C:\\Users\\Admin\\Documents\\GitHub\DeuteRater-dev\\__main__.py'],
    pathex=['C:\\Users\\admin\\Desktop\\DeuteRater-dev'],
    binaries=[],
    datas=[('resources\*', 'resources'), ('ui_files\*', 'ui_files'), ('deuterater\*', 'deuterater'), ('utils\*', 'utils'), ('obs\*', 'obs'), ('gui_software\*', 'gui_software'), ('mpl_config\*', 'mpl_config')],
    hiddenimports=['more_itertools', 'yaml', 'pymzml'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='DeuteRater-v6',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='C:\\Users\\Admin\\Documents\\GitHub\\DeuteRater-dev\\resources\\Logo_64_clean.PNG',
)
coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='DeuteRater-v6',
)
