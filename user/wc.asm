
wc:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	57                   	push   %edi
   8:	56                   	push   %esi
   9:	53                   	push   %ebx
   a:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  14:	be 00 00 00 00       	mov    $0x0,%esi
  19:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	68 00 02 00 00       	push   $0x200
  2f:	68 80 08 00 00       	push   $0x880
  34:	ff 75 08             	pushl  0x8(%ebp)
  37:	e8 fb 02 00 00       	call   337 <read>
  3c:	89 c7                	mov    %eax,%edi
  3e:	83 c4 10             	add    $0x10,%esp
  41:	85 c0                	test   %eax,%eax
  43:	7e 4d                	jle    92 <wc+0x92>
    for(i=0; i<n; i++){
  45:	bb 00 00 00 00       	mov    $0x0,%ebx
  4a:	eb 20                	jmp    6c <wc+0x6c>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  4c:	83 ec 08             	sub    $0x8,%esp
  4f:	0f be c0             	movsbl %al,%eax
  52:	50                   	push   %eax
  53:	68 b8 05 00 00       	push   $0x5b8
  58:	e8 9f 01 00 00       	call   1fc <strchr>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	85 c0                	test   %eax,%eax
  62:	74 1c                	je     80 <wc+0x80>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  6b:	43                   	inc    %ebx
  6c:	39 fb                	cmp    %edi,%ebx
  6e:	7d b7                	jge    27 <wc+0x27>
      c++;
  70:	46                   	inc    %esi
      if(buf[i] == '\n')
  71:	8a 83 80 08 00 00    	mov    0x880(%ebx),%al
  77:	3c 0a                	cmp    $0xa,%al
  79:	75 d1                	jne    4c <wc+0x4c>
        l++;
  7b:	ff 45 e0             	incl   -0x20(%ebp)
  7e:	eb cc                	jmp    4c <wc+0x4c>
      else if(!inword){
  80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  84:	75 e5                	jne    6b <wc+0x6b>
        w++;
  86:	ff 45 dc             	incl   -0x24(%ebp)
        inword = 1;
  89:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  90:	eb d9                	jmp    6b <wc+0x6b>
      }
    }
  }
  if(n < 0){
  92:	78 24                	js     b8 <wc+0xb8>
    printf(1, "wc: read error\n");
    exit(0);
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  94:	83 ec 08             	sub    $0x8,%esp
  97:	ff 75 0c             	pushl  0xc(%ebp)
  9a:	56                   	push   %esi
  9b:	ff 75 dc             	pushl  -0x24(%ebp)
  9e:	ff 75 e0             	pushl  -0x20(%ebp)
  a1:	68 ce 05 00 00       	push   $0x5ce
  a6:	6a 01                	push   $0x1
  a8:	e8 b1 03 00 00       	call   45e <printf>
}
  ad:	83 c4 20             	add    $0x20,%esp
  b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  b3:	5b                   	pop    %ebx
  b4:	5e                   	pop    %esi
  b5:	5f                   	pop    %edi
  b6:	5d                   	pop    %ebp
  b7:	c3                   	ret    
    printf(1, "wc: read error\n");
  b8:	83 ec 08             	sub    $0x8,%esp
  bb:	68 be 05 00 00       	push   $0x5be
  c0:	6a 01                	push   $0x1
  c2:	e8 97 03 00 00       	call   45e <printf>
    exit(0);
  c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ce:	e8 4c 02 00 00       	call   31f <exit>

000000d3 <main>:

