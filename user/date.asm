
date:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 30             	sub    $0x30,%esp
    struct rtcdate r;
    if (date(&r))
  15:	8d 45 e0             	lea    -0x20(%ebp),%eax
  18:	50                   	push   %eax
  19:	e8 e9 00 00 00       	call   107 <date>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	74 14                	je     39 <main+0x39>
    {
        printf(2, " date failed \n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 f8 02 00 00       	push   $0x2f8
  2d:	6a 02                	push   $0x2
  2f:	e8 6a 01 00 00       	call   19e <printf>
        exit();
  34:	e8 2e 00 00 00       	call   67 <exit>
    }
    printf(1,"%d/%d/%d %d:%d:%d\n",r.day,r.month,r.year,r.hour,r.minute,r.second);
  39:	ff 75 e0             	pushl  -0x20(%ebp)
  3c:	ff 75 e4             	pushl  -0x1c(%ebp)
  3f:	ff 75 e8             	pushl  -0x18(%ebp)
  42:	ff 75 f4             	pushl  -0xc(%ebp)
  45:	ff 75 f0             	pushl  -0x10(%ebp)
  48:	ff 75 ec             	pushl  -0x14(%ebp)
  4b:	68 07 03 00 00       	push   $0x307
  50:	6a 01                	push   $0x1
  52:	e8 47 01 00 00       	call   19e <printf>

    exit();
  57:	83 c4 20             	add    $0x20,%esp
  5a:	e8 08 00 00 00       	call   67 <exit>

0000005f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  5f:	b8 01 00 00 00       	mov    $0x1,%eax
  64:	cd 40                	int    $0x40
  66:	c3                   	ret    

00000067 <exit>:
SYSCALL(exit)
  67:	b8 02 00 00 00       	mov    $0x2,%eax
  6c:	cd 40                	int    $0x40
  6e:	c3                   	ret    

0000006f <wait>:
SYSCALL(wait)
  6f:	b8 03 00 00 00       	mov    $0x3,%eax
  74:	cd 40                	int    $0x40
  76:	c3                   	ret    

00000077 <pipe>:
SYSCALL(pipe)
  77:	b8 04 00 00 00       	mov    $0x4,%eax
  7c:	cd 40                	int    $0x40
  7e:	c3                   	ret    

0000007f <read>:
SYSCALL(read)
  7f:	b8 05 00 00 00       	mov    $0x5,%eax
  84:	cd 40                	int    $0x40
  86:	c3                   	ret    

00000087 <write>:
SYSCALL(write)
  87:	b8 10 00 00 00       	mov    $0x10,%eax
  8c:	cd 40                	int    $0x40
  8e:	c3                   	ret    

0000008f <close>:
SYSCALL(close)
  8f:	b8 15 00 00 00       	mov    $0x15,%eax
  94:	cd 40                	int    $0x40
  96:	c3                   	ret    

00000097 <kill>:
SYSCALL(kill)
  97:	b8 06 00 00 00       	mov    $0x6,%eax
  9c:	cd 40                	int    $0x40
  9e:	c3                   	ret    

0000009f <exec>:
SYSCALL(exec)
  9f:	b8 07 00 00 00       	mov    $0x7,%eax
  a4:	cd 40                	int    $0x40
  a6:	c3                   	ret    

000000a7 <open>:
SYSCALL(open)
  a7:	b8 0f 00 00 00       	mov    $0xf,%eax
  ac:	cd 40                	int    $0x40
  ae:	c3                   	ret    

000000af <mknod>:
SYSCALL(mknod)
  af:	b8 11 00 00 00       	mov    $0x11,%eax
  b4:	cd 40                	int    $0x40
  b6:	c3                   	ret    

000000b7 <unlink>:
SYSCALL(unlink)
  b7:	b8 12 00 00 00       	mov    $0x12,%eax
  bc:	cd 40                	int    $0x40
  be:	c3                   	ret    

000000bf <fstat>:
SYSCALL(fstat)
  bf:	b8 08 00 00 00       	mov    $0x8,%eax
  c4:	cd 40                	int    $0x40
  c6:	c3                   	ret    

000000c7 <link>:
SYSCALL(link)
  c7:	b8 13 00 00 00       	mov    $0x13,%eax
  cc:	cd 40                	int    $0x40
  ce:	c3                   	ret    

000000cf <mkdir>:
SYSCALL(mkdir)
  cf:	b8 14 00 00 00       	mov    $0x14,%eax
  d4:	cd 40                	int    $0x40
  d6:	c3                   	ret    

000000d7 <chdir>:
SYSCALL(chdir)
  d7:	b8 09 00 00 00       	mov    $0x9,%eax
  dc:	cd 40                	int    $0x40
  de:	c3                   	ret    

000000df <dup>:
SYSCALL(dup)
  df:	b8 0a 00 00 00       	mov    $0xa,%eax
  e4:	cd 40                	int    $0x40
  e6:	c3                   	ret    

000000e7 <getpid>:
SYSCALL(getpid)
  e7:	b8 0b 00 00 00       	mov    $0xb,%eax
  ec:	cd 40                	int    $0x40
  ee:	c3                   	ret    

000000ef <sbrk>:
SYSCALL(sbrk)
  ef:	b8 0c 00 00 00       	mov    $0xc,%eax
  f4:	cd 40                	int    $0x40
  f6:	c3                   	ret    

000000f7 <sleep>:
SYSCALL(sleep)
  f7:	b8 0d 00 00 00       	mov    $0xd,%eax
  fc:	cd 40                	int    $0x40
  fe:	c3                   	ret    

000000ff <uptime>:
SYSCALL(uptime)
  ff:	b8 0e 00 00 00       	mov    $0xe,%eax
 104:	cd 40                	int    $0x40
 106:	c3                   	ret    

00000107 <date>:
SYSCALL(date)
 107:	b8 16 00 00 00       	mov    $0x16,%eax
 10c:	cd 40                	int    $0x40
 10e:	c3                   	ret    

0000010f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	83 ec 1c             	sub    $0x1c,%esp
 115:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 118:	6a 01                	push   $0x1
 11a:	8d 55 f4             	lea    -0xc(%ebp),%edx
 11d:	52                   	push   %edx
 11e:	50                   	push   %eax
 11f:	e8 63 ff ff ff       	call   87 <write>
}
 124:	83 c4 10             	add    $0x10,%esp
 127:	c9                   	leave  
 128:	c3                   	ret    

