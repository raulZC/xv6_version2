
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
  2f:	68 60 08 00 00       	push   $0x860
  34:	ff 75 08             	pushl  0x8(%ebp)
  37:	e8 e1 02 00 00       	call   31d <read>
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
  53:	68 98 05 00 00       	push   $0x598
  58:	e8 85 01 00 00       	call   1e2 <strchr>
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
  71:	8a 83 60 08 00 00    	mov    0x860(%ebx),%al
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
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  94:	83 ec 08             	sub    $0x8,%esp
  97:	ff 75 0c             	pushl  0xc(%ebp)
  9a:	56                   	push   %esi
  9b:	ff 75 dc             	pushl  -0x24(%ebp)
  9e:	ff 75 e0             	pushl  -0x20(%ebp)
  a1:	68 ae 05 00 00       	push   $0x5ae
  a6:	6a 01                	push   $0x1
  a8:	e8 8f 03 00 00       	call   43c <printf>
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
  bb:	68 9e 05 00 00       	push   $0x59e
  c0:	6a 01                	push   $0x1
  c2:	e8 75 03 00 00       	call   43c <printf>
    exit();
  c7:	e8 39 02 00 00       	call   305 <exit>

000000cc <main>:

int
main(int argc, char *argv[])
{
  cc:	f3 0f 1e fb          	endbr32 
  d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d4:	83 e4 f0             	and    $0xfffffff0,%esp
  d7:	ff 71 fc             	pushl  -0x4(%ecx)
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	57                   	push   %edi
  de:	56                   	push   %esi
  df:	53                   	push   %ebx
  e0:	51                   	push   %ecx
  e1:	83 ec 18             	sub    $0x18,%esp
  e4:	8b 01                	mov    (%ecx),%eax
  e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  e9:	8b 51 04             	mov    0x4(%ecx),%edx
  ec:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  ef:	83 f8 01             	cmp    $0x1,%eax
  f2:	7e 3e                	jle    132 <main+0x66>
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  f4:	be 01 00 00 00       	mov    $0x1,%esi
  f9:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  fc:	7d 5e                	jge    15c <main+0x90>
    if((fd = open(argv[i], 0)) < 0){
  fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
 101:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 104:	83 ec 08             	sub    $0x8,%esp
 107:	6a 00                	push   $0x0
 109:	ff 37                	pushl  (%edi)
 10b:	e8 35 02 00 00       	call   345 <open>
 110:	89 c3                	mov    %eax,%ebx
 112:	83 c4 10             	add    $0x10,%esp
 115:	85 c0                	test   %eax,%eax
 117:	78 2d                	js     146 <main+0x7a>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 119:	83 ec 08             	sub    $0x8,%esp
 11c:	ff 37                	pushl  (%edi)
 11e:	50                   	push   %eax
 11f:	e8 dc fe ff ff       	call   0 <wc>
    close(fd);
 124:	89 1c 24             	mov    %ebx,(%esp)
 127:	e8 01 02 00 00       	call   32d <close>
  for(i = 1; i < argc; i++){
 12c:	46                   	inc    %esi
 12d:	83 c4 10             	add    $0x10,%esp
 130:	eb c7                	jmp    f9 <main+0x2d>
    wc(0, "");
 132:	83 ec 08             	sub    $0x8,%esp
 135:	68 ad 05 00 00       	push   $0x5ad
 13a:	6a 00                	push   $0x0
 13c:	e8 bf fe ff ff       	call   0 <wc>
    exit();
 141:	e8 bf 01 00 00       	call   305 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
 146:	83 ec 04             	sub    $0x4,%esp
 149:	ff 37                	pushl  (%edi)
 14b:	68 bb 05 00 00       	push   $0x5bb
 150:	6a 01                	push   $0x1
 152:	e8 e5 02 00 00       	call   43c <printf>
      exit();
 157:	e8 a9 01 00 00       	call   305 <exit>
  }
  exit();
 15c:	e8 a4 01 00 00       	call   305 <exit>

00000161 <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 161:	f3 0f 1e fb          	endbr32 
}
 165:	c3                   	ret    

00000166 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 166:	f3 0f 1e fb          	endbr32 
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
 16d:	56                   	push   %esi
 16e:	53                   	push   %ebx
 16f:	8b 45 08             	mov    0x8(%ebp),%eax
 172:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 175:	89 c2                	mov    %eax,%edx
 177:	89 cb                	mov    %ecx,%ebx
 179:	41                   	inc    %ecx
 17a:	89 d6                	mov    %edx,%esi
 17c:	42                   	inc    %edx
 17d:	8a 1b                	mov    (%ebx),%bl
 17f:	88 1e                	mov    %bl,(%esi)
 181:	84 db                	test   %bl,%bl
 183:	75 f2                	jne    177 <strcpy+0x11>
    ;
  return os;
}
 185:	5b                   	pop    %ebx
 186:	5e                   	pop    %esi
 187:	5d                   	pop    %ebp
 188:	c3                   	ret    

