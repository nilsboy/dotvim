import re

def toggle(t, opt):
  opts = t.split('|')
  pos = opts.index(opt)
  if len(opts) == pos + 1:
    pos = 0
  else:
    pos = pos + 1
  return opts[pos]

# def toCamelCase(v):
#   v = re.sub(r'(.+)\.[^.]*$', r'\1', v)
#   v = re.sub(r'[\.\/]*', r'', v)
#   v = v.title()
#   v = re.sub(r'[\W\-_]*', '', v)
#   return v

def toCamelCase(v):
  v = re.sub(r'.*/', r'', v)
  return re.sub(r'(\W)', r'', v.title())
  return v
  v = re.sub(r'^[\/\.]+', r'', v)
  return v
  return v.title()
  return re.sub(r'(\W)', r'', v.title())

def toMethodCase(v):
  v = re.sub(r'(.+)\.[^.]*$', r'\1', v)
  v = re.sub(r'[\.\/]*', r'', v)
  return v[0:1].lower() + re.sub(r'(\W)', r'', v.title()[1:])

def toSnakeCase(v):
  s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', v)
  return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

def toSnailCase(v):
  s1 = re.sub('(.)([A-Z][a-z]+)', r'\1-\2', v)
  return re.sub('([a-z0-9])([A-Z])', r'\1-\2', s1).lower()

def classNameOld(snip):
  v = snip.basename[0:1].upper()
  v = v + re.sub(r'(\W)', r'', snip.basename.title()[1:])
  return v

def className(snip):
  v = snip.basename[0:1].upper()
  v = v + snip.basename[1:]
  return v

def classNameSingular(snip):
  v = snip.basename[0:1].upper()
  v = v + snip.basename[1:]
  v = re.sub(r'Contexts$', r'Context', v)
  return v

def classNameWithoutContext(snip):
  v = snip.basename[0:1].upper()
  v = v + snip.basename[1:]
  v = re.sub(r'Context$', r'', v)
  return v

def escape(v):
  return re.sub(r'`', r'\`', v)

def enum(t, opts):
  if t:
    opts = [m[len(t):] for m in opts if m.startswith(t)]
  if len(opts) == 1:
    return opts[0]
  return '|'.join(opts)

def ucfirst(v):
  return v[0].upper() + v[1:]

# clean file name to produce a name for vim var usage
def cfname(v):
  v = re.sub(r'\W', r'_', v).lower()
  v = re.sub(r'^my_', '', v)
  v = re.sub(r'vim_', '', v)
  v = re.sub(r'_vim', '', v)
  return 'My_' + v

def fncc(v):
  return toCamelCase(cfname(v))

def sec_title(snip, t):
	file_start = snip.fn.split('.')[0]
	sec_name = t[1].strip("1234567890. ").lower().replace(' ', '-')
	return ("*%s-%s*" % (file_start, sec_name)).rjust(78-len(t[1]))