00000129 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
 12c:	57                   	push   %edi
 12d:	56                   	push   %esi
 12e:	53                   	push   %ebx
 12f:	83 ec 2c             	sub    $0x2c,%esp
 132:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 135:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 137:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 13b:	74 04                	je     141 <printint+0x18>
 13d:	85 d2                	test   %edx,%edx
 13f:	78 3a                	js     17b <printint+0x52>
  neg = 0;
 141:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 148:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 14d:	89 f0                	mov    %esi,%eax
 14f:	ba 00 00 00 00       	mov    $0x0,%edx
 154:	f7 f1                	div    %ecx
 156:	89 df                	mov    %ebx,%edi
 158:	43                   	inc    %ebx
 159:	8a 92 24 03 00 00    	mov    0x324(%edx),%dl
 15f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 163:	89 f2                	mov    %esi,%edx
 165:	89 c6                	mov    %eax,%esi
 167:	39 d1                	cmp    %edx,%ecx
 169:	76 e2                	jbe    14d <printint+0x24>
  if(neg)
 16b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 16f:	74 22                	je     193 <printint+0x6a>
    buf[i++] = '-';
 171:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 176:	8d 5f 02             	lea    0x2(%edi),%ebx
 179:	eb 18                	jmp    193 <printint+0x6a>
    x = -xx;
 17b:	f7 de                	neg    %esi
    neg = 1;
 17d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 184:	eb c2                	jmp    148 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 186:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 18b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 18e:	e8 7c ff ff ff       	call   10f <putc>
  while(--i >= 0)
 193:	4b                   	dec    %ebx
 194:	79 f0                	jns    186 <printint+0x5d>
}
 196:	83 c4 2c             	add    $0x2c,%esp
 199:	5b                   	pop    %ebx
 19a:	5e                   	pop    %esi
 19b:	5f                   	pop    %edi
 19c:	5d                   	pop    %ebp
 19d:	c3                   	ret    