int
main(int argc, char *argv[])
{
  d3:	f3 0f 1e fb          	endbr32 
  d7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  db:	83 e4 f0             	and    $0xfffffff0,%esp
  de:	ff 71 fc             	pushl  -0x4(%ecx)
  e1:	55                   	push   %ebp
  e2:	89 e5                	mov    %esp,%ebp
  e4:	57                   	push   %edi
  e5:	56                   	push   %esi
  e6:	53                   	push   %ebx
  e7:	51                   	push   %ecx
  e8:	83 ec 18             	sub    $0x18,%esp
  eb:	8b 01                	mov    (%ecx),%eax
  ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  f0:	8b 51 04             	mov    0x4(%ecx),%edx
  f3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  f6:	83 f8 01             	cmp    $0x1,%eax
  f9:	7e 3e                	jle    139 <main+0x66>
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
  fb:	be 01 00 00 00       	mov    $0x1,%esi
 100:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
 103:	7d 6c                	jge    171 <main+0x9e>
    if((fd = open(argv[i], 0)) < 0){
 105:	8b 45 e0             	mov    -0x20(%ebp),%eax
 108:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 10b:	83 ec 08             	sub    $0x8,%esp
 10e:	6a 00                	push   $0x0
 110:	ff 37                	pushl  (%edi)
 112:	e8 48 02 00 00       	call   35f <open>
 117:	89 c3                	mov    %eax,%ebx
 119:	83 c4 10             	add    $0x10,%esp
 11c:	85 c0                	test   %eax,%eax
 11e:	78 34                	js     154 <main+0x81>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit(0);
    }
    wc(fd, argv[i]);
 120:	83 ec 08             	sub    $0x8,%esp
 123:	ff 37                	pushl  (%edi)
 125:	50                   	push   %eax
 126:	e8 d5 fe ff ff       	call   0 <wc>
    close(fd);
 12b:	89 1c 24             	mov    %ebx,(%esp)
 12e:	e8 14 02 00 00       	call   347 <close>
  for(i = 1; i < argc; i++){
 133:	46                   	inc    %esi
 134:	83 c4 10             	add    $0x10,%esp
 137:	eb c7                	jmp    100 <main+0x2d>
    wc(0, "");
 139:	83 ec 08             	sub    $0x8,%esp
 13c:	68 cd 05 00 00       	push   $0x5cd
 141:	6a 00                	push   $0x0
 143:	e8 b8 fe ff ff       	call   0 <wc>
    exit(0);
 148:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 14f:	e8 cb 01 00 00       	call   31f <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
 154:	83 ec 04             	sub    $0x4,%esp
 157:	ff 37                	pushl  (%edi)
 159:	68 db 05 00 00       	push   $0x5db
 15e:	6a 01                	push   $0x1
 160:	e8 f9 02 00 00       	call   45e <printf>
      exit(0);
 165:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 16c:	e8 ae 01 00 00       	call   31f <exit>
  }
  exit(0);
 171:	83 ec 0c             	sub    $0xc,%esp
 174:	6a 00                	push   $0x0
 176:	e8 a4 01 00 00       	call   31f <exit>

0000017b <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 17b:	f3 0f 1e fb          	endbr32 
}
 17f:	c3                   	ret    

00000180 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 180:	f3 0f 1e fb          	endbr32 
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	56                   	push   %esi
 188:	53                   	push   %ebx
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18f:	89 c2                	mov    %eax,%edx
 191:	89 cb                	mov    %ecx,%ebx
 193:	41                   	inc    %ecx
 194:	89 d6                	mov    %edx,%esi
 196:	42                   	inc    %edx
 197:	8a 1b                	mov    (%ebx),%bl
 199:	88 1e                	mov    %bl,(%esi)
 19b:	84 db                	test   %bl,%bl
 19d:	75 f2                	jne    191 <strcpy+0x11>
    ;
  return os;
}
 19f:	5b                   	pop    %ebx
 1a0:	5e                   	pop    %esi
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    

000001a3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a3:	f3 0f 1e fb          	endbr32 
 1a7:	55                   	push   %ebp
 1a8:	89 e5                	mov    %esp,%ebp
 1aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1b0:	8a 01                	mov    (%ecx),%al
 1b2:	84 c0                	test   %al,%al
 1b4:	74 08                	je     1be <strcmp+0x1b>
 1b6:	3a 02                	cmp    (%edx),%al
 1b8:	75 04                	jne    1be <strcmp+0x1b>
    p++, q++;
 1ba:	41                   	inc    %ecx
 1bb:	42                   	inc    %edx
 1bc:	eb f2                	jmp    1b0 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 1be:	0f b6 c0             	movzbl %al,%eax
 1c1:	0f b6 12             	movzbl (%edx),%edx
 1c4:	29 d0                	sub    %edx,%eax
}
 1c6:	5d                   	pop    %ebp
 1c7:	c3                   	ret    

000001c8 <strlen>:

uint
strlen(const char *s)
{
 1c8:	f3 0f 1e fb          	endbr32 
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1d2:	b8 00 00 00 00       	mov    $0x0,%eax
 1d7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1db:	74 03                	je     1e0 <strlen+0x18>
 1dd:	40                   	inc    %eax
 1de:	eb f7                	jmp    1d7 <strlen+0xf>
    ;
  return n;
}
 1e0:	5d                   	pop    %ebp
 1e1:	c3                   	ret    

