
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
  18:	68 7c 03 00 00       	push   $0x37c
  1d:	e8 07 01 00 00       	call   129 <open>
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	78 59                	js     82 <main+0x82>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 2e 01 00 00       	call   161 <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 22 01 00 00       	call   161 <dup>
  3f:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  42:	83 ec 08             	sub    $0x8,%esp
  45:	68 84 03 00 00       	push   $0x384
  4a:	6a 01                	push   $0x1
  4c:	e8 cf 01 00 00       	call   220 <printf>
    pid = fork();
  51:	e8 8b 00 00 00       	call   e1 <fork>
  56:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  58:	83 c4 10             	add    $0x10,%esp
  5b:	85 c0                	test   %eax,%eax
  5d:	78 48                	js     a7 <main+0xa7>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  5f:	74 5a                	je     bb <main+0xbb>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  61:	e8 8b 00 00 00       	call   f1 <wait>
  66:	85 c0                	test   %eax,%eax
  68:	78 d8                	js     42 <main+0x42>
  6a:	39 c3                	cmp    %eax,%ebx
  6c:	74 d4                	je     42 <main+0x42>
      printf(1, "zombie!\n");
  6e:	83 ec 08             	sub    $0x8,%esp
  71:	68 c3 03 00 00       	push   $0x3c3
  76:	6a 01                	push   $0x1
  78:	e8 a3 01 00 00       	call   220 <printf>
  7d:	83 c4 10             	add    $0x10,%esp
  80:	eb df                	jmp    61 <main+0x61>
    mknod("console", 1, 1);
  82:	83 ec 04             	sub    $0x4,%esp
  85:	6a 01                	push   $0x1
  87:	6a 01                	push   $0x1
  89:	68 7c 03 00 00       	push   $0x37c
  8e:	e8 9e 00 00 00       	call   131 <mknod>
    open("console", O_RDWR);
  93:	83 c4 08             	add    $0x8,%esp
  96:	6a 02                	push   $0x2
  98:	68 7c 03 00 00       	push   $0x37c
  9d:	e8 87 00 00 00       	call   129 <open>
  a2:	83 c4 10             	add    $0x10,%esp
  a5:	eb 82                	jmp    29 <main+0x29>
      printf(1, "init: fork failed\n");
  a7:	83 ec 08             	sub    $0x8,%esp
  aa:	68 97 03 00 00       	push   $0x397
  af:	6a 01                	push   $0x1
  b1:	e8 6a 01 00 00       	call   220 <printf>
      exit();
  b6:	e8 2e 00 00 00       	call   e9 <exit>
      exec("sh", argv);
  bb:	83 ec 08             	sub    $0x8,%esp
  be:	68 a4 04 00 00       	push   $0x4a4
  c3:	68 aa 03 00 00       	push   $0x3aa
  c8:	e8 54 00 00 00       	call   121 <exec>
      printf(1, "init: exec sh failed\n");
  cd:	83 c4 08             	add    $0x8,%esp
  d0:	68 ad 03 00 00       	push   $0x3ad
  d5:	6a 01                	push   $0x1
  d7:	e8 44 01 00 00       	call   220 <printf>
      exit();
  dc:	e8 08 00 00 00       	call   e9 <exit>

000000e1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  e1:	b8 01 00 00 00       	mov    $0x1,%eax
  e6:	cd 40                	int    $0x40
  e8:	c3                   	ret    

000000e9 <exit>:
SYSCALL(exit)
  e9:	b8 02 00 00 00       	mov    $0x2,%eax
  ee:	cd 40                	int    $0x40
  f0:	c3                   	ret    

000000f1 <wait>:
SYSCALL(wait)
  f1:	b8 03 00 00 00       	mov    $0x3,%eax
  f6:	cd 40                	int    $0x40
  f8:	c3                   	ret    

000000f9 <pipe>:
SYSCALL(pipe)
  f9:	b8 04 00 00 00       	mov    $0x4,%eax
  fe:	cd 40                	int    $0x40
 100:	c3                   	ret    

