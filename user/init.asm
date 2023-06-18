
init:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  13:	83 ec 08             	sub    $0x8,%esp
  16:	6a 02                	push   $0x2
  18:	68 9c 03 00 00       	push   $0x39c
  1d:	e8 20 01 00 00       	call   142 <open>
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	78 61                	js     8a <main+0x8a>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 47 01 00 00       	call   17a <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 3b 01 00 00       	call   17a <dup>
  3f:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  42:	83 ec 08             	sub    $0x8,%esp
  45:	68 a4 03 00 00       	push   $0x3a4
  4a:	6a 01                	push   $0x1
  4c:	e8 f0 01 00 00       	call   241 <printf>
    pid = fork();
  51:	e8 a4 00 00 00       	call   fa <fork>
  56:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  58:	83 c4 10             	add    $0x10,%esp
  5b:	85 c0                	test   %eax,%eax
  5d:	78 53                	js     b2 <main+0xb2>
      printf(1, "init: fork failed\n");
      exit(0);
    }
    if(pid == 0){
  5f:	74 6c                	je     cd <main+0xcd>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit(0);
    }
    while((wpid=wait(NULL)) >= 0 && wpid != pid)
  61:	83 ec 0c             	sub    $0xc,%esp
  64:	6a 00                	push   $0x0
  66:	e8 9f 00 00 00       	call   10a <wait>
  6b:	83 c4 10             	add    $0x10,%esp
  6e:	85 c0                	test   %eax,%eax
  70:	78 d0                	js     42 <main+0x42>
  72:	39 c3                	cmp    %eax,%ebx
  74:	74 cc                	je     42 <main+0x42>
      printf(1, "zombie!\n");
  76:	83 ec 08             	sub    $0x8,%esp
  79:	68 e3 03 00 00       	push   $0x3e3
  7e:	6a 01                	push   $0x1
  80:	e8 bc 01 00 00       	call   241 <printf>
  85:	83 c4 10             	add    $0x10,%esp
  88:	eb d7                	jmp    61 <main+0x61>
    mknod("console", 1, 1);
  8a:	83 ec 04             	sub    $0x4,%esp
  8d:	6a 01                	push   $0x1
  8f:	6a 01                	push   $0x1
  91:	68 9c 03 00 00       	push   $0x39c
  96:	e8 af 00 00 00       	call   14a <mknod>
    open("console", O_RDWR);
  9b:	83 c4 08             	add    $0x8,%esp
  9e:	6a 02                	push   $0x2
  a0:	68 9c 03 00 00       	push   $0x39c
  a5:	e8 98 00 00 00       	call   142 <open>
  aa:	83 c4 10             	add    $0x10,%esp
  ad:	e9 77 ff ff ff       	jmp    29 <main+0x29>
      printf(1, "init: fork failed\n");
  b2:	83 ec 08             	sub    $0x8,%esp
  b5:	68 b7 03 00 00       	push   $0x3b7
  ba:	6a 01                	push   $0x1
  bc:	e8 80 01 00 00       	call   241 <printf>
      exit(0);
  c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  c8:	e8 35 00 00 00       	call   102 <exit>
      exec("sh", argv);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	68 c4 04 00 00       	push   $0x4c4
  d5:	68 ca 03 00 00       	push   $0x3ca
  da:	e8 5b 00 00 00       	call   13a <exec>
      printf(1, "init: exec sh failed\n");
  df:	83 c4 08             	add    $0x8,%esp
  e2:	68 cd 03 00 00       	push   $0x3cd
  e7:	6a 01                	push   $0x1
  e9:	e8 53 01 00 00       	call   241 <printf>
      exit(0);
  ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  f5:	e8 08 00 00 00       	call   102 <exit>

000000fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  fa:	b8 01 00 00 00       	mov    $0x1,%eax
  ff:	cd 40                	int    $0x40
 101:	c3                   	ret    

00000102 <exit>:
SYSCALL(exit)
 102:	b8 02 00 00 00       	mov    $0x2,%eax
 107:	cd 40                	int    $0x40
 109:	c3                   	ret    

0000010a <wait>:
SYSCALL(wait)
 10a:	b8 03 00 00 00       	mov    $0x3,%eax
 10f:	cd 40                	int    $0x40
 111:	c3                   	ret    