0000019e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 19e:	f3 0f 1e fb          	endbr32 
 1a2:	55                   	push   %ebp
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	57                   	push   %edi
 1a6:	56                   	push   %esi
 1a7:	53                   	push   %ebx
 1a8:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1ab:	8d 45 10             	lea    0x10(%ebp),%eax
 1ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1b1:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1b6:	bb 00 00 00 00       	mov    $0x0,%ebx
 1bb:	eb 12                	jmp    1cf <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1bd:	89 fa                	mov    %edi,%edx
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	e8 48 ff ff ff       	call   10f <putc>
 1c7:	eb 05                	jmp    1ce <printf+0x30>
      }
    } else if(state == '%'){
 1c9:	83 fe 25             	cmp    $0x25,%esi
 1cc:	74 22                	je     1f0 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1ce:	43                   	inc    %ebx
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1d5:	84 c0                	test   %al,%al
 1d7:	0f 84 13 01 00 00    	je     2f0 <printf+0x152>
    c = fmt[i] & 0xff;
 1dd:	0f be f8             	movsbl %al,%edi
 1e0:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1e3:	85 f6                	test   %esi,%esi
 1e5:	75 e2                	jne    1c9 <printf+0x2b>
      if(c == '%'){
 1e7:	83 f8 25             	cmp    $0x25,%eax
 1ea:	75 d1                	jne    1bd <printf+0x1f>
        state = '%';
 1ec:	89 c6                	mov    %eax,%esi
 1ee:	eb de                	jmp    1ce <printf+0x30>
      if(c == 'd'){
 1f0:	83 f8 64             	cmp    $0x64,%eax
 1f3:	74 43                	je     238 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 1f5:	83 f8 78             	cmp    $0x78,%eax
 1f8:	74 68                	je     262 <printf+0xc4>
 1fa:	83 f8 70             	cmp    $0x70,%eax
 1fd:	74 63                	je     262 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 1ff:	83 f8 73             	cmp    $0x73,%eax
 202:	0f 84 84 00 00 00    	je     28c <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 208:	83 f8 63             	cmp    $0x63,%eax
 20b:	0f 84 ad 00 00 00    	je     2be <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 211:	83 f8 25             	cmp    $0x25,%eax
 214:	0f 84 c2 00 00 00    	je     2dc <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 21a:	ba 25 00 00 00       	mov    $0x25,%edx
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	e8 e8 fe ff ff       	call   10f <putc>
        putc(fd, c);
 227:	89 fa                	mov    %edi,%edx
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	e8 de fe ff ff       	call   10f <putc>
      }
      state = 0;
 231:	be 00 00 00 00       	mov    $0x0,%esi
 236:	eb 96                	jmp    1ce <printf+0x30>
        printint(fd, *ap, 10, 1);
 238:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 23b:	8b 17                	mov    (%edi),%edx
 23d:	83 ec 0c             	sub    $0xc,%esp
 240:	6a 01                	push   $0x1
 242:	b9 0a 00 00 00       	mov    $0xa,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	e8 da fe ff ff       	call   129 <printint>
        ap++;
 24f:	83 c7 04             	add    $0x4,%edi
 252:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 255:	83 c4 10             	add    $0x10,%esp
      state = 0;
 258:	be 00 00 00 00       	mov    $0x0,%esi
 25d:	e9 6c ff ff ff       	jmp    1ce <printf+0x30>
        printint(fd, *ap, 16, 0);
 262:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 265:	8b 17                	mov    (%edi),%edx
 267:	83 ec 0c             	sub    $0xc,%esp
 26a:	6a 00                	push   $0x0
 26c:	b9 10 00 00 00       	mov    $0x10,%ecx
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	e8 b0 fe ff ff       	call   129 <printint>
        ap++;
 279:	83 c7 04             	add    $0x4,%edi
 27c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 27f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 282:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 287:	e9 42 ff ff ff       	jmp    1ce <printf+0x30>
        s = (char*)*ap;
 28c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 28f:	8b 30                	mov    (%eax),%esi
        ap++;
 291:	83 c0 04             	add    $0x4,%eax
 294:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 297:	85 f6                	test   %esi,%esi
 299:	75 13                	jne    2ae <printf+0x110>
          s = "(null)";
 29b:	be 1a 03 00 00       	mov    $0x31a,%esi
 2a0:	eb 0c                	jmp    2ae <printf+0x110>
          putc(fd, *s);
 2a2:	0f be d2             	movsbl %dl,%edx
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	e8 62 fe ff ff       	call   10f <putc>
          s++;
 2ad:	46                   	inc    %esi
        while(*s != 0){
 2ae:	8a 16                	mov    (%esi),%dl
 2b0:	84 d2                	test   %dl,%dl
 2b2:	75 ee                	jne    2a2 <printf+0x104>
      state = 0;
 2b4:	be 00 00 00 00       	mov    $0x0,%esi
 2b9:	e9 10 ff ff ff       	jmp    1ce <printf+0x30>
        putc(fd, *ap);
 2be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2c1:	0f be 17             	movsbl (%edi),%edx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	e8 43 fe ff ff       	call   10f <putc>
        ap++;
 2cc:	83 c7 04             	add    $0x4,%edi
 2cf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2d2:	be 00 00 00 00       	mov    $0x0,%esi
 2d7:	e9 f2 fe ff ff       	jmp    1ce <printf+0x30>
        putc(fd, c);
 2dc:	89 fa                	mov    %edi,%edx
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	e8 29 fe ff ff       	call   10f <putc>
      state = 0;
 2e6:	be 00 00 00 00       	mov    $0x0,%esi
 2eb:	e9 de fe ff ff       	jmp    1ce <printf+0x30>
    }
  }
}
 2f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2f3:	5b                   	pop    %ebx
 2f4:	5e                   	pop    %esi
 2f5:	5f                   	pop    %edi
 2f6:	5d                   	pop    %ebp
 2f7:	c3                   	ret    