00000101 <read>:
SYSCALL(read)
 101:	b8 05 00 00 00       	mov    $0x5,%eax
 106:	cd 40                	int    $0x40
 108:	c3                   	ret    

00000109 <write>:
SYSCALL(write)
 109:	b8 10 00 00 00       	mov    $0x10,%eax
 10e:	cd 40                	int    $0x40
 110:	c3                   	ret    

00000111 <close>:
SYSCALL(close)
 111:	b8 15 00 00 00       	mov    $0x15,%eax
 116:	cd 40                	int    $0x40
 118:	c3                   	ret    

00000119 <kill>:
SYSCALL(kill)
 119:	b8 06 00 00 00       	mov    $0x6,%eax
 11e:	cd 40                	int    $0x40
 120:	c3                   	ret    

00000121 <exec>:
SYSCALL(exec)
 121:	b8 07 00 00 00       	mov    $0x7,%eax
 126:	cd 40                	int    $0x40
 128:	c3                   	ret    

00000129 <open>:
SYSCALL(open)
 129:	b8 0f 00 00 00       	mov    $0xf,%eax
 12e:	cd 40                	int    $0x40
 130:	c3                   	ret    

00000131 <mknod>:
SYSCALL(mknod)
 131:	b8 11 00 00 00       	mov    $0x11,%eax
 136:	cd 40                	int    $0x40
 138:	c3                   	ret    

00000139 <unlink>:
SYSCALL(unlink)
 139:	b8 12 00 00 00       	mov    $0x12,%eax
 13e:	cd 40                	int    $0x40
 140:	c3                   	ret    

00000141 <fstat>:
SYSCALL(fstat)
 141:	b8 08 00 00 00       	mov    $0x8,%eax
 146:	cd 40                	int    $0x40
 148:	c3                   	ret    

00000149 <link>:
SYSCALL(link)
 149:	b8 13 00 00 00       	mov    $0x13,%eax
 14e:	cd 40                	int    $0x40
 150:	c3                   	ret    

00000151 <mkdir>:
SYSCALL(mkdir)
 151:	b8 14 00 00 00       	mov    $0x14,%eax
 156:	cd 40                	int    $0x40
 158:	c3                   	ret    

00000159 <chdir>:
SYSCALL(chdir)
 159:	b8 09 00 00 00       	mov    $0x9,%eax
 15e:	cd 40                	int    $0x40
 160:	c3                   	ret    

00000161 <dup>:
SYSCALL(dup)
 161:	b8 0a 00 00 00       	mov    $0xa,%eax
 166:	cd 40                	int    $0x40
 168:	c3                   	ret    

00000169 <getpid>:
SYSCALL(getpid)
 169:	b8 0b 00 00 00       	mov    $0xb,%eax
 16e:	cd 40                	int    $0x40
 170:	c3                   	ret    

00000171 <sbrk>:
SYSCALL(sbrk)
 171:	b8 0c 00 00 00       	mov    $0xc,%eax
 176:	cd 40                	int    $0x40
 178:	c3                   	ret    

00000179 <sleep>:
SYSCALL(sleep)
 179:	b8 0d 00 00 00       	mov    $0xd,%eax
 17e:	cd 40                	int    $0x40
 180:	c3                   	ret    

00000181 <uptime>:
SYSCALL(uptime)
 181:	b8 0e 00 00 00       	mov    $0xe,%eax
 186:	cd 40                	int    $0x40
 188:	c3                   	ret    

00000189 <date>:
SYSCALL(date)
 189:	b8 16 00 00 00       	mov    $0x16,%eax
 18e:	cd 40                	int    $0x40
 190:	c3                   	ret    