00000112 <pipe>:
SYSCALL(pipe)
 112:	b8 04 00 00 00       	mov    $0x4,%eax
 117:	cd 40                	int    $0x40
 119:	c3                   	ret    

0000011a <read>:
SYSCALL(read)
 11a:	b8 05 00 00 00       	mov    $0x5,%eax
 11f:	cd 40                	int    $0x40
 121:	c3                   	ret    

00000122 <write>:
SYSCALL(write)
 122:	b8 10 00 00 00       	mov    $0x10,%eax
 127:	cd 40                	int    $0x40
 129:	c3                   	ret    

0000012a <close>:
SYSCALL(close)
 12a:	b8 15 00 00 00       	mov    $0x15,%eax
 12f:	cd 40                	int    $0x40
 131:	c3                   	ret    

00000132 <kill>:
SYSCALL(kill)
 132:	b8 06 00 00 00       	mov    $0x6,%eax
 137:	cd 40                	int    $0x40
 139:	c3                   	ret    

0000013a <exec>:
SYSCALL(exec)
 13a:	b8 07 00 00 00       	mov    $0x7,%eax
 13f:	cd 40                	int    $0x40
 141:	c3                   	ret    

00000142 <open>:
SYSCALL(open)
 142:	b8 0f 00 00 00       	mov    $0xf,%eax
 147:	cd 40                	int    $0x40
 149:	c3                   	ret    

0000014a <mknod>:
SYSCALL(mknod)
 14a:	b8 11 00 00 00       	mov    $0x11,%eax
 14f:	cd 40                	int    $0x40
 151:	c3                   	ret    

00000152 <unlink>:
SYSCALL(unlink)
 152:	b8 12 00 00 00       	mov    $0x12,%eax
 157:	cd 40                	int    $0x40
 159:	c3                   	ret    

0000015a <fstat>:
SYSCALL(fstat)
 15a:	b8 08 00 00 00       	mov    $0x8,%eax
 15f:	cd 40                	int    $0x40
 161:	c3                   	ret    

00000162 <link>:
SYSCALL(link)
 162:	b8 13 00 00 00       	mov    $0x13,%eax
 167:	cd 40                	int    $0x40
 169:	c3                   	ret    

0000016a <mkdir>:
SYSCALL(mkdir)
 16a:	b8 14 00 00 00       	mov    $0x14,%eax
 16f:	cd 40                	int    $0x40
 171:	c3                   	ret    

00000172 <chdir>:
SYSCALL(chdir)
 172:	b8 09 00 00 00       	mov    $0x9,%eax
 177:	cd 40                	int    $0x40
 179:	c3                   	ret    

0000017a <dup>:
SYSCALL(dup)
 17a:	b8 0a 00 00 00       	mov    $0xa,%eax
 17f:	cd 40                	int    $0x40
 181:	c3                   	ret    

00000182 <getpid>:
SYSCALL(getpid)
 182:	b8 0b 00 00 00       	mov    $0xb,%eax
 187:	cd 40                	int    $0x40
 189:	c3                   	ret    

0000018a <sbrk>:
SYSCALL(sbrk)
 18a:	b8 0c 00 00 00       	mov    $0xc,%eax
 18f:	cd 40                	int    $0x40
 191:	c3                   	ret    

00000192 <sleep>:
SYSCALL(sleep)
 192:	b8 0d 00 00 00       	mov    $0xd,%eax
 197:	cd 40                	int    $0x40
 199:	c3                   	ret    

0000019a <uptime>:
SYSCALL(uptime)
 19a:	b8 0e 00 00 00       	mov    $0xe,%eax
 19f:	cd 40                	int    $0x40
 1a1:	c3                   	ret    

000001a2 <date>:
SYSCALL(date)
 1a2:	b8 16 00 00 00       	mov    $0x16,%eax
 1a7:	cd 40                	int    $0x40
 1a9:	c3                   	ret    

000001aa <dup2>:
 1aa:	b8 17 00 00 00       	mov    $0x17,%eax
 1af:	cd 40                	int    $0x40
 1b1:	c3                   	ret    

