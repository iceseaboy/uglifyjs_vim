" Version:      1.0
" Last Change:  2010.11.06
" Maintainer:   Zhou Feng

if has('python')
  command! UGjs python compressorJS()
  command! BTjs python beautifyJS()
  map <silent> <Leader>ug :UGjs <CR>
  map <silent> <Leader>bt :BTjs <CR>
else
  command! UGjs echo 'Only avaliable with +python support.'
endif

if has('python')
python << EOF

def uglifyJS(beautify):
  import httplib, urllib
  import vim

  host = "10.11.20.79:8081"
  data = {
    'code':'\n'.join(vim.current.buffer),
    'responsetype':'text'
  }
  if beautify:
    data['beautify'] = 'on'

  headers = {"Content-Type":"application/x-www-form-urlencoded",
    "Connection":"Keep-Alive"}

  conn = httplib.HTTPConnection(host)
  conn.request(method="POST",url="/?name=XXX",body=urllib.urlencode(data),headers=headers)
  response = conn.getresponse()
  res = response.read().strip()
  conn.close()

  return res

def compressorJS():
  recode = uglifyJS(beautify=False)
  import vim
  vim.command("call setreg('+', '%s')" % recode)
  vim.command("call setreg('*', '%s')" % recode)

def beautifyJS():
  recode = uglifyJS(beautify=True)
  import vim
  vim.command("call setreg('+', '%s')" % recode)
  vim.command("call setreg('*', '%s')" % recode)
EOF
endif