00000191 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	83 ec 1c             	sub    $0x1c,%esp
 197:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 19a:	6a 01                	push   $0x1
 19c:	8d 55 f4             	lea    -0xc(%ebp),%edx
 19f:	52                   	push   %edx
 1a0:	50                   	push   %eax
 1a1:	e8 63 ff ff ff       	call   109 <write>
}
 1a6:	83 c4 10             	add    $0x10,%esp
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	57                   	push   %edi
 1af:	56                   	push   %esi
 1b0:	53                   	push   %ebx
 1b1:	83 ec 2c             	sub    $0x2c,%esp
 1b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1b7:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1bd:	74 04                	je     1c3 <printint+0x18>
 1bf:	85 d2                	test   %edx,%edx
 1c1:	78 3a                	js     1fd <printint+0x52>
  neg = 0;
 1c3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1cf:	89 f0                	mov    %esi,%eax
 1d1:	ba 00 00 00 00       	mov    $0x0,%edx
 1d6:	f7 f1                	div    %ecx
 1d8:	89 df                	mov    %ebx,%edi
 1da:	43                   	inc    %ebx
 1db:	8a 92 d4 03 00 00    	mov    0x3d4(%edx),%dl
 1e1:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1e5:	89 f2                	mov    %esi,%edx
 1e7:	89 c6                	mov    %eax,%esi
 1e9:	39 d1                	cmp    %edx,%ecx
 1eb:	76 e2                	jbe    1cf <printint+0x24>
  if(neg)
 1ed:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1f1:	74 22                	je     215 <printint+0x6a>
    buf[i++] = '-';
 1f3:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1f8:	8d 5f 02             	lea    0x2(%edi),%ebx
 1fb:	eb 18                	jmp    215 <printint+0x6a>
    x = -xx;
 1fd:	f7 de                	neg    %esi
    neg = 1;
 1ff:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 206:	eb c2                	jmp    1ca <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 208:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 20d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 210:	e8 7c ff ff ff       	call   191 <putc>
  while(--i >= 0)
 215:	4b                   	dec    %ebx
 216:	79 f0                	jns    208 <printint+0x5d>
}
 218:	83 c4 2c             	add    $0x2c,%esp
 21b:	5b                   	pop    %ebx
 21c:	5e                   	pop    %esi
 21d:	5f                   	pop    %edi
 21e:	5d                   	pop    %ebp
 21f:	c3                   	ret    