000001e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e2:	f3 0f 1e fb          	endbr32 
 1e6:	55                   	push   %ebp
 1e7:	89 e5                	mov    %esp,%ebp
 1e9:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1ea:	8b 7d 08             	mov    0x8(%ebp),%edi
 1ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f3:	fc                   	cld    
 1f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	5f                   	pop    %edi
 1fa:	5d                   	pop    %ebp
 1fb:	c3                   	ret    

000001fc <strchr>:

char*
strchr(const char *s, char c)
{
 1fc:	f3 0f 1e fb          	endbr32 
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 209:	8a 10                	mov    (%eax),%dl
 20b:	84 d2                	test   %dl,%dl
 20d:	74 07                	je     216 <strchr+0x1a>
    if(*s == c)
 20f:	38 ca                	cmp    %cl,%dl
 211:	74 08                	je     21b <strchr+0x1f>
  for(; *s; s++)
 213:	40                   	inc    %eax
 214:	eb f3                	jmp    209 <strchr+0xd>
      return (char*)s;
  return 0;
 216:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21b:	5d                   	pop    %ebp
 21c:	c3                   	ret    

0000021d <gets>:

char*
gets(char *buf, int max)
{
 21d:	f3 0f 1e fb          	endbr32 
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	57                   	push   %edi
 225:	56                   	push   %esi
 226:	53                   	push   %ebx
 227:	83 ec 1c             	sub    $0x1c,%esp
 22a:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22d:	bb 00 00 00 00       	mov    $0x0,%ebx
 232:	89 de                	mov    %ebx,%esi
 234:	43                   	inc    %ebx
 235:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 238:	7d 2b                	jge    265 <gets+0x48>
    cc = read(0, &c, 1);
 23a:	83 ec 04             	sub    $0x4,%esp
 23d:	6a 01                	push   $0x1
 23f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 242:	50                   	push   %eax
 243:	6a 00                	push   $0x0
 245:	e8 ed 00 00 00       	call   337 <read>
    if(cc < 1)
 24a:	83 c4 10             	add    $0x10,%esp
 24d:	85 c0                	test   %eax,%eax
 24f:	7e 14                	jle    265 <gets+0x48>
      break;
    buf[i++] = c;
 251:	8a 45 e7             	mov    -0x19(%ebp),%al
 254:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 257:	3c 0a                	cmp    $0xa,%al
 259:	74 08                	je     263 <gets+0x46>
 25b:	3c 0d                	cmp    $0xd,%al
 25d:	75 d3                	jne    232 <gets+0x15>
    buf[i++] = c;
 25f:	89 de                	mov    %ebx,%esi
 261:	eb 02                	jmp    265 <gets+0x48>
 263:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 265:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 269:	89 f8                	mov    %edi,%eax
 26b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 26e:	5b                   	pop    %ebx
 26f:	5e                   	pop    %esi
 270:	5f                   	pop    %edi
 271:	5d                   	pop    %ebp
 272:	c3                   	ret    

00000273 <stat>:

int
stat(const char *n, struct stat *st)
{
 273:	f3 0f 1e fb          	endbr32 
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	56                   	push   %esi
 27b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27c:	83 ec 08             	sub    $0x8,%esp
 27f:	6a 00                	push   $0x0
 281:	ff 75 08             	pushl  0x8(%ebp)
 284:	e8 d6 00 00 00       	call   35f <open>
  if(fd < 0)
 289:	83 c4 10             	add    $0x10,%esp
 28c:	85 c0                	test   %eax,%eax
 28e:	78 24                	js     2b4 <stat+0x41>
 290:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 292:	83 ec 08             	sub    $0x8,%esp
 295:	ff 75 0c             	pushl  0xc(%ebp)
 298:	50                   	push   %eax
 299:	e8 d9 00 00 00       	call   377 <fstat>
 29e:	89 c6                	mov    %eax,%esi
  close(fd);
 2a0:	89 1c 24             	mov    %ebx,(%esp)
 2a3:	e8 9f 00 00 00       	call   347 <close>
  return r;
 2a8:	83 c4 10             	add    $0x10,%esp
}
 2ab:	89 f0                	mov    %esi,%eax
 2ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b0:	5b                   	pop    %ebx
 2b1:	5e                   	pop    %esi
 2b2:	5d                   	pop    %ebp
 2b3:	c3                   	ret    
    return -1;
 2b4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2b9:	eb f0                	jmp    2ab <stat+0x38>

000002bb <atoi>:

int
atoi(const char *s)
{
 2bb:	f3 0f 1e fb          	endbr32 
 2bf:	55                   	push   %ebp
 2c0:	89 e5                	mov    %esp,%ebp
 2c2:	53                   	push   %ebx
 2c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2c6:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2cb:	8a 01                	mov    (%ecx),%al
 2cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2d0:	80 fb 09             	cmp    $0x9,%bl
 2d3:	77 10                	ja     2e5 <atoi+0x2a>
    n = n*10 + *s++ - '0';
 2d5:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2d8:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 2db:	41                   	inc    %ecx
 2dc:	0f be c0             	movsbl %al,%eax
 2df:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 2e3:	eb e6                	jmp    2cb <atoi+0x10>
  return n;
}
 2e5:	89 d0                	mov    %edx,%eax
 2e7:	5b                   	pop    %ebx
 2e8:	5d                   	pop    %ebp
 2e9:	c3                   	ret    

000002ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ea:	f3 0f 1e fb          	endbr32 
 2ee:	55                   	push   %ebp
 2ef:	89 e5                	mov    %esp,%ebp
 2f1:	56                   	push   %esi
 2f2:	53                   	push   %ebx
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2f9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 2fc:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 2fe:	8d 72 ff             	lea    -0x1(%edx),%esi
 301:	85 d2                	test   %edx,%edx
 303:	7e 0e                	jle    313 <memmove+0x29>
    *dst++ = *src++;
 305:	8a 13                	mov    (%ebx),%dl
 307:	88 11                	mov    %dl,(%ecx)
 309:	8d 5b 01             	lea    0x1(%ebx),%ebx
 30c:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 30f:	89 f2                	mov    %esi,%edx
 311:	eb eb                	jmp    2fe <memmove+0x14>
  return vdst;
}
 313:	5b                   	pop    %ebx
 314:	5e                   	pop    %esi
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    

00000317 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 317:	b8 01 00 00 00       	mov    $0x1,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <exit>:
SYSCALL(exit)
 31f:	b8 02 00 00 00       	mov    $0x2,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <wait>:
SYSCALL(wait)
 327:	b8 03 00 00 00       	mov    $0x3,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <pipe>:
SYSCALL(pipe)
 32f:	b8 04 00 00 00       	mov    $0x4,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <read>:
SYSCALL(read)
 337:	b8 05 00 00 00       	mov    $0x5,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <write>:
SYSCALL(write)
 33f:	b8 10 00 00 00       	mov    $0x10,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <close>:
SYSCALL(close)
 347:	b8 15 00 00 00       	mov    $0x15,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <kill>:
SYSCALL(kill)
 34f:	b8 06 00 00 00       	mov    $0x6,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <exec>:
SYSCALL(exec)
 357:	b8 07 00 00 00       	mov    $0x7,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <open>:
SYSCALL(open)
 35f:	b8 0f 00 00 00       	mov    $0xf,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <mknod>:
SYSCALL(mknod)
 367:	b8 11 00 00 00       	mov    $0x11,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <unlink>:
SYSCALL(unlink)
 36f:	b8 12 00 00 00       	mov    $0x12,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <fstat>:
SYSCALL(fstat)
 377:	b8 08 00 00 00       	mov    $0x8,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <link>:
SYSCALL(link)
 37f:	b8 13 00 00 00       	mov    $0x13,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <mkdir>:
SYSCALL(mkdir)
 387:	b8 14 00 00 00       	mov    $0x14,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <chdir>:
SYSCALL(chdir)
 38f:	b8 09 00 00 00       	mov    $0x9,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <dup>:
SYSCALL(dup)
 397:	b8 0a 00 00 00       	mov    $0xa,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <getpid>:
SYSCALL(getpid)
 39f:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <sbrk>:
SYSCALL(sbrk)
 3a7:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <sleep>:
SYSCALL(sleep)
 3af:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <uptime>:
SYSCALL(uptime)
 3b7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <date>:
SYSCALL(date)
 3bf:	b8 16 00 00 00       	mov    $0x16,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <dup2>:
 3c7:	b8 17 00 00 00       	mov    $0x17,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 1c             	sub    $0x1c,%esp
 3d5:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3d8:	6a 01                	push   $0x1
 3da:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3dd:	52                   	push   %edx
 3de:	50                   	push   %eax
 3df:	e8 5b ff ff ff       	call   33f <write>
}
 3e4:	83 c4 10             	add    $0x10,%esp
 3e7:	c9                   	leave  
 3e8:	c3                   	ret    