00000189 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 189:	f3 0f 1e fb          	endbr32 
 18d:	55                   	push   %ebp
 18e:	89 e5                	mov    %esp,%ebp
 190:	8b 4d 08             	mov    0x8(%ebp),%ecx
 193:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 196:	8a 01                	mov    (%ecx),%al
 198:	84 c0                	test   %al,%al
 19a:	74 08                	je     1a4 <strcmp+0x1b>
 19c:	3a 02                	cmp    (%edx),%al
 19e:	75 04                	jne    1a4 <strcmp+0x1b>
    p++, q++;
 1a0:	41                   	inc    %ecx
 1a1:	42                   	inc    %edx
 1a2:	eb f2                	jmp    196 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 1a4:	0f b6 c0             	movzbl %al,%eax
 1a7:	0f b6 12             	movzbl (%edx),%edx
 1aa:	29 d0                	sub    %edx,%eax
}
 1ac:	5d                   	pop    %ebp
 1ad:	c3                   	ret    

000001ae <strlen>:

uint
strlen(const char *s)
{
 1ae:	f3 0f 1e fb          	endbr32 
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1b8:	b8 00 00 00 00       	mov    $0x0,%eax
 1bd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1c1:	74 03                	je     1c6 <strlen+0x18>
 1c3:	40                   	inc    %eax
 1c4:	eb f7                	jmp    1bd <strlen+0xf>
    ;
  return n;
}
 1c6:	5d                   	pop    %ebp
 1c7:	c3                   	ret    

000001c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c8:	f3 0f 1e fb          	endbr32 
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d0:	8b 7d 08             	mov    0x8(%ebp),%edi
 1d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d9:	fc                   	cld    
 1da:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	5f                   	pop    %edi
 1e0:	5d                   	pop    %ebp
 1e1:	c3                   	ret    

000001e2 <strchr>:

char*
strchr(const char *s, char c)
{
 1e2:	f3 0f 1e fb          	endbr32 
 1e6:	55                   	push   %ebp
 1e7:	89 e5                	mov    %esp,%ebp
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1ef:	8a 10                	mov    (%eax),%dl
 1f1:	84 d2                	test   %dl,%dl
 1f3:	74 07                	je     1fc <strchr+0x1a>
    if(*s == c)
 1f5:	38 ca                	cmp    %cl,%dl
 1f7:	74 08                	je     201 <strchr+0x1f>
  for(; *s; s++)
 1f9:	40                   	inc    %eax
 1fa:	eb f3                	jmp    1ef <strchr+0xd>
      return (char*)s;
  return 0;
 1fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 201:	5d                   	pop    %ebp
 202:	c3                   	ret    

00000203 <gets>:

char*
gets(char *buf, int max)
{
 203:	f3 0f 1e fb          	endbr32 
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	57                   	push   %edi
 20b:	56                   	push   %esi
 20c:	53                   	push   %ebx
 20d:	83 ec 1c             	sub    $0x1c,%esp
 210:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 213:	bb 00 00 00 00       	mov    $0x0,%ebx
 218:	89 de                	mov    %ebx,%esi
 21a:	43                   	inc    %ebx
 21b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 21e:	7d 2b                	jge    24b <gets+0x48>
    cc = read(0, &c, 1);
 220:	83 ec 04             	sub    $0x4,%esp
 223:	6a 01                	push   $0x1
 225:	8d 45 e7             	lea    -0x19(%ebp),%eax
 228:	50                   	push   %eax
 229:	6a 00                	push   $0x0
 22b:	e8 ed 00 00 00       	call   31d <read>
    if(cc < 1)
 230:	83 c4 10             	add    $0x10,%esp
 233:	85 c0                	test   %eax,%eax
 235:	7e 14                	jle    24b <gets+0x48>
      break;
    buf[i++] = c;
 237:	8a 45 e7             	mov    -0x19(%ebp),%al
 23a:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 23d:	3c 0a                	cmp    $0xa,%al
 23f:	74 08                	je     249 <gets+0x46>
 241:	3c 0d                	cmp    $0xd,%al
 243:	75 d3                	jne    218 <gets+0x15>
    buf[i++] = c;
 245:	89 de                	mov    %ebx,%esi
 247:	eb 02                	jmp    24b <gets+0x48>
 249:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 24b:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 24f:	89 f8                	mov    %edi,%eax
 251:	8d 65 f4             	lea    -0xc(%ebp),%esp
 254:	5b                   	pop    %ebx
 255:	5e                   	pop    %esi
 256:	5f                   	pop    %edi
 257:	5d                   	pop    %ebp
 258:	c3                   	ret    

00000259 <stat>:

int
stat(const char *n, struct stat *st)
{
 259:	f3 0f 1e fb          	endbr32 
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	56                   	push   %esi
 261:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 262:	83 ec 08             	sub    $0x8,%esp
 265:	6a 00                	push   $0x0
 267:	ff 75 08             	pushl  0x8(%ebp)
 26a:	e8 d6 00 00 00       	call   345 <open>
  if(fd < 0)
 26f:	83 c4 10             	add    $0x10,%esp
 272:	85 c0                	test   %eax,%eax
 274:	78 24                	js     29a <stat+0x41>
 276:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 278:	83 ec 08             	sub    $0x8,%esp
 27b:	ff 75 0c             	pushl  0xc(%ebp)
 27e:	50                   	push   %eax
 27f:	e8 d9 00 00 00       	call   35d <fstat>
 284:	89 c6                	mov    %eax,%esi
  close(fd);
 286:	89 1c 24             	mov    %ebx,(%esp)
 289:	e8 9f 00 00 00       	call   32d <close>
  return r;
 28e:	83 c4 10             	add    $0x10,%esp
}
 291:	89 f0                	mov    %esi,%eax
 293:	8d 65 f8             	lea    -0x8(%ebp),%esp
 296:	5b                   	pop    %ebx
 297:	5e                   	pop    %esi
 298:	5d                   	pop    %ebp
 299:	c3                   	ret    
    return -1;
 29a:	be ff ff ff ff       	mov    $0xffffffff,%esi
 29f:	eb f0                	jmp    291 <stat+0x38>

000002a1 <atoi>:

int
atoi(const char *s)
{
 2a1:	f3 0f 1e fb          	endbr32 
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	53                   	push   %ebx
 2a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2ac:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2b1:	8a 01                	mov    (%ecx),%al
 2b3:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2b6:	80 fb 09             	cmp    $0x9,%bl
 2b9:	77 10                	ja     2cb <atoi+0x2a>
    n = n*10 + *s++ - '0';
 2bb:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2be:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 2c1:	41                   	inc    %ecx
 2c2:	0f be c0             	movsbl %al,%eax
 2c5:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 2c9:	eb e6                	jmp    2b1 <atoi+0x10>
  return n;
}
 2cb:	89 d0                	mov    %edx,%eax
 2cd:	5b                   	pop    %ebx
 2ce:	5d                   	pop    %ebp
 2cf:	c3                   	ret    

000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	f3 0f 1e fb          	endbr32 
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	56                   	push   %esi
 2d8:	53                   	push   %ebx
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2df:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 2e2:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 2e4:	8d 72 ff             	lea    -0x1(%edx),%esi
 2e7:	85 d2                	test   %edx,%edx
 2e9:	7e 0e                	jle    2f9 <memmove+0x29>
    *dst++ = *src++;
 2eb:	8a 13                	mov    (%ebx),%dl
 2ed:	88 11                	mov    %dl,(%ecx)
 2ef:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2f2:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2f5:	89 f2                	mov    %esi,%edx
 2f7:	eb eb                	jmp    2e4 <memmove+0x14>
  return vdst;
}
 2f9:	5b                   	pop    %ebx
 2fa:	5e                   	pop    %esi
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    

000002fd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2fd:	b8 01 00 00 00       	mov    $0x1,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <exit>:
SYSCALL(exit)
 305:	b8 02 00 00 00       	mov    $0x2,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <wait>:
SYSCALL(wait)
 30d:	b8 03 00 00 00       	mov    $0x3,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <pipe>:
SYSCALL(pipe)
 315:	b8 04 00 00 00       	mov    $0x4,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <read>:
SYSCALL(read)
 31d:	b8 05 00 00 00       	mov    $0x5,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <write>:
SYSCALL(write)
 325:	b8 10 00 00 00       	mov    $0x10,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <close>:
SYSCALL(close)
 32d:	b8 15 00 00 00       	mov    $0x15,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <kill>:
SYSCALL(kill)
 335:	b8 06 00 00 00       	mov    $0x6,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <exec>:
SYSCALL(exec)
 33d:	b8 07 00 00 00       	mov    $0x7,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <open>:
SYSCALL(open)
 345:	b8 0f 00 00 00       	mov    $0xf,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <mknod>:
SYSCALL(mknod)
 34d:	b8 11 00 00 00       	mov    $0x11,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <unlink>:
SYSCALL(unlink)
 355:	b8 12 00 00 00       	mov    $0x12,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <fstat>:
SYSCALL(fstat)
 35d:	b8 08 00 00 00       	mov    $0x8,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <link>:
SYSCALL(link)
 365:	b8 13 00 00 00       	mov    $0x13,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <mkdir>:
SYSCALL(mkdir)
 36d:	b8 14 00 00 00       	mov    $0x14,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <chdir>:
SYSCALL(chdir)
 375:	b8 09 00 00 00       	mov    $0x9,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <dup>:
SYSCALL(dup)
 37d:	b8 0a 00 00 00       	mov    $0xa,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <getpid>:
SYSCALL(getpid)
 385:	b8 0b 00 00 00       	mov    $0xb,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <sbrk>:
SYSCALL(sbrk)
 38d:	b8 0c 00 00 00       	mov    $0xc,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <sleep>:
SYSCALL(sleep)
 395:	b8 0d 00 00 00       	mov    $0xd,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <uptime>:
SYSCALL(uptime)
 39d:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <date>:
SYSCALL(date)
 3a5:	b8 16 00 00 00       	mov    $0x16,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ad:	55                   	push   %ebp
 3ae:	89 e5                	mov    %esp,%ebp
 3b0:	83 ec 1c             	sub    $0x1c,%esp
 3b3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3b6:	6a 01                	push   $0x1
 3b8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3bb:	52                   	push   %edx
 3bc:	50                   	push   %eax
 3bd:	e8 63 ff ff ff       	call   325 <write>
}
 3c2:	83 c4 10             	add    $0x10,%esp
 3c5:	c9                   	leave  
 3c6:	c3                   	ret    

