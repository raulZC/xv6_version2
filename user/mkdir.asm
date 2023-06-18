
mkdir:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 18             	sub    $0x18,%esp
  18:	8b 01                	mov    (%ecx),%eax
  1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1d:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  20:	83 f8 01             	cmp    $0x1,%eax
  23:	7e 21                	jle    46 <main+0x46>
    printf(2, "Usage: mkdir files...\n");
    exit(0);
  }

  for(i = 1; i < argc; i++){
  25:	bb 01 00 00 00       	mov    $0x1,%ebx
  2a:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  2d:	7d 46                	jge    75 <main+0x75>
    if(mkdir(argv[i]) < 0){
  2f:	8d 34 9f             	lea    (%edi,%ebx,4),%esi
  32:	83 ec 0c             	sub    $0xc,%esp
  35:	ff 36                	pushl  (%esi)
  37:	e8 b3 00 00 00       	call   ef <mkdir>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	85 c0                	test   %eax,%eax
  41:	78 1e                	js     61 <main+0x61>
  for(i = 1; i < argc; i++){
  43:	43                   	inc    %ebx
  44:	eb e4                	jmp    2a <main+0x2a>
    printf(2, "Usage: mkdir files...\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 20 03 00 00       	push   $0x320
  4e:	6a 02                	push   $0x2
  50:	e8 71 01 00 00       	call   1c6 <printf>
    exit(0);
  55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  5c:	e8 26 00 00 00       	call   87 <exit>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  61:	83 ec 04             	sub    $0x4,%esp
  64:	ff 36                	pushl  (%esi)
  66:	68 37 03 00 00       	push   $0x337
  6b:	6a 02                	push   $0x2
  6d:	e8 54 01 00 00       	call   1c6 <printf>
      break;
  72:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit(0);
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	6a 00                	push   $0x0
  7a:	e8 08 00 00 00       	call   87 <exit>

0000007f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  7f:	b8 01 00 00 00       	mov    $0x1,%eax
  84:	cd 40                	int    $0x40
  86:	c3                   	ret    

00000087 <exit>:
SYSCALL(exit)
  87:	b8 02 00 00 00       	mov    $0x2,%eax
  8c:	cd 40                	int    $0x40
  8e:	c3                   	ret    

0000008f <wait>:
SYSCALL(wait)
  8f:	b8 03 00 00 00       	mov    $0x3,%eax
  94:	cd 40                	int    $0x40
  96:	c3                   	ret    

00000097 <pipe>:
SYSCALL(pipe)
  97:	b8 04 00 00 00       	mov    $0x4,%eax
  9c:	cd 40                	int    $0x40
  9e:	c3                   	ret    

0000009f <read>:
SYSCALL(read)
  9f:	b8 05 00 00 00       	mov    $0x5,%eax
  a4:	cd 40                	int    $0x40
  a6:	c3                   	ret    

000000a7 <write>:
SYSCALL(write)
  a7:	b8 10 00 00 00       	mov    $0x10,%eax
  ac:	cd 40                	int    $0x40
  ae:	c3                   	ret    

000000af <close>:
SYSCALL(close)
  af:	b8 15 00 00 00       	mov    $0x15,%eax
  b4:	cd 40                	int    $0x40
  b6:	c3                   	ret    

000000b7 <kill>:
SYSCALL(kill)
  b7:	b8 06 00 00 00       	mov    $0x6,%eax
  bc:	cd 40                	int    $0x40
  be:	c3                   	ret    

000000bf <exec>:
SYSCALL(exec)
  bf:	b8 07 00 00 00       	mov    $0x7,%eax
  c4:	cd 40                	int    $0x40
  c6:	c3                   	ret    

000000c7 <open>:
SYSCALL(open)
  c7:	b8 0f 00 00 00       	mov    $0xf,%eax
  cc:	cd 40                	int    $0x40
  ce:	c3                   	ret    

000000cf <mknod>:
SYSCALL(mknod)
  cf:	b8 11 00 00 00       	mov    $0x11,%eax
  d4:	cd 40                	int    $0x40
  d6:	c3                   	ret    

000000d7 <unlink>:
SYSCALL(unlink)
  d7:	b8 12 00 00 00       	mov    $0x12,%eax
  dc:	cd 40                	int    $0x40
  de:	c3                   	ret    

000000df <fstat>:
SYSCALL(fstat)
  df:	b8 08 00 00 00       	mov    $0x8,%eax
  e4:	cd 40                	int    $0x40
  e6:	c3                   	ret    

000000e7 <link>:
SYSCALL(link)
  e7:	b8 13 00 00 00       	mov    $0x13,%eax
  ec:	cd 40                	int    $0x40
  ee:	c3                   	ret    

000000ef <mkdir>:
SYSCALL(mkdir)
  ef:	b8 14 00 00 00       	mov    $0x14,%eax
  f4:	cd 40                	int    $0x40
  f6:	c3                   	ret    

000000f7 <chdir>:
SYSCALL(chdir)
  f7:	b8 09 00 00 00       	mov    $0x9,%eax
  fc:	cd 40                	int    $0x40
  fe:	c3                   	ret    

000000ff <dup>:
SYSCALL(dup)
  ff:	b8 0a 00 00 00       	mov    $0xa,%eax
 104:	cd 40                	int    $0x40
 106:	c3                   	ret    

00000107 <getpid>:
SYSCALL(getpid)
 107:	b8 0b 00 00 00       	mov    $0xb,%eax
 10c:	cd 40                	int    $0x40
 10e:	c3                   	ret    

0000010f <sbrk>:
SYSCALL(sbrk)
 10f:	b8 0c 00 00 00       	mov    $0xc,%eax
 114:	cd 40                	int    $0x40
 116:	c3                   	ret    

00000117 <sleep>:
SYSCALL(sleep)
 117:	b8 0d 00 00 00       	mov    $0xd,%eax
 11c:	cd 40                	int    $0x40
 11e:	c3                   	ret    

0000011f <uptime>:
SYSCALL(uptime)
 11f:	b8 0e 00 00 00       	mov    $0xe,%eax
 124:	cd 40                	int    $0x40
 126:	c3                   	ret    

00000127 <date>:
SYSCALL(date)
 127:	b8 16 00 00 00       	mov    $0x16,%eax
 12c:	cd 40                	int    $0x40
 12e:	c3                   	ret    

0000012f <dup2>:
 12f:	b8 17 00 00 00       	mov    $0x17,%eax
 134:	cd 40                	int    $0x40
 136:	c3                   	ret    

00000137 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	83 ec 1c             	sub    $0x1c,%esp
 13d:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 140:	6a 01                	push   $0x1
 142:	8d 55 f4             	lea    -0xc(%ebp),%edx
 145:	52                   	push   %edx
 146:	50                   	push   %eax
 147:	e8 5b ff ff ff       	call   a7 <write>
}
 14c:	83 c4 10             	add    $0x10,%esp
 14f:	c9                   	leave  
 150:	c3                   	ret    

00000151 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	57                   	push   %edi
 155:	56                   	push   %esi
 156:	53                   	push   %ebx
 157:	83 ec 2c             	sub    $0x2c,%esp
 15a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 15d:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 15f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 163:	74 04                	je     169 <printint+0x18>
 165:	85 d2                	test   %edx,%edx
 167:	78 3a                	js     1a3 <printint+0x52>
  neg = 0;
 169:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 170:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 175:	89 f0                	mov    %esi,%eax
 177:	ba 00 00 00 00       	mov    $0x0,%edx
 17c:	f7 f1                	div    %ecx
 17e:	89 df                	mov    %ebx,%edi
 180:	43                   	inc    %ebx
 181:	8a 92 5c 03 00 00    	mov    0x35c(%edx),%dl
 187:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 18b:	89 f2                	mov    %esi,%edx
 18d:	89 c6                	mov    %eax,%esi
 18f:	39 d1                	cmp    %edx,%ecx
 191:	76 e2                	jbe    175 <printint+0x24>
  if(neg)
 193:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 197:	74 22                	je     1bb <printint+0x6a>
    buf[i++] = '-';
 199:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 19e:	8d 5f 02             	lea    0x2(%edi),%ebx
 1a1:	eb 18                	jmp    1bb <printint+0x6a>
    x = -xx;
 1a3:	f7 de                	neg    %esi
    neg = 1;
 1a5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1ac:	eb c2                	jmp    170 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 1ae:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1b6:	e8 7c ff ff ff       	call   137 <putc>
  while(--i >= 0)
 1bb:	4b                   	dec    %ebx
 1bc:	79 f0                	jns    1ae <printint+0x5d>
}
 1be:	83 c4 2c             	add    $0x2c,%esp
 1c1:	5b                   	pop    %ebx
 1c2:	5e                   	pop    %esi
 1c3:	5f                   	pop    %edi
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    

000001c6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1c6:	f3 0f 1e fb          	endbr32 
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	57                   	push   %edi
 1ce:	56                   	push   %esi
 1cf:	53                   	push   %ebx
 1d0:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1d3:	8d 45 10             	lea    0x10(%ebp),%eax
 1d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1d9:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1de:	bb 00 00 00 00       	mov    $0x0,%ebx
 1e3:	eb 12                	jmp    1f7 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1e5:	89 fa                	mov    %edi,%edx
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	e8 48 ff ff ff       	call   137 <putc>
 1ef:	eb 05                	jmp    1f6 <printf+0x30>
      }
    } else if(state == '%'){
 1f1:	83 fe 25             	cmp    $0x25,%esi
 1f4:	74 22                	je     218 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1f6:	43                   	inc    %ebx
 1f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fa:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1fd:	84 c0                	test   %al,%al
 1ff:	0f 84 13 01 00 00    	je     318 <printf+0x152>
    c = fmt[i] & 0xff;
 205:	0f be f8             	movsbl %al,%edi
 208:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 20b:	85 f6                	test   %esi,%esi
 20d:	75 e2                	jne    1f1 <printf+0x2b>
      if(c == '%'){
 20f:	83 f8 25             	cmp    $0x25,%eax
 212:	75 d1                	jne    1e5 <printf+0x1f>
        state = '%';
 214:	89 c6                	mov    %eax,%esi
 216:	eb de                	jmp    1f6 <printf+0x30>
      if(c == 'd'){
 218:	83 f8 64             	cmp    $0x64,%eax
 21b:	74 43                	je     260 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 21d:	83 f8 78             	cmp    $0x78,%eax
 220:	74 68                	je     28a <printf+0xc4>
 222:	83 f8 70             	cmp    $0x70,%eax
 225:	74 63                	je     28a <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 227:	83 f8 73             	cmp    $0x73,%eax
 22a:	0f 84 84 00 00 00    	je     2b4 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 230:	83 f8 63             	cmp    $0x63,%eax
 233:	0f 84 ad 00 00 00    	je     2e6 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 239:	83 f8 25             	cmp    $0x25,%eax
 23c:	0f 84 c2 00 00 00    	je     304 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 242:	ba 25 00 00 00       	mov    $0x25,%edx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	e8 e8 fe ff ff       	call   137 <putc>
        putc(fd, c);
 24f:	89 fa                	mov    %edi,%edx
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	e8 de fe ff ff       	call   137 <putc>
      }
      state = 0;
 259:	be 00 00 00 00       	mov    $0x0,%esi
 25e:	eb 96                	jmp    1f6 <printf+0x30>
        printint(fd, *ap, 10, 1);
 260:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 263:	8b 17                	mov    (%edi),%edx
 265:	83 ec 0c             	sub    $0xc,%esp
 268:	6a 01                	push   $0x1
 26a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	e8 da fe ff ff       	call   151 <printint>
        ap++;
 277:	83 c7 04             	add    $0x4,%edi
 27a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 27d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 280:	be 00 00 00 00       	mov    $0x0,%esi
 285:	e9 6c ff ff ff       	jmp    1f6 <printf+0x30>
        printint(fd, *ap, 16, 0);
 28a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 28d:	8b 17                	mov    (%edi),%edx
 28f:	83 ec 0c             	sub    $0xc,%esp
 292:	6a 00                	push   $0x0
 294:	b9 10 00 00 00       	mov    $0x10,%ecx
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	e8 b0 fe ff ff       	call   151 <printint>
        ap++;
 2a1:	83 c7 04             	add    $0x4,%edi
 2a4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2a7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2aa:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2af:	e9 42 ff ff ff       	jmp    1f6 <printf+0x30>
        s = (char*)*ap;
 2b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2b7:	8b 30                	mov    (%eax),%esi
        ap++;
 2b9:	83 c0 04             	add    $0x4,%eax
 2bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2bf:	85 f6                	test   %esi,%esi
 2c1:	75 13                	jne    2d6 <printf+0x110>
          s = "(null)";
 2c3:	be 53 03 00 00       	mov    $0x353,%esi
 2c8:	eb 0c                	jmp    2d6 <printf+0x110>
          putc(fd, *s);
 2ca:	0f be d2             	movsbl %dl,%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	e8 62 fe ff ff       	call   137 <putc>
          s++;
 2d5:	46                   	inc    %esi
        while(*s != 0){
 2d6:	8a 16                	mov    (%esi),%dl
 2d8:	84 d2                	test   %dl,%dl
 2da:	75 ee                	jne    2ca <printf+0x104>
      state = 0;
 2dc:	be 00 00 00 00       	mov    $0x0,%esi
 2e1:	e9 10 ff ff ff       	jmp    1f6 <printf+0x30>
        putc(fd, *ap);
 2e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2e9:	0f be 17             	movsbl (%edi),%edx
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	e8 43 fe ff ff       	call   137 <putc>
        ap++;
 2f4:	83 c7 04             	add    $0x4,%edi
 2f7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2fa:	be 00 00 00 00       	mov    $0x0,%esi
 2ff:	e9 f2 fe ff ff       	jmp    1f6 <printf+0x30>
        putc(fd, c);
 304:	89 fa                	mov    %edi,%edx
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	e8 29 fe ff ff       	call   137 <putc>
      state = 0;
 30e:	be 00 00 00 00       	mov    $0x0,%esi
 313:	e9 de fe ff ff       	jmp    1f6 <printf+0x30>
    }
  }
}
 318:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31b:	5b                   	pop    %ebx
 31c:	5e                   	pop    %esi
 31d:	5f                   	pop    %edi
 31e:	5d                   	pop    %ebp
 31f:	c3                   	ret    