000003e9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e9:	55                   	push   %ebp
 3ea:	89 e5                	mov    %esp,%ebp
 3ec:	57                   	push   %edi
 3ed:	56                   	push   %esi
 3ee:	53                   	push   %ebx
 3ef:	83 ec 2c             	sub    $0x2c,%esp
 3f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3f5:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3fb:	74 04                	je     401 <printint+0x18>
 3fd:	85 d2                	test   %edx,%edx
 3ff:	78 3a                	js     43b <printint+0x52>
  neg = 0;
 401:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 408:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 40d:	89 f0                	mov    %esi,%eax
 40f:	ba 00 00 00 00       	mov    $0x0,%edx
 414:	f7 f1                	div    %ecx
 416:	89 df                	mov    %ebx,%edi
 418:	43                   	inc    %ebx
 419:	8a 92 f8 05 00 00    	mov    0x5f8(%edx),%dl
 41f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 423:	89 f2                	mov    %esi,%edx
 425:	89 c6                	mov    %eax,%esi
 427:	39 d1                	cmp    %edx,%ecx
 429:	76 e2                	jbe    40d <printint+0x24>
  if(neg)
 42b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 42f:	74 22                	je     453 <printint+0x6a>
    buf[i++] = '-';
 431:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 436:	8d 5f 02             	lea    0x2(%edi),%ebx
 439:	eb 18                	jmp    453 <printint+0x6a>
    x = -xx;
 43b:	f7 de                	neg    %esi
    neg = 1;
 43d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 444:	eb c2                	jmp    408 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 446:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 44b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 44e:	e8 7c ff ff ff       	call   3cf <putc>
  while(--i >= 0)
 453:	4b                   	dec    %ebx
 454:	79 f0                	jns    446 <printint+0x5d>
}
 456:	83 c4 2c             	add    $0x2c,%esp
 459:	5b                   	pop    %ebx
 45a:	5e                   	pop    %esi
 45b:	5f                   	pop    %edi
 45c:	5d                   	pop    %ebp
 45d:	c3                   	ret    

