
ls:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	83 ec 0c             	sub    $0xc,%esp
   f:	53                   	push   %ebx
  10:	e8 2e 03 00 00       	call   343 <strlen>
  15:	01 d8                	add    %ebx,%eax
  17:	83 c4 10             	add    $0x10,%esp
  1a:	39 d8                	cmp    %ebx,%eax
  1c:	72 08                	jb     26 <fmtname+0x26>
  1e:	80 38 2f             	cmpb   $0x2f,(%eax)
  21:	74 03                	je     26 <fmtname+0x26>
  23:	48                   	dec    %eax
  24:	eb f4                	jmp    1a <fmtname+0x1a>
    ;
  p++;
  26:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	53                   	push   %ebx
  2d:	e8 11 03 00 00       	call   343 <strlen>
  32:	83 c4 10             	add    $0x10,%esp
  35:	83 f8 0d             	cmp    $0xd,%eax
  38:	76 09                	jbe    43 <fmtname+0x43>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3a:	89 d8                	mov    %ebx,%eax
  3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  3f:	5b                   	pop    %ebx
  40:	5e                   	pop    %esi
  41:	5d                   	pop    %ebp
  42:	c3                   	ret    
  memmove(buf, p, strlen(p));
  43:	83 ec 0c             	sub    $0xc,%esp
  46:	53                   	push   %ebx
  47:	e8 f7 02 00 00       	call   343 <strlen>
  4c:	83 c4 0c             	add    $0xc,%esp
  4f:	50                   	push   %eax
  50:	53                   	push   %ebx
  51:	68 20 0a 00 00       	push   $0xa20
  56:	e8 0a 04 00 00       	call   465 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  5b:	89 1c 24             	mov    %ebx,(%esp)
  5e:	e8 e0 02 00 00       	call   343 <strlen>
  63:	89 c6                	mov    %eax,%esi
  65:	89 1c 24             	mov    %ebx,(%esp)
  68:	e8 d6 02 00 00       	call   343 <strlen>
  6d:	83 c4 0c             	add    $0xc,%esp
  70:	ba 0e 00 00 00       	mov    $0xe,%edx
  75:	29 f2                	sub    %esi,%edx
  77:	52                   	push   %edx
  78:	6a 20                	push   $0x20
  7a:	05 20 0a 00 00       	add    $0xa20,%eax
  7f:	50                   	push   %eax
  80:	e8 d8 02 00 00       	call   35d <memset>
  return buf;
  85:	83 c4 10             	add    $0x10,%esp
  88:	bb 20 0a 00 00       	mov    $0xa20,%ebx
  8d:	eb ab                	jmp    3a <fmtname+0x3a>

0000008f <ls>:

void
ls(char *path)
{
  8f:	f3 0f 1e fb          	endbr32 
  93:	55                   	push   %ebp
  94:	89 e5                	mov    %esp,%ebp
  96:	57                   	push   %edi
  97:	56                   	push   %esi
  98:	53                   	push   %ebx
  99:	81 ec 54 02 00 00    	sub    $0x254,%esp
  9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  a2:	6a 00                	push   $0x0
  a4:	53                   	push   %ebx
  a5:	e8 30 04 00 00       	call   4da <open>
  aa:	83 c4 10             	add    $0x10,%esp
  ad:	85 c0                	test   %eax,%eax
  af:	0f 88 8b 00 00 00    	js     140 <ls+0xb1>
  b5:	89 c7                	mov    %eax,%edi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  b7:	83 ec 08             	sub    $0x8,%esp
  ba:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
  c0:	50                   	push   %eax
  c1:	57                   	push   %edi
  c2:	e8 2b 04 00 00       	call   4f2 <fstat>
  c7:	83 c4 10             	add    $0x10,%esp
  ca:	85 c0                	test   %eax,%eax
  cc:	0f 88 83 00 00 00    	js     155 <ls+0xc6>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d2:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
  d8:	0f bf f0             	movswl %ax,%esi
  db:	66 83 f8 01          	cmp    $0x1,%ax
  df:	0f 84 8d 00 00 00    	je     172 <ls+0xe3>
  e5:	66 83 f8 02          	cmp    $0x2,%ax
  e9:	75 41                	jne    12c <ls+0x9d>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
  eb:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
  f1:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
  f7:	8b 8d cc fd ff ff    	mov    -0x234(%ebp),%ecx
  fd:	89 8d b0 fd ff ff    	mov    %ecx,-0x250(%ebp)
 103:	83 ec 0c             	sub    $0xc,%esp
 106:	53                   	push   %ebx
 107:	e8 f4 fe ff ff       	call   0 <fmtname>
 10c:	83 c4 08             	add    $0x8,%esp
 10f:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 115:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 11b:	56                   	push   %esi
 11c:	50                   	push   %eax
 11d:	68 5c 07 00 00       	push   $0x75c
 122:	6a 01                	push   $0x1
 124:	e8 b0 04 00 00       	call   5d9 <printf>
    break;
 129:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 12c:	83 ec 0c             	sub    $0xc,%esp
 12f:	57                   	push   %edi
 130:	e8 8d 03 00 00       	call   4c2 <close>
 135:	83 c4 10             	add    $0x10,%esp
}
 138:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13b:	5b                   	pop    %ebx
 13c:	5e                   	pop    %esi
 13d:	5f                   	pop    %edi
 13e:	5d                   	pop    %ebp
 13f:	c3                   	ret    
    printf(2, "ls: cannot open %s\n", path);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	53                   	push   %ebx
 144:	68 34 07 00 00       	push   $0x734
 149:	6a 02                	push   $0x2
 14b:	e8 89 04 00 00       	call   5d9 <printf>
    return;
 150:	83 c4 10             	add    $0x10,%esp
 153:	eb e3                	jmp    138 <ls+0xa9>
    printf(2, "ls: cannot stat %s\n", path);
 155:	83 ec 04             	sub    $0x4,%esp
 158:	53                   	push   %ebx
 159:	68 48 07 00 00       	push   $0x748
 15e:	6a 02                	push   $0x2
 160:	e8 74 04 00 00       	call   5d9 <printf>
    close(fd);
 165:	89 3c 24             	mov    %edi,(%esp)
 168:	e8 55 03 00 00       	call   4c2 <close>
    return;
 16d:	83 c4 10             	add    $0x10,%esp
 170:	eb c6                	jmp    138 <ls+0xa9>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 172:	83 ec 0c             	sub    $0xc,%esp
 175:	53                   	push   %ebx
 176:	e8 c8 01 00 00       	call   343 <strlen>
 17b:	83 c0 10             	add    $0x10,%eax
 17e:	83 c4 10             	add    $0x10,%esp
 181:	3d 00 02 00 00       	cmp    $0x200,%eax
 186:	76 14                	jbe    19c <ls+0x10d>
      printf(1, "ls: path too long\n");
 188:	83 ec 08             	sub    $0x8,%esp
 18b:	68 69 07 00 00       	push   $0x769
 190:	6a 01                	push   $0x1
 192:	e8 42 04 00 00       	call   5d9 <printf>
      break;
 197:	83 c4 10             	add    $0x10,%esp
 19a:	eb 90                	jmp    12c <ls+0x9d>
    strcpy(buf, path);
 19c:	83 ec 08             	sub    $0x8,%esp
 19f:	53                   	push   %ebx
 1a0:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
 1a6:	53                   	push   %ebx
 1a7:	e8 4f 01 00 00       	call   2fb <strcpy>
    p = buf+strlen(buf);
 1ac:	89 1c 24             	mov    %ebx,(%esp)
 1af:	e8 8f 01 00 00       	call   343 <strlen>
 1b4:	8d 34 03             	lea    (%ebx,%eax,1),%esi
    *p++ = '/';
 1b7:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
 1bb:	89 85 ac fd ff ff    	mov    %eax,-0x254(%ebp)
 1c1:	c6 06 2f             	movb   $0x2f,(%esi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	eb 19                	jmp    1e2 <ls+0x153>
        printf(1, "ls: cannot stat %s\n", buf);
 1c9:	83 ec 04             	sub    $0x4,%esp
 1cc:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1d2:	50                   	push   %eax
 1d3:	68 48 07 00 00       	push   $0x748
 1d8:	6a 01                	push   $0x1
 1da:	e8 fa 03 00 00       	call   5d9 <printf>
        continue;
 1df:	83 c4 10             	add    $0x10,%esp
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e2:	83 ec 04             	sub    $0x4,%esp
 1e5:	6a 10                	push   $0x10
 1e7:	8d 85 d8 fd ff ff    	lea    -0x228(%ebp),%eax
 1ed:	50                   	push   %eax
 1ee:	57                   	push   %edi
 1ef:	e8 be 02 00 00       	call   4b2 <read>
 1f4:	83 c4 10             	add    $0x10,%esp
 1f7:	83 f8 10             	cmp    $0x10,%eax
 1fa:	0f 85 2c ff ff ff    	jne    12c <ls+0x9d>
      if(de.inum == 0)
 200:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
 207:	00 
 208:	74 d8                	je     1e2 <ls+0x153>
      memmove(p, de.name, DIRSIZ);
 20a:	83 ec 04             	sub    $0x4,%esp
 20d:	6a 0e                	push   $0xe
 20f:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
 215:	50                   	push   %eax
 216:	ff b5 ac fd ff ff    	pushl  -0x254(%ebp)
 21c:	e8 44 02 00 00       	call   465 <memmove>
      p[DIRSIZ] = 0;
 221:	c6 46 0f 00          	movb   $0x0,0xf(%esi)
      if(stat(buf, &st) < 0){
 225:	83 c4 08             	add    $0x8,%esp
 228:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 22e:	50                   	push   %eax
 22f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 235:	50                   	push   %eax
 236:	e8 b3 01 00 00       	call   3ee <stat>
 23b:	83 c4 10             	add    $0x10,%esp
 23e:	85 c0                	test   %eax,%eax
 240:	78 87                	js     1c9 <ls+0x13a>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 242:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 248:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 24e:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 254:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 25a:	8b 9d c4 fd ff ff    	mov    -0x23c(%ebp),%ebx
 260:	83 ec 0c             	sub    $0xc,%esp
 263:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 269:	50                   	push   %eax
 26a:	e8 91 fd ff ff       	call   0 <fmtname>
 26f:	83 c4 08             	add    $0x8,%esp
 272:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 278:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 27e:	0f bf db             	movswl %bx,%ebx
 281:	53                   	push   %ebx
 282:	50                   	push   %eax
 283:	68 5c 07 00 00       	push   $0x75c
 288:	6a 01                	push   $0x1
 28a:	e8 4a 03 00 00       	call   5d9 <printf>
 28f:	83 c4 20             	add    $0x20,%esp
 292:	e9 4b ff ff ff       	jmp    1e2 <ls+0x153>

00000297 <main>:

int
main(int argc, char *argv[])
{
 297:	f3 0f 1e fb          	endbr32 
 29b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 29f:	83 e4 f0             	and    $0xfffffff0,%esp
 2a2:	ff 71 fc             	pushl  -0x4(%ecx)
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	57                   	push   %edi
 2a9:	56                   	push   %esi
 2aa:	53                   	push   %ebx
 2ab:	51                   	push   %ecx
 2ac:	83 ec 08             	sub    $0x8,%esp
 2af:	8b 31                	mov    (%ecx),%esi
 2b1:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
 2b4:	83 fe 01             	cmp    $0x1,%esi
 2b7:	7e 07                	jle    2c0 <main+0x29>
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
 2b9:	bb 01 00 00 00       	mov    $0x1,%ebx
 2be:	eb 28                	jmp    2e8 <main+0x51>
    ls(".");
 2c0:	83 ec 0c             	sub    $0xc,%esp
 2c3:	68 7c 07 00 00       	push   $0x77c
 2c8:	e8 c2 fd ff ff       	call   8f <ls>
    exit(0);
 2cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2d4:	e8 c1 01 00 00       	call   49a <exit>
    ls(argv[i]);
 2d9:	83 ec 0c             	sub    $0xc,%esp
 2dc:	ff 34 9f             	pushl  (%edi,%ebx,4)
 2df:	e8 ab fd ff ff       	call   8f <ls>
  for(i=1; i<argc; i++)
 2e4:	43                   	inc    %ebx
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	39 f3                	cmp    %esi,%ebx
 2ea:	7c ed                	jl     2d9 <main+0x42>
  exit(0);
 2ec:	83 ec 0c             	sub    $0xc,%esp
 2ef:	6a 00                	push   $0x0
 2f1:	e8 a4 01 00 00       	call   49a <exit>

000002f6 <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 2f6:	f3 0f 1e fb          	endbr32 
}
 2fa:	c3                   	ret    

000002fb <strcpy>:

char*
strcpy(char *s, const char *t)
{
 2fb:	f3 0f 1e fb          	endbr32 
 2ff:	55                   	push   %ebp
 300:	89 e5                	mov    %esp,%ebp
 302:	56                   	push   %esi
 303:	53                   	push   %ebx
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 30a:	89 c2                	mov    %eax,%edx
 30c:	89 cb                	mov    %ecx,%ebx
 30e:	41                   	inc    %ecx
 30f:	89 d6                	mov    %edx,%esi
 311:	42                   	inc    %edx
 312:	8a 1b                	mov    (%ebx),%bl
 314:	88 1e                	mov    %bl,(%esi)
 316:	84 db                	test   %bl,%bl
 318:	75 f2                	jne    30c <strcpy+0x11>
    ;
  return os;
}
 31a:	5b                   	pop    %ebx
 31b:	5e                   	pop    %esi
 31c:	5d                   	pop    %ebp
 31d:	c3                   	ret    

0000031e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 31e:	f3 0f 1e fb          	endbr32 
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	8b 4d 08             	mov    0x8(%ebp),%ecx
 328:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 32b:	8a 01                	mov    (%ecx),%al
 32d:	84 c0                	test   %al,%al
 32f:	74 08                	je     339 <strcmp+0x1b>
 331:	3a 02                	cmp    (%edx),%al
 333:	75 04                	jne    339 <strcmp+0x1b>
    p++, q++;
 335:	41                   	inc    %ecx
 336:	42                   	inc    %edx
 337:	eb f2                	jmp    32b <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 339:	0f b6 c0             	movzbl %al,%eax
 33c:	0f b6 12             	movzbl (%edx),%edx
 33f:	29 d0                	sub    %edx,%eax
}
 341:	5d                   	pop    %ebp
 342:	c3                   	ret    

00000343 <strlen>:

uint
strlen(const char *s)
{
 343:	f3 0f 1e fb          	endbr32 
 347:	55                   	push   %ebp
 348:	89 e5                	mov    %esp,%ebp
 34a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 34d:	b8 00 00 00 00       	mov    $0x0,%eax
 352:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 356:	74 03                	je     35b <strlen+0x18>
 358:	40                   	inc    %eax
 359:	eb f7                	jmp    352 <strlen+0xf>
    ;
  return n;
}
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    

0000035d <memset>:

void*
memset(void *dst, int c, uint n)
{
 35d:	f3 0f 1e fb          	endbr32 
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 365:	8b 7d 08             	mov    0x8(%ebp),%edi
 368:	8b 4d 10             	mov    0x10(%ebp),%ecx
 36b:	8b 45 0c             	mov    0xc(%ebp),%eax
 36e:	fc                   	cld    
 36f:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	5f                   	pop    %edi
 375:	5d                   	pop    %ebp
 376:	c3                   	ret    

00000377 <strchr>:

char*
strchr(const char *s, char c)
{
 377:	f3 0f 1e fb          	endbr32 
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 384:	8a 10                	mov    (%eax),%dl
 386:	84 d2                	test   %dl,%dl
 388:	74 07                	je     391 <strchr+0x1a>
    if(*s == c)
 38a:	38 ca                	cmp    %cl,%dl
 38c:	74 08                	je     396 <strchr+0x1f>
  for(; *s; s++)
 38e:	40                   	inc    %eax
 38f:	eb f3                	jmp    384 <strchr+0xd>
      return (char*)s;
  return 0;
 391:	b8 00 00 00 00       	mov    $0x0,%eax
}
 396:	5d                   	pop    %ebp
 397:	c3                   	ret    

00000398 <gets>:

char*
gets(char *buf, int max)
{
 398:	f3 0f 1e fb          	endbr32 
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	57                   	push   %edi
 3a0:	56                   	push   %esi
 3a1:	53                   	push   %ebx
 3a2:	83 ec 1c             	sub    $0x1c,%esp
 3a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a8:	bb 00 00 00 00       	mov    $0x0,%ebx
 3ad:	89 de                	mov    %ebx,%esi
 3af:	43                   	inc    %ebx
 3b0:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3b3:	7d 2b                	jge    3e0 <gets+0x48>
    cc = read(0, &c, 1);
 3b5:	83 ec 04             	sub    $0x4,%esp
 3b8:	6a 01                	push   $0x1
 3ba:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3bd:	50                   	push   %eax
 3be:	6a 00                	push   $0x0
 3c0:	e8 ed 00 00 00       	call   4b2 <read>
    if(cc < 1)
 3c5:	83 c4 10             	add    $0x10,%esp
 3c8:	85 c0                	test   %eax,%eax
 3ca:	7e 14                	jle    3e0 <gets+0x48>
      break;
    buf[i++] = c;
 3cc:	8a 45 e7             	mov    -0x19(%ebp),%al
 3cf:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 3d2:	3c 0a                	cmp    $0xa,%al
 3d4:	74 08                	je     3de <gets+0x46>
 3d6:	3c 0d                	cmp    $0xd,%al
 3d8:	75 d3                	jne    3ad <gets+0x15>
    buf[i++] = c;
 3da:	89 de                	mov    %ebx,%esi
 3dc:	eb 02                	jmp    3e0 <gets+0x48>
 3de:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3e0:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3e4:	89 f8                	mov    %edi,%eax
 3e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e9:	5b                   	pop    %ebx
 3ea:	5e                   	pop    %esi
 3eb:	5f                   	pop    %edi
 3ec:	5d                   	pop    %ebp
 3ed:	c3                   	ret    

000003ee <stat>:

int
stat(const char *n, struct stat *st)
{
 3ee:	f3 0f 1e fb          	endbr32 
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	56                   	push   %esi
 3f6:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f7:	83 ec 08             	sub    $0x8,%esp
 3fa:	6a 00                	push   $0x0
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 d6 00 00 00       	call   4da <open>
  if(fd < 0)
 404:	83 c4 10             	add    $0x10,%esp
 407:	85 c0                	test   %eax,%eax
 409:	78 24                	js     42f <stat+0x41>
 40b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 40d:	83 ec 08             	sub    $0x8,%esp
 410:	ff 75 0c             	pushl  0xc(%ebp)
 413:	50                   	push   %eax
 414:	e8 d9 00 00 00       	call   4f2 <fstat>
 419:	89 c6                	mov    %eax,%esi
  close(fd);
 41b:	89 1c 24             	mov    %ebx,(%esp)
 41e:	e8 9f 00 00 00       	call   4c2 <close>
  return r;
 423:	83 c4 10             	add    $0x10,%esp
}
 426:	89 f0                	mov    %esi,%eax
 428:	8d 65 f8             	lea    -0x8(%ebp),%esp
 42b:	5b                   	pop    %ebx
 42c:	5e                   	pop    %esi
 42d:	5d                   	pop    %ebp
 42e:	c3                   	ret    
    return -1;
 42f:	be ff ff ff ff       	mov    $0xffffffff,%esi
 434:	eb f0                	jmp    426 <stat+0x38>

00000436 <atoi>:

int
atoi(const char *s)
{
 436:	f3 0f 1e fb          	endbr32 
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	53                   	push   %ebx
 43e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 441:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 446:	8a 01                	mov    (%ecx),%al
 448:	8d 58 d0             	lea    -0x30(%eax),%ebx
 44b:	80 fb 09             	cmp    $0x9,%bl
 44e:	77 10                	ja     460 <atoi+0x2a>
    n = n*10 + *s++ - '0';
 450:	8d 14 92             	lea    (%edx,%edx,4),%edx
 453:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 456:	41                   	inc    %ecx
 457:	0f be c0             	movsbl %al,%eax
 45a:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 45e:	eb e6                	jmp    446 <atoi+0x10>
  return n;
}
 460:	89 d0                	mov    %edx,%eax
 462:	5b                   	pop    %ebx
 463:	5d                   	pop    %ebp
 464:	c3                   	ret    

00000465 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 465:	f3 0f 1e fb          	endbr32 
 469:	55                   	push   %ebp
 46a:	89 e5                	mov    %esp,%ebp
 46c:	56                   	push   %esi
 46d:	53                   	push   %ebx
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 474:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 477:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 479:	8d 72 ff             	lea    -0x1(%edx),%esi
 47c:	85 d2                	test   %edx,%edx
 47e:	7e 0e                	jle    48e <memmove+0x29>
    *dst++ = *src++;
 480:	8a 13                	mov    (%ebx),%dl
 482:	88 11                	mov    %dl,(%ecx)
 484:	8d 5b 01             	lea    0x1(%ebx),%ebx
 487:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 48a:	89 f2                	mov    %esi,%edx
 48c:	eb eb                	jmp    479 <memmove+0x14>
  return vdst;
}
 48e:	5b                   	pop    %ebx
 48f:	5e                   	pop    %esi
 490:	5d                   	pop    %ebp
 491:	c3                   	ret    

00000492 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 492:	b8 01 00 00 00       	mov    $0x1,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <exit>:
SYSCALL(exit)
 49a:	b8 02 00 00 00       	mov    $0x2,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <wait>:
SYSCALL(wait)
 4a2:	b8 03 00 00 00       	mov    $0x3,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <pipe>:
SYSCALL(pipe)
 4aa:	b8 04 00 00 00       	mov    $0x4,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <read>:
SYSCALL(read)
 4b2:	b8 05 00 00 00       	mov    $0x5,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <write>:
SYSCALL(write)
 4ba:	b8 10 00 00 00       	mov    $0x10,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <close>:
SYSCALL(close)
 4c2:	b8 15 00 00 00       	mov    $0x15,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <kill>:
SYSCALL(kill)
 4ca:	b8 06 00 00 00       	mov    $0x6,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <exec>:
SYSCALL(exec)
 4d2:	b8 07 00 00 00       	mov    $0x7,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <open>:
SYSCALL(open)
 4da:	b8 0f 00 00 00       	mov    $0xf,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <mknod>:
SYSCALL(mknod)
 4e2:	b8 11 00 00 00       	mov    $0x11,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <unlink>:
SYSCALL(unlink)
 4ea:	b8 12 00 00 00       	mov    $0x12,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <fstat>:
SYSCALL(fstat)
 4f2:	b8 08 00 00 00       	mov    $0x8,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <link>:
SYSCALL(link)
 4fa:	b8 13 00 00 00       	mov    $0x13,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <mkdir>:
SYSCALL(mkdir)
 502:	b8 14 00 00 00       	mov    $0x14,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <chdir>:
SYSCALL(chdir)
 50a:	b8 09 00 00 00       	mov    $0x9,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <dup>:
SYSCALL(dup)
 512:	b8 0a 00 00 00       	mov    $0xa,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <getpid>:
SYSCALL(getpid)
 51a:	b8 0b 00 00 00       	mov    $0xb,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <sbrk>:
SYSCALL(sbrk)
 522:	b8 0c 00 00 00       	mov    $0xc,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <sleep>:
SYSCALL(sleep)
 52a:	b8 0d 00 00 00       	mov    $0xd,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <uptime>:
SYSCALL(uptime)
 532:	b8 0e 00 00 00       	mov    $0xe,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <date>:
SYSCALL(date)
 53a:	b8 16 00 00 00       	mov    $0x16,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <dup2>:
 542:	b8 17 00 00 00       	mov    $0x17,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 54a:	55                   	push   %ebp
 54b:	89 e5                	mov    %esp,%ebp
 54d:	83 ec 1c             	sub    $0x1c,%esp
 550:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 553:	6a 01                	push   $0x1
 555:	8d 55 f4             	lea    -0xc(%ebp),%edx
 558:	52                   	push   %edx
 559:	50                   	push   %eax
 55a:	e8 5b ff ff ff       	call   4ba <write>
}
 55f:	83 c4 10             	add    $0x10,%esp
 562:	c9                   	leave  
 563:	c3                   	ret    

00000564 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	57                   	push   %edi
 568:	56                   	push   %esi
 569:	53                   	push   %ebx
 56a:	83 ec 2c             	sub    $0x2c,%esp
 56d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 570:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 572:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 576:	74 04                	je     57c <printint+0x18>
 578:	85 d2                	test   %edx,%edx
 57a:	78 3a                	js     5b6 <printint+0x52>
  neg = 0;
 57c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 583:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 588:	89 f0                	mov    %esi,%eax
 58a:	ba 00 00 00 00       	mov    $0x0,%edx
 58f:	f7 f1                	div    %ecx
 591:	89 df                	mov    %ebx,%edi
 593:	43                   	inc    %ebx
 594:	8a 92 88 07 00 00    	mov    0x788(%edx),%dl
 59a:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 59e:	89 f2                	mov    %esi,%edx
 5a0:	89 c6                	mov    %eax,%esi
 5a2:	39 d1                	cmp    %edx,%ecx
 5a4:	76 e2                	jbe    588 <printint+0x24>
  if(neg)
 5a6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 5aa:	74 22                	je     5ce <printint+0x6a>
    buf[i++] = '-';
 5ac:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 5b1:	8d 5f 02             	lea    0x2(%edi),%ebx
 5b4:	eb 18                	jmp    5ce <printint+0x6a>
    x = -xx;
 5b6:	f7 de                	neg    %esi
    neg = 1;
 5b8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 5bf:	eb c2                	jmp    583 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 5c1:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 5c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5c9:	e8 7c ff ff ff       	call   54a <putc>
  while(--i >= 0)
 5ce:	4b                   	dec    %ebx
 5cf:	79 f0                	jns    5c1 <printint+0x5d>
}
 5d1:	83 c4 2c             	add    $0x2c,%esp
 5d4:	5b                   	pop    %ebx
 5d5:	5e                   	pop    %esi
 5d6:	5f                   	pop    %edi
 5d7:	5d                   	pop    %ebp
 5d8:	c3                   	ret    