000003c7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
 3ca:	57                   	push   %edi
 3cb:	56                   	push   %esi
 3cc:	53                   	push   %ebx
 3cd:	83 ec 2c             	sub    $0x2c,%esp
 3d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3d3:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3d9:	74 04                	je     3df <printint+0x18>
 3db:	85 d2                	test   %edx,%edx
 3dd:	78 3a                	js     419 <printint+0x52>
  neg = 0;
 3df:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3eb:	89 f0                	mov    %esi,%eax
 3ed:	ba 00 00 00 00       	mov    $0x0,%edx
 3f2:	f7 f1                	div    %ecx
 3f4:	89 df                	mov    %ebx,%edi
 3f6:	43                   	inc    %ebx
 3f7:	8a 92 d8 05 00 00    	mov    0x5d8(%edx),%dl
 3fd:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 401:	89 f2                	mov    %esi,%edx
 403:	89 c6                	mov    %eax,%esi
 405:	39 d1                	cmp    %edx,%ecx
 407:	76 e2                	jbe    3eb <printint+0x24>
  if(neg)
 409:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 40d:	74 22                	je     431 <printint+0x6a>
    buf[i++] = '-';
 40f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 414:	8d 5f 02             	lea    0x2(%edi),%ebx
 417:	eb 18                	jmp    431 <printint+0x6a>
    x = -xx;
 419:	f7 de                	neg    %esi
    neg = 1;
 41b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 422:	eb c2                	jmp    3e6 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 424:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 429:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 42c:	e8 7c ff ff ff       	call   3ad <putc>
  while(--i >= 0)
 431:	4b                   	dec    %ebx
 432:	79 f0                	jns    424 <printint+0x5d>
}
 434:	83 c4 2c             	add    $0x2c,%esp
 437:	5b                   	pop    %ebx
 438:	5e                   	pop    %esi
 439:	5f                   	pop    %edi
 43a:	5d                   	pop    %ebp
 43b:	c3                   	ret    