00000220 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 220:	f3 0f 1e fb          	endbr32 
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	57                   	push   %edi
 228:	56                   	push   %esi
 229:	53                   	push   %ebx
 22a:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 22d:	8d 45 10             	lea    0x10(%ebp),%eax
 230:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 233:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 238:	bb 00 00 00 00       	mov    $0x0,%ebx
 23d:	eb 12                	jmp    251 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 23f:	89 fa                	mov    %edi,%edx
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	e8 48 ff ff ff       	call   191 <putc>
 249:	eb 05                	jmp    250 <printf+0x30>
      }
    } else if(state == '%'){
 24b:	83 fe 25             	cmp    $0x25,%esi
 24e:	74 22                	je     272 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 250:	43                   	inc    %ebx
 251:	8b 45 0c             	mov    0xc(%ebp),%eax
 254:	8a 04 18             	mov    (%eax,%ebx,1),%al
 257:	84 c0                	test   %al,%al
 259:	0f 84 13 01 00 00    	je     372 <printf+0x152>
    c = fmt[i] & 0xff;
 25f:	0f be f8             	movsbl %al,%edi
 262:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 265:	85 f6                	test   %esi,%esi
 267:	75 e2                	jne    24b <printf+0x2b>
      if(c == '%'){
 269:	83 f8 25             	cmp    $0x25,%eax
 26c:	75 d1                	jne    23f <printf+0x1f>
        state = '%';
 26e:	89 c6                	mov    %eax,%esi
 270:	eb de                	jmp    250 <printf+0x30>
      if(c == 'd'){
 272:	83 f8 64             	cmp    $0x64,%eax
 275:	74 43                	je     2ba <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 277:	83 f8 78             	cmp    $0x78,%eax
 27a:	74 68                	je     2e4 <printf+0xc4>
 27c:	83 f8 70             	cmp    $0x70,%eax
 27f:	74 63                	je     2e4 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 281:	83 f8 73             	cmp    $0x73,%eax
 284:	0f 84 84 00 00 00    	je     30e <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 28a:	83 f8 63             	cmp    $0x63,%eax
 28d:	0f 84 ad 00 00 00    	je     340 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 293:	83 f8 25             	cmp    $0x25,%eax
 296:	0f 84 c2 00 00 00    	je     35e <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 29c:	ba 25 00 00 00       	mov    $0x25,%edx
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	e8 e8 fe ff ff       	call   191 <putc>
        putc(fd, c);
 2a9:	89 fa                	mov    %edi,%edx
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	e8 de fe ff ff       	call   191 <putc>
      }
      state = 0;
 2b3:	be 00 00 00 00       	mov    $0x0,%esi
 2b8:	eb 96                	jmp    250 <printf+0x30>
        printint(fd, *ap, 10, 1);
 2ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2bd:	8b 17                	mov    (%edi),%edx
 2bf:	83 ec 0c             	sub    $0xc,%esp
 2c2:	6a 01                	push   $0x1
 2c4:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	e8 da fe ff ff       	call   1ab <printint>
        ap++;
 2d1:	83 c7 04             	add    $0x4,%edi
 2d4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2d7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2da:	be 00 00 00 00       	mov    $0x0,%esi
 2df:	e9 6c ff ff ff       	jmp    250 <printf+0x30>
        printint(fd, *ap, 16, 0);
 2e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2e7:	8b 17                	mov    (%edi),%edx
 2e9:	83 ec 0c             	sub    $0xc,%esp
 2ec:	6a 00                	push   $0x0
 2ee:	b9 10 00 00 00       	mov    $0x10,%ecx
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	e8 b0 fe ff ff       	call   1ab <printint>
        ap++;
 2fb:	83 c7 04             	add    $0x4,%edi
 2fe:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 301:	83 c4 10             	add    $0x10,%esp
      state = 0;
 304:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 309:	e9 42 ff ff ff       	jmp    250 <printf+0x30>
        s = (char*)*ap;
 30e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 311:	8b 30                	mov    (%eax),%esi
        ap++;
 313:	83 c0 04             	add    $0x4,%eax
 316:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 319:	85 f6                	test   %esi,%esi
 31b:	75 13                	jne    330 <printf+0x110>
          s = "(null)";
 31d:	be cc 03 00 00       	mov    $0x3cc,%esi
 322:	eb 0c                	jmp    330 <printf+0x110>
          putc(fd, *s);
 324:	0f be d2             	movsbl %dl,%edx
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	e8 62 fe ff ff       	call   191 <putc>
          s++;
 32f:	46                   	inc    %esi
        while(*s != 0){
 330:	8a 16                	mov    (%esi),%dl
 332:	84 d2                	test   %dl,%dl
 334:	75 ee                	jne    324 <printf+0x104>
      state = 0;
 336:	be 00 00 00 00       	mov    $0x0,%esi
 33b:	e9 10 ff ff ff       	jmp    250 <printf+0x30>
        putc(fd, *ap);
 340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 343:	0f be 17             	movsbl (%edi),%edx
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	e8 43 fe ff ff       	call   191 <putc>
        ap++;
 34e:	83 c7 04             	add    $0x4,%edi
 351:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 354:	be 00 00 00 00       	mov    $0x0,%esi
 359:	e9 f2 fe ff ff       	jmp    250 <printf+0x30>
        putc(fd, c);
 35e:	89 fa                	mov    %edi,%edx
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	e8 29 fe ff ff       	call   191 <putc>
      state = 0;
 368:	be 00 00 00 00       	mov    $0x0,%esi
 36d:	e9 de fe ff ff       	jmp    250 <printf+0x30>
    }
  }
}
 372:	8d 65 f4             	lea    -0xc(%ebp),%esp
 375:	5b                   	pop    %ebx
 376:	5e                   	pop    %esi
 377:	5f                   	pop    %edi
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    