000001b2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	83 ec 1c             	sub    $0x1c,%esp
 1b8:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1bb:	6a 01                	push   $0x1
 1bd:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1c0:	52                   	push   %edx
 1c1:	50                   	push   %eax
 1c2:	e8 5b ff ff ff       	call   122 <write>
}
 1c7:	83 c4 10             	add    $0x10,%esp
 1ca:	c9                   	leave  
 1cb:	c3                   	ret    

000001cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	57                   	push   %edi
 1d0:	56                   	push   %esi
 1d1:	53                   	push   %ebx
 1d2:	83 ec 2c             	sub    $0x2c,%esp
 1d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1d8:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1de:	74 04                	je     1e4 <printint+0x18>
 1e0:	85 d2                	test   %edx,%edx
 1e2:	78 3a                	js     21e <printint+0x52>
  neg = 0;
 1e4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1f0:	89 f0                	mov    %esi,%eax
 1f2:	ba 00 00 00 00       	mov    $0x0,%edx
 1f7:	f7 f1                	div    %ecx
 1f9:	89 df                	mov    %ebx,%edi
 1fb:	43                   	inc    %ebx
 1fc:	8a 92 f4 03 00 00    	mov    0x3f4(%edx),%dl
 202:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 206:	89 f2                	mov    %esi,%edx
 208:	89 c6                	mov    %eax,%esi
 20a:	39 d1                	cmp    %edx,%ecx
 20c:	76 e2                	jbe    1f0 <printint+0x24>
  if(neg)
 20e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 212:	74 22                	je     236 <printint+0x6a>
    buf[i++] = '-';
 214:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 219:	8d 5f 02             	lea    0x2(%edi),%ebx
 21c:	eb 18                	jmp    236 <printint+0x6a>
    x = -xx;
 21e:	f7 de                	neg    %esi
    neg = 1;
 220:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 227:	eb c2                	jmp    1eb <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 229:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 22e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 231:	e8 7c ff ff ff       	call   1b2 <putc>
  while(--i >= 0)
 236:	4b                   	dec    %ebx
 237:	79 f0                	jns    229 <printint+0x5d>
}
 239:	83 c4 2c             	add    $0x2c,%esp
 23c:	5b                   	pop    %ebx
 23d:	5e                   	pop    %esi
 23e:	5f                   	pop    %edi
 23f:	5d                   	pop    %ebp
 240:	c3                   	ret    