0000043c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 43c:	f3 0f 1e fb          	endbr32 
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 449:	8d 45 10             	lea    0x10(%ebp),%eax
 44c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 44f:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 454:	bb 00 00 00 00       	mov    $0x0,%ebx
 459:	eb 12                	jmp    46d <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 45b:	89 fa                	mov    %edi,%edx
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	e8 48 ff ff ff       	call   3ad <putc>
 465:	eb 05                	jmp    46c <printf+0x30>
      }
    } else if(state == '%'){
 467:	83 fe 25             	cmp    $0x25,%esi
 46a:	74 22                	je     48e <printf+0x52>
  for(i = 0; fmt[i]; i++){
 46c:	43                   	inc    %ebx
 46d:	8b 45 0c             	mov    0xc(%ebp),%eax
 470:	8a 04 18             	mov    (%eax,%ebx,1),%al
 473:	84 c0                	test   %al,%al
 475:	0f 84 13 01 00 00    	je     58e <printf+0x152>
    c = fmt[i] & 0xff;
 47b:	0f be f8             	movsbl %al,%edi
 47e:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 481:	85 f6                	test   %esi,%esi
 483:	75 e2                	jne    467 <printf+0x2b>
      if(c == '%'){
 485:	83 f8 25             	cmp    $0x25,%eax
 488:	75 d1                	jne    45b <printf+0x1f>
        state = '%';
 48a:	89 c6                	mov    %eax,%esi
 48c:	eb de                	jmp    46c <printf+0x30>
      if(c == 'd'){
 48e:	83 f8 64             	cmp    $0x64,%eax
 491:	74 43                	je     4d6 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 493:	83 f8 78             	cmp    $0x78,%eax
 496:	74 68                	je     500 <printf+0xc4>
 498:	83 f8 70             	cmp    $0x70,%eax
 49b:	74 63                	je     500 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 49d:	83 f8 73             	cmp    $0x73,%eax
 4a0:	0f 84 84 00 00 00    	je     52a <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4a6:	83 f8 63             	cmp    $0x63,%eax
 4a9:	0f 84 ad 00 00 00    	je     55c <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4af:	83 f8 25             	cmp    $0x25,%eax
 4b2:	0f 84 c2 00 00 00    	je     57a <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4b8:	ba 25 00 00 00       	mov    $0x25,%edx
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	e8 e8 fe ff ff       	call   3ad <putc>
        putc(fd, c);
 4c5:	89 fa                	mov    %edi,%edx
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	e8 de fe ff ff       	call   3ad <putc>
      }
      state = 0;
 4cf:	be 00 00 00 00       	mov    $0x0,%esi
 4d4:	eb 96                	jmp    46c <printf+0x30>
        printint(fd, *ap, 10, 1);
 4d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d9:	8b 17                	mov    (%edi),%edx
 4db:	83 ec 0c             	sub    $0xc,%esp
 4de:	6a 01                	push   $0x1
 4e0:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
 4e8:	e8 da fe ff ff       	call   3c7 <printint>
        ap++;
 4ed:	83 c7 04             	add    $0x4,%edi
 4f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4f3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f6:	be 00 00 00 00       	mov    $0x0,%esi
 4fb:	e9 6c ff ff ff       	jmp    46c <printf+0x30>
        printint(fd, *ap, 16, 0);
 500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 503:	8b 17                	mov    (%edi),%edx
 505:	83 ec 0c             	sub    $0xc,%esp
 508:	6a 00                	push   $0x0
 50a:	b9 10 00 00 00       	mov    $0x10,%ecx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	e8 b0 fe ff ff       	call   3c7 <printint>
        ap++;
 517:	83 c7 04             	add    $0x4,%edi
 51a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 51d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 520:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 525:	e9 42 ff ff ff       	jmp    46c <printf+0x30>
        s = (char*)*ap;
 52a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52d:	8b 30                	mov    (%eax),%esi
        ap++;
 52f:	83 c0 04             	add    $0x4,%eax
 532:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 535:	85 f6                	test   %esi,%esi
 537:	75 13                	jne    54c <printf+0x110>
          s = "(null)";
 539:	be cf 05 00 00       	mov    $0x5cf,%esi
 53e:	eb 0c                	jmp    54c <printf+0x110>
          putc(fd, *s);
 540:	0f be d2             	movsbl %dl,%edx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	e8 62 fe ff ff       	call   3ad <putc>
          s++;
 54b:	46                   	inc    %esi
        while(*s != 0){
 54c:	8a 16                	mov    (%esi),%dl
 54e:	84 d2                	test   %dl,%dl
 550:	75 ee                	jne    540 <printf+0x104>
      state = 0;
 552:	be 00 00 00 00       	mov    $0x0,%esi
 557:	e9 10 ff ff ff       	jmp    46c <printf+0x30>
        putc(fd, *ap);
 55c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 55f:	0f be 17             	movsbl (%edi),%edx
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	e8 43 fe ff ff       	call   3ad <putc>
        ap++;
 56a:	83 c7 04             	add    $0x4,%edi
 56d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 570:	be 00 00 00 00       	mov    $0x0,%esi
 575:	e9 f2 fe ff ff       	jmp    46c <printf+0x30>
        putc(fd, c);
 57a:	89 fa                	mov    %edi,%edx
 57c:	8b 45 08             	mov    0x8(%ebp),%eax
 57f:	e8 29 fe ff ff       	call   3ad <putc>
      state = 0;
 584:	be 00 00 00 00       	mov    $0x0,%esi
 589:	e9 de fe ff ff       	jmp    46c <printf+0x30>
    }
  }
}
 58e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 591:	5b                   	pop    %ebx
 592:	5e                   	pop    %esi
 593:	5f                   	pop    %edi
 594:	5d                   	pop    %ebp
 595:	c3                   	ret    