0000045e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 45e:	f3 0f 1e fb          	endbr32 
 462:	55                   	push   %ebp
 463:	89 e5                	mov    %esp,%ebp
 465:	57                   	push   %edi
 466:	56                   	push   %esi
 467:	53                   	push   %ebx
 468:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 46b:	8d 45 10             	lea    0x10(%ebp),%eax
 46e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 471:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 476:	bb 00 00 00 00       	mov    $0x0,%ebx
 47b:	eb 12                	jmp    48f <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 47d:	89 fa                	mov    %edi,%edx
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	e8 48 ff ff ff       	call   3cf <putc>
 487:	eb 05                	jmp    48e <printf+0x30>
      }
    } else if(state == '%'){
 489:	83 fe 25             	cmp    $0x25,%esi
 48c:	74 22                	je     4b0 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 48e:	43                   	inc    %ebx
 48f:	8b 45 0c             	mov    0xc(%ebp),%eax
 492:	8a 04 18             	mov    (%eax,%ebx,1),%al
 495:	84 c0                	test   %al,%al
 497:	0f 84 13 01 00 00    	je     5b0 <printf+0x152>
    c = fmt[i] & 0xff;
 49d:	0f be f8             	movsbl %al,%edi
 4a0:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4a3:	85 f6                	test   %esi,%esi
 4a5:	75 e2                	jne    489 <printf+0x2b>
      if(c == '%'){
 4a7:	83 f8 25             	cmp    $0x25,%eax
 4aa:	75 d1                	jne    47d <printf+0x1f>
        state = '%';
 4ac:	89 c6                	mov    %eax,%esi
 4ae:	eb de                	jmp    48e <printf+0x30>
      if(c == 'd'){
 4b0:	83 f8 64             	cmp    $0x64,%eax
 4b3:	74 43                	je     4f8 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4b5:	83 f8 78             	cmp    $0x78,%eax
 4b8:	74 68                	je     522 <printf+0xc4>
 4ba:	83 f8 70             	cmp    $0x70,%eax
 4bd:	74 63                	je     522 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4bf:	83 f8 73             	cmp    $0x73,%eax
 4c2:	0f 84 84 00 00 00    	je     54c <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4c8:	83 f8 63             	cmp    $0x63,%eax
 4cb:	0f 84 ad 00 00 00    	je     57e <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4d1:	83 f8 25             	cmp    $0x25,%eax
 4d4:	0f 84 c2 00 00 00    	je     59c <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4da:	ba 25 00 00 00       	mov    $0x25,%edx
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	e8 e8 fe ff ff       	call   3cf <putc>
        putc(fd, c);
 4e7:	89 fa                	mov    %edi,%edx
 4e9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ec:	e8 de fe ff ff       	call   3cf <putc>
      }
      state = 0;
 4f1:	be 00 00 00 00       	mov    $0x0,%esi
 4f6:	eb 96                	jmp    48e <printf+0x30>
        printint(fd, *ap, 10, 1);
 4f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4fb:	8b 17                	mov    (%edi),%edx
 4fd:	83 ec 0c             	sub    $0xc,%esp
 500:	6a 01                	push   $0x1
 502:	b9 0a 00 00 00       	mov    $0xa,%ecx
 507:	8b 45 08             	mov    0x8(%ebp),%eax
 50a:	e8 da fe ff ff       	call   3e9 <printint>
        ap++;
 50f:	83 c7 04             	add    $0x4,%edi
 512:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 515:	83 c4 10             	add    $0x10,%esp
      state = 0;
 518:	be 00 00 00 00       	mov    $0x0,%esi
 51d:	e9 6c ff ff ff       	jmp    48e <printf+0x30>
        printint(fd, *ap, 16, 0);
 522:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 525:	8b 17                	mov    (%edi),%edx
 527:	83 ec 0c             	sub    $0xc,%esp
 52a:	6a 00                	push   $0x0
 52c:	b9 10 00 00 00       	mov    $0x10,%ecx
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	e8 b0 fe ff ff       	call   3e9 <printint>
        ap++;
 539:	83 c7 04             	add    $0x4,%edi
 53c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 53f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 542:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 547:	e9 42 ff ff ff       	jmp    48e <printf+0x30>
        s = (char*)*ap;
 54c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54f:	8b 30                	mov    (%eax),%esi
        ap++;
 551:	83 c0 04             	add    $0x4,%eax
 554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 557:	85 f6                	test   %esi,%esi
 559:	75 13                	jne    56e <printf+0x110>
          s = "(null)";
 55b:	be ef 05 00 00       	mov    $0x5ef,%esi
 560:	eb 0c                	jmp    56e <printf+0x110>
          putc(fd, *s);
 562:	0f be d2             	movsbl %dl,%edx
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	e8 62 fe ff ff       	call   3cf <putc>
          s++;
 56d:	46                   	inc    %esi
        while(*s != 0){
 56e:	8a 16                	mov    (%esi),%dl
 570:	84 d2                	test   %dl,%dl
 572:	75 ee                	jne    562 <printf+0x104>
      state = 0;
 574:	be 00 00 00 00       	mov    $0x0,%esi
 579:	e9 10 ff ff ff       	jmp    48e <printf+0x30>
        putc(fd, *ap);
 57e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 581:	0f be 17             	movsbl (%edi),%edx
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	e8 43 fe ff ff       	call   3cf <putc>
        ap++;
 58c:	83 c7 04             	add    $0x4,%edi
 58f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 592:	be 00 00 00 00       	mov    $0x0,%esi
 597:	e9 f2 fe ff ff       	jmp    48e <printf+0x30>
        putc(fd, c);
 59c:	89 fa                	mov    %edi,%edx
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	e8 29 fe ff ff       	call   3cf <putc>
      state = 0;
 5a6:	be 00 00 00 00       	mov    $0x0,%esi
 5ab:	e9 de fe ff ff       	jmp    48e <printf+0x30>
    }
  }
}
 5b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5b3:	5b                   	pop    %ebx
 5b4:	5e                   	pop    %esi
 5b5:	5f                   	pop    %edi
 5b6:	5d                   	pop    %ebp
 5b7:	c3                   	ret    