00000241 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 241:	f3 0f 1e fb          	endbr32 
 245:	55                   	push   %ebp
 246:	89 e5                	mov    %esp,%ebp
 248:	57                   	push   %edi
 249:	56                   	push   %esi
 24a:	53                   	push   %ebx
 24b:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 24e:	8d 45 10             	lea    0x10(%ebp),%eax
 251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 254:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 259:	bb 00 00 00 00       	mov    $0x0,%ebx
 25e:	eb 12                	jmp    272 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 260:	89 fa                	mov    %edi,%edx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	e8 48 ff ff ff       	call   1b2 <putc>
 26a:	eb 05                	jmp    271 <printf+0x30>
      }
    } else if(state == '%'){
 26c:	83 fe 25             	cmp    $0x25,%esi
 26f:	74 22                	je     293 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 271:	43                   	inc    %ebx
 272:	8b 45 0c             	mov    0xc(%ebp),%eax
 275:	8a 04 18             	mov    (%eax,%ebx,1),%al
 278:	84 c0                	test   %al,%al
 27a:	0f 84 13 01 00 00    	je     393 <printf+0x152>
    c = fmt[i] & 0xff;
 280:	0f be f8             	movsbl %al,%edi
 283:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 286:	85 f6                	test   %esi,%esi
 288:	75 e2                	jne    26c <printf+0x2b>
      if(c == '%'){
 28a:	83 f8 25             	cmp    $0x25,%eax
 28d:	75 d1                	jne    260 <printf+0x1f>
        state = '%';
 28f:	89 c6                	mov    %eax,%esi
 291:	eb de                	jmp    271 <printf+0x30>
      if(c == 'd'){
 293:	83 f8 64             	cmp    $0x64,%eax
 296:	74 43                	je     2db <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 298:	83 f8 78             	cmp    $0x78,%eax
 29b:	74 68                	je     305 <printf+0xc4>
 29d:	83 f8 70             	cmp    $0x70,%eax
 2a0:	74 63                	je     305 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 2a2:	83 f8 73             	cmp    $0x73,%eax
 2a5:	0f 84 84 00 00 00    	je     32f <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 2ab:	83 f8 63             	cmp    $0x63,%eax
 2ae:	0f 84 ad 00 00 00    	je     361 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 2b4:	83 f8 25             	cmp    $0x25,%eax
 2b7:	0f 84 c2 00 00 00    	je     37f <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 2bd:	ba 25 00 00 00       	mov    $0x25,%edx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	e8 e8 fe ff ff       	call   1b2 <putc>
        putc(fd, c);
 2ca:	89 fa                	mov    %edi,%edx
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	e8 de fe ff ff       	call   1b2 <putc>
      }
      state = 0;
 2d4:	be 00 00 00 00       	mov    $0x0,%esi
 2d9:	eb 96                	jmp    271 <printf+0x30>
        printint(fd, *ap, 10, 1);
 2db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2de:	8b 17                	mov    (%edi),%edx
 2e0:	83 ec 0c             	sub    $0xc,%esp
 2e3:	6a 01                	push   $0x1
 2e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	e8 da fe ff ff       	call   1cc <printint>
        ap++;
 2f2:	83 c7 04             	add    $0x4,%edi
 2f5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2fb:	be 00 00 00 00       	mov    $0x0,%esi
 300:	e9 6c ff ff ff       	jmp    271 <printf+0x30>
        printint(fd, *ap, 16, 0);
 305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 308:	8b 17                	mov    (%edi),%edx
 30a:	83 ec 0c             	sub    $0xc,%esp
 30d:	6a 00                	push   $0x0
 30f:	b9 10 00 00 00       	mov    $0x10,%ecx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	e8 b0 fe ff ff       	call   1cc <printint>
        ap++;
 31c:	83 c7 04             	add    $0x4,%edi
 31f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 322:	83 c4 10             	add    $0x10,%esp
      state = 0;
 325:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 32a:	e9 42 ff ff ff       	jmp    271 <printf+0x30>
        s = (char*)*ap;
 32f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 332:	8b 30                	mov    (%eax),%esi
        ap++;
 334:	83 c0 04             	add    $0x4,%eax
 337:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 33a:	85 f6                	test   %esi,%esi
 33c:	75 13                	jne    351 <printf+0x110>
          s = "(null)";
 33e:	be ec 03 00 00       	mov    $0x3ec,%esi
 343:	eb 0c                	jmp    351 <printf+0x110>
          putc(fd, *s);
 345:	0f be d2             	movsbl %dl,%edx
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	e8 62 fe ff ff       	call   1b2 <putc>
          s++;
 350:	46                   	inc    %esi
        while(*s != 0){
 351:	8a 16                	mov    (%esi),%dl
 353:	84 d2                	test   %dl,%dl
 355:	75 ee                	jne    345 <printf+0x104>
      state = 0;
 357:	be 00 00 00 00       	mov    $0x0,%esi
 35c:	e9 10 ff ff ff       	jmp    271 <printf+0x30>
        putc(fd, *ap);
 361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 364:	0f be 17             	movsbl (%edi),%edx
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	e8 43 fe ff ff       	call   1b2 <putc>
        ap++;
 36f:	83 c7 04             	add    $0x4,%edi
 372:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 375:	be 00 00 00 00       	mov    $0x0,%esi
 37a:	e9 f2 fe ff ff       	jmp    271 <printf+0x30>
        putc(fd, c);
 37f:	89 fa                	mov    %edi,%edx
 381:	8b 45 08             	mov    0x8(%ebp),%eax
 384:	e8 29 fe ff ff       	call   1b2 <putc>
      state = 0;
 389:	be 00 00 00 00       	mov    $0x0,%esi
 38e:	e9 de fe ff ff       	jmp    271 <printf+0x30>
    }
  }
}
 393:	8d 65 f4             	lea    -0xc(%ebp),%esp
 396:	5b                   	pop    %ebx
 397:	5e                   	pop    %esi
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret    