000005d9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5d9:	f3 0f 1e fb          	endbr32 
 5dd:	55                   	push   %ebp
 5de:	89 e5                	mov    %esp,%ebp
 5e0:	57                   	push   %edi
 5e1:	56                   	push   %esi
 5e2:	53                   	push   %ebx
 5e3:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5e6:	8d 45 10             	lea    0x10(%ebp),%eax
 5e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5ec:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5f1:	bb 00 00 00 00       	mov    $0x0,%ebx
 5f6:	eb 12                	jmp    60a <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5f8:	89 fa                	mov    %edi,%edx
 5fa:	8b 45 08             	mov    0x8(%ebp),%eax
 5fd:	e8 48 ff ff ff       	call   54a <putc>
 602:	eb 05                	jmp    609 <printf+0x30>
      }
    } else if(state == '%'){
 604:	83 fe 25             	cmp    $0x25,%esi
 607:	74 22                	je     62b <printf+0x52>
  for(i = 0; fmt[i]; i++){
 609:	43                   	inc    %ebx
 60a:	8b 45 0c             	mov    0xc(%ebp),%eax
 60d:	8a 04 18             	mov    (%eax,%ebx,1),%al
 610:	84 c0                	test   %al,%al
 612:	0f 84 13 01 00 00    	je     72b <printf+0x152>
    c = fmt[i] & 0xff;
 618:	0f be f8             	movsbl %al,%edi
 61b:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 61e:	85 f6                	test   %esi,%esi
 620:	75 e2                	jne    604 <printf+0x2b>
      if(c == '%'){
 622:	83 f8 25             	cmp    $0x25,%eax
 625:	75 d1                	jne    5f8 <printf+0x1f>
        state = '%';
 627:	89 c6                	mov    %eax,%esi
 629:	eb de                	jmp    609 <printf+0x30>
      if(c == 'd'){
 62b:	83 f8 64             	cmp    $0x64,%eax
 62e:	74 43                	je     673 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 630:	83 f8 78             	cmp    $0x78,%eax
 633:	74 68                	je     69d <printf+0xc4>
 635:	83 f8 70             	cmp    $0x70,%eax
 638:	74 63                	je     69d <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 63a:	83 f8 73             	cmp    $0x73,%eax
 63d:	0f 84 84 00 00 00    	je     6c7 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 643:	83 f8 63             	cmp    $0x63,%eax
 646:	0f 84 ad 00 00 00    	je     6f9 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 64c:	83 f8 25             	cmp    $0x25,%eax
 64f:	0f 84 c2 00 00 00    	je     717 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 655:	ba 25 00 00 00       	mov    $0x25,%edx
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	e8 e8 fe ff ff       	call   54a <putc>
        putc(fd, c);
 662:	89 fa                	mov    %edi,%edx
 664:	8b 45 08             	mov    0x8(%ebp),%eax
 667:	e8 de fe ff ff       	call   54a <putc>
      }
      state = 0;
 66c:	be 00 00 00 00       	mov    $0x0,%esi
 671:	eb 96                	jmp    609 <printf+0x30>
        printint(fd, *ap, 10, 1);
 673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 676:	8b 17                	mov    (%edi),%edx
 678:	83 ec 0c             	sub    $0xc,%esp
 67b:	6a 01                	push   $0x1
 67d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 682:	8b 45 08             	mov    0x8(%ebp),%eax
 685:	e8 da fe ff ff       	call   564 <printint>
        ap++;
 68a:	83 c7 04             	add    $0x4,%edi
 68d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 690:	83 c4 10             	add    $0x10,%esp
      state = 0;
 693:	be 00 00 00 00       	mov    $0x0,%esi
 698:	e9 6c ff ff ff       	jmp    609 <printf+0x30>
        printint(fd, *ap, 16, 0);
 69d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6a0:	8b 17                	mov    (%edi),%edx
 6a2:	83 ec 0c             	sub    $0xc,%esp
 6a5:	6a 00                	push   $0x0
 6a7:	b9 10 00 00 00       	mov    $0x10,%ecx
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	e8 b0 fe ff ff       	call   564 <printint>
        ap++;
 6b4:	83 c7 04             	add    $0x4,%edi
 6b7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6ba:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6bd:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 6c2:	e9 42 ff ff ff       	jmp    609 <printf+0x30>
        s = (char*)*ap;
 6c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ca:	8b 30                	mov    (%eax),%esi
        ap++;
 6cc:	83 c0 04             	add    $0x4,%eax
 6cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 6d2:	85 f6                	test   %esi,%esi
 6d4:	75 13                	jne    6e9 <printf+0x110>
          s = "(null)";
 6d6:	be 7e 07 00 00       	mov    $0x77e,%esi
 6db:	eb 0c                	jmp    6e9 <printf+0x110>
          putc(fd, *s);
 6dd:	0f be d2             	movsbl %dl,%edx
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
 6e3:	e8 62 fe ff ff       	call   54a <putc>
          s++;
 6e8:	46                   	inc    %esi
        while(*s != 0){
 6e9:	8a 16                	mov    (%esi),%dl
 6eb:	84 d2                	test   %dl,%dl
 6ed:	75 ee                	jne    6dd <printf+0x104>
      state = 0;
 6ef:	be 00 00 00 00       	mov    $0x0,%esi
 6f4:	e9 10 ff ff ff       	jmp    609 <printf+0x30>
        putc(fd, *ap);
 6f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6fc:	0f be 17             	movsbl (%edi),%edx
 6ff:	8b 45 08             	mov    0x8(%ebp),%eax
 702:	e8 43 fe ff ff       	call   54a <putc>
        ap++;
 707:	83 c7 04             	add    $0x4,%edi
 70a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 70d:	be 00 00 00 00       	mov    $0x0,%esi
 712:	e9 f2 fe ff ff       	jmp    609 <printf+0x30>
        putc(fd, c);
 717:	89 fa                	mov    %edi,%edx
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	e8 29 fe ff ff       	call   54a <putc>
      state = 0;
 721:	be 00 00 00 00       	mov    $0x0,%esi
 726:	e9 de fe ff ff       	jmp    609 <printf+0x30>
    }
  }
}
 72b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 72e:	5b                   	pop    %ebx
 72f:	5e                   	pop    %esi
 730:	5f                   	pop    %edi
 731:	5d                   	pop    %ebp
 732:	c3                   	ret    
