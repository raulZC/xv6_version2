
kernel:     formato del fichero elf32-i386


Desensamblado de la sección .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a9 2a 10 80       	mov    $0x80102aa9,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 c0 b5 10 80       	push   $0x8010b5c0
80100046:	e8 c4 3d 00 00       	call   80103e0f <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010005f:	74 2e                	je     8010008f <bget+0x5b>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	40                   	inc    %eax
8010006f:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100072:	83 ec 0c             	sub    $0xc,%esp
80100075:	68 c0 b5 10 80       	push   $0x8010b5c0
8010007a:	e8 f9 3d 00 00       	call   80103e78 <release>
      acquiresleep(&b->lock);
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 56 3b 00 00       	call   80103be0 <acquiresleep>
      return b;
8010008a:	83 c4 10             	add    $0x10,%esp
8010008d:	eb 4c                	jmp    801000db <bget+0xa7>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010008f:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100095:	eb 03                	jmp    8010009a <bget+0x66>
80100097:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009a:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000a0:	74 43                	je     801000e5 <bget+0xb1>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a2:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a6:	75 ef                	jne    80100097 <bget+0x63>
801000a8:	f6 03 04             	testb  $0x4,(%ebx)
801000ab:	75 ea                	jne    80100097 <bget+0x63>
      b->dev = dev;
801000ad:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b0:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000b9:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c0:	83 ec 0c             	sub    $0xc,%esp
801000c3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000c8:	e8 ab 3d 00 00       	call   80103e78 <release>
      acquiresleep(&b->lock);
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 08 3b 00 00       	call   80103be0 <acquiresleep>
      return b;
801000d8:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000db:	89 d8                	mov    %ebx,%eax
801000dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e0:	5b                   	pop    %ebx
801000e1:	5e                   	pop    %esi
801000e2:	5f                   	pop    %edi
801000e3:	5d                   	pop    %ebp
801000e4:	c3                   	ret    
  panic("bget: no buffers");
801000e5:	83 ec 0c             	sub    $0xc,%esp
801000e8:	68 a0 6a 10 80       	push   $0x80106aa0
801000ed:	e8 63 02 00 00       	call   80100355 <panic>

801000f2 <binit>:
{
801000f2:	f3 0f 1e fb          	endbr32 
801000f6:	55                   	push   %ebp
801000f7:	89 e5                	mov    %esp,%ebp
801000f9:	53                   	push   %ebx
801000fa:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000fd:	68 b1 6a 10 80       	push   $0x80106ab1
80100102:	68 c0 b5 10 80       	push   $0x8010b5c0
80100107:	e8 b8 3b 00 00       	call   80103cc4 <initlock>
  bcache.head.prev = &bcache.head;
8010010c:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100113:	fc 10 80 
  bcache.head.next = &bcache.head;
80100116:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010011d:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100120:	83 c4 10             	add    $0x10,%esp
80100123:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
80100128:	eb 37                	jmp    80100161 <binit+0x6f>
    b->next = bcache.head.next;
8010012a:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010012f:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100132:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100139:	83 ec 08             	sub    $0x8,%esp
8010013c:	68 b8 6a 10 80       	push   $0x80106ab8
80100141:	8d 43 0c             	lea    0xc(%ebx),%eax
80100144:	50                   	push   %eax
80100145:	e8 5f 3a 00 00       	call   80103ba9 <initsleeplock>
    bcache.head.next->prev = b;
8010014a:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010014f:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100152:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100158:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015e:	83 c4 10             	add    $0x10,%esp
80100161:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100167:	72 c1                	jb     8010012a <binit+0x38>
}
80100169:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016c:	c9                   	leave  
8010016d:	c3                   	ret    

8010016e <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016e:	f3 0f 1e fb          	endbr32 
80100172:	55                   	push   %ebp
80100173:	89 e5                	mov    %esp,%ebp
80100175:	53                   	push   %ebx
80100176:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100179:	8b 55 0c             	mov    0xc(%ebp),%edx
8010017c:	8b 45 08             	mov    0x8(%ebp),%eax
8010017f:	e8 b0 fe ff ff       	call   80100034 <bget>
80100184:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100186:	f6 00 02             	testb  $0x2,(%eax)
80100189:	74 07                	je     80100192 <bread+0x24>
    iderw(b);
  }
  return b;
}
8010018b:	89 d8                	mov    %ebx,%eax
8010018d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100190:	c9                   	leave  
80100191:	c3                   	ret    
    iderw(b);
80100192:	83 ec 0c             	sub    $0xc,%esp
80100195:	50                   	push   %eax
80100196:	e8 aa 1c 00 00       	call   80101e45 <iderw>
8010019b:	83 c4 10             	add    $0x10,%esp
  return b;
8010019e:	eb eb                	jmp    8010018b <bread+0x1d>

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	f3 0f 1e fb          	endbr32 
801001a4:	55                   	push   %ebp
801001a5:	89 e5                	mov    %esp,%ebp
801001a7:	53                   	push   %ebx
801001a8:	83 ec 10             	sub    $0x10,%esp
801001ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801001b1:	50                   	push   %eax
801001b2:	e8 bb 3a 00 00       	call   80103c72 <holdingsleep>
801001b7:	83 c4 10             	add    $0x10,%esp
801001ba:	85 c0                	test   %eax,%eax
801001bc:	74 14                	je     801001d2 <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001be:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001c1:	83 ec 0c             	sub    $0xc,%esp
801001c4:	53                   	push   %ebx
801001c5:	e8 7b 1c 00 00       	call   80101e45 <iderw>
}
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d0:	c9                   	leave  
801001d1:	c3                   	ret    
    panic("bwrite");
801001d2:	83 ec 0c             	sub    $0xc,%esp
801001d5:	68 bf 6a 10 80       	push   $0x80106abf
801001da:	e8 76 01 00 00       	call   80100355 <panic>

801001df <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001df:	f3 0f 1e fb          	endbr32 
801001e3:	55                   	push   %ebp
801001e4:	89 e5                	mov    %esp,%ebp
801001e6:	56                   	push   %esi
801001e7:	53                   	push   %ebx
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	83 ec 0c             	sub    $0xc,%esp
801001f1:	56                   	push   %esi
801001f2:	e8 7b 3a 00 00       	call   80103c72 <holdingsleep>
801001f7:	83 c4 10             	add    $0x10,%esp
801001fa:	85 c0                	test   %eax,%eax
801001fc:	74 69                	je     80100267 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
801001fe:	83 ec 0c             	sub    $0xc,%esp
80100201:	56                   	push   %esi
80100202:	e8 2c 3a 00 00       	call   80103c33 <releasesleep>

  acquire(&bcache.lock);
80100207:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020e:	e8 fc 3b 00 00       	call   80103e0f <acquire>
  b->refcnt--;
80100213:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100216:	48                   	dec    %eax
80100217:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021a:	83 c4 10             	add    $0x10,%esp
8010021d:	85 c0                	test   %eax,%eax
8010021f:	75 2f                	jne    80100250 <brelse+0x71>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100221:	8b 43 54             	mov    0x54(%ebx),%eax
80100224:	8b 53 50             	mov    0x50(%ebx),%edx
80100227:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010022a:	8b 43 50             	mov    0x50(%ebx),%eax
8010022d:	8b 53 54             	mov    0x54(%ebx),%edx
80100230:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100233:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100238:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010023b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    bcache.head.next->prev = b;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100247:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010024a:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100250:	83 ec 0c             	sub    $0xc,%esp
80100253:	68 c0 b5 10 80       	push   $0x8010b5c0
80100258:	e8 1b 3c 00 00       	call   80103e78 <release>
}
8010025d:	83 c4 10             	add    $0x10,%esp
80100260:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100263:	5b                   	pop    %ebx
80100264:	5e                   	pop    %esi
80100265:	5d                   	pop    %ebp
80100266:	c3                   	ret    
    panic("brelse");
80100267:	83 ec 0c             	sub    $0xc,%esp
8010026a:	68 c6 6a 10 80       	push   $0x80106ac6
8010026f:	e8 e1 00 00 00       	call   80100355 <panic>

80100274 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100274:	f3 0f 1e fb          	endbr32 
80100278:	55                   	push   %ebp
80100279:	89 e5                	mov    %esp,%ebp
8010027b:	57                   	push   %edi
8010027c:	56                   	push   %esi
8010027d:	53                   	push   %ebx
8010027e:	83 ec 28             	sub    $0x28,%esp
80100281:	8b 7d 08             	mov    0x8(%ebp),%edi
80100284:	8b 75 0c             	mov    0xc(%ebp),%esi
80100287:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010028a:	57                   	push   %edi
8010028b:	e8 ca 13 00 00       	call   8010165a <iunlock>
  target = n;
80100290:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100293:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029a:	e8 70 3b 00 00       	call   80103e0f <acquire>
  while(n > 0){
8010029f:	83 c4 10             	add    $0x10,%esp
801002a2:	85 db                	test   %ebx,%ebx
801002a4:	0f 8e 8c 00 00 00    	jle    80100336 <consoleread+0xc2>
    while(input.r == input.w){
801002aa:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002af:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002b5:	75 47                	jne    801002fe <consoleread+0x8a>
      if(myproc()->killed){
801002b7:	e8 b9 2f 00 00       	call   80103275 <myproc>
801002bc:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002c0:	75 17                	jne    801002d9 <consoleread+0x65>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c2:	83 ec 08             	sub    $0x8,%esp
801002c5:	68 20 a5 10 80       	push   $0x8010a520
801002ca:	68 a0 ff 10 80       	push   $0x8010ffa0
801002cf:	e8 26 35 00 00       	call   801037fa <sleep>
801002d4:	83 c4 10             	add    $0x10,%esp
801002d7:	eb d1                	jmp    801002aa <consoleread+0x36>
        release(&cons.lock);
801002d9:	83 ec 0c             	sub    $0xc,%esp
801002dc:	68 20 a5 10 80       	push   $0x8010a520
801002e1:	e8 92 3b 00 00       	call   80103e78 <release>
        ilock(ip);
801002e6:	89 3c 24             	mov    %edi,(%esp)
801002e9:	e8 a8 12 00 00       	call   80101596 <ilock>
        return -1;
801002ee:	83 c4 10             	add    $0x10,%esp
801002f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002f9:	5b                   	pop    %ebx
801002fa:	5e                   	pop    %esi
801002fb:	5f                   	pop    %edi
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002fe:	8d 50 01             	lea    0x1(%eax),%edx
80100301:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100307:	89 c2                	mov    %eax,%edx
80100309:	83 e2 7f             	and    $0x7f,%edx
8010030c:	8a 92 20 ff 10 80    	mov    -0x7fef00e0(%edx),%dl
80100312:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
80100315:	80 fa 04             	cmp    $0x4,%dl
80100318:	74 12                	je     8010032c <consoleread+0xb8>
    *dst++ = c;
8010031a:	8d 46 01             	lea    0x1(%esi),%eax
8010031d:	88 16                	mov    %dl,(%esi)
    --n;
8010031f:	4b                   	dec    %ebx
    if(c == '\n')
80100320:	83 f9 0a             	cmp    $0xa,%ecx
80100323:	74 11                	je     80100336 <consoleread+0xc2>
    *dst++ = c;
80100325:	89 c6                	mov    %eax,%esi
80100327:	e9 76 ff ff ff       	jmp    801002a2 <consoleread+0x2e>
      if(n < target){
8010032c:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010032f:	73 05                	jae    80100336 <consoleread+0xc2>
        input.r--;
80100331:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
  release(&cons.lock);
80100336:	83 ec 0c             	sub    $0xc,%esp
80100339:	68 20 a5 10 80       	push   $0x8010a520
8010033e:	e8 35 3b 00 00       	call   80103e78 <release>
  ilock(ip);
80100343:	89 3c 24             	mov    %edi,(%esp)
80100346:	e8 4b 12 00 00       	call   80101596 <ilock>
  return target - n;
8010034b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010034e:	29 d8                	sub    %ebx,%eax
80100350:	83 c4 10             	add    $0x10,%esp
80100353:	eb a1                	jmp    801002f6 <consoleread+0x82>

80100355 <panic>:
{
80100355:	f3 0f 1e fb          	endbr32 
80100359:	55                   	push   %ebp
8010035a:	89 e5                	mov    %esp,%ebp
8010035c:	53                   	push   %ebx
8010035d:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100360:	fa                   	cli    
  cons.locking = 0;
80100361:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100368:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010036b:	e8 62 20 00 00       	call   801023d2 <lapicid>
80100370:	83 ec 08             	sub    $0x8,%esp
80100373:	50                   	push   %eax
80100374:	68 cd 6a 10 80       	push   $0x80106acd
80100379:	e8 7f 02 00 00       	call   801005fd <cprintf>
  cprintf(s);
8010037e:	83 c4 04             	add    $0x4,%esp
80100381:	ff 75 08             	pushl  0x8(%ebp)
80100384:	e8 74 02 00 00       	call   801005fd <cprintf>
  cprintf("\n");
80100389:	c7 04 24 93 74 10 80 	movl   $0x80107493,(%esp)
80100390:	e8 68 02 00 00       	call   801005fd <cprintf>
  getcallerpcs(&s, pcs);
80100395:	83 c4 08             	add    $0x8,%esp
80100398:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010039b:	50                   	push   %eax
8010039c:	8d 45 08             	lea    0x8(%ebp),%eax
8010039f:	50                   	push   %eax
801003a0:	e8 3e 39 00 00       	call   80103ce3 <getcallerpcs>
  for(i=0; i<10; i++)
801003a5:	83 c4 10             	add    $0x10,%esp
801003a8:	bb 00 00 00 00       	mov    $0x0,%ebx
801003ad:	eb 15                	jmp    801003c4 <panic+0x6f>
    cprintf(" %p", pcs[i]);
801003af:	83 ec 08             	sub    $0x8,%esp
801003b2:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003b6:	68 e1 6a 10 80       	push   $0x80106ae1
801003bb:	e8 3d 02 00 00       	call   801005fd <cprintf>
  for(i=0; i<10; i++)
801003c0:	43                   	inc    %ebx
801003c1:	83 c4 10             	add    $0x10,%esp
801003c4:	83 fb 09             	cmp    $0x9,%ebx
801003c7:	7e e6                	jle    801003af <panic+0x5a>
  panicked = 1; // freeze other CPU
801003c9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d0:	00 00 00 
  for(;;)
801003d3:	eb fe                	jmp    801003d3 <panic+0x7e>

801003d5 <cgaputc>:
{
801003d5:	55                   	push   %ebp
801003d6:	89 e5                	mov    %esp,%ebp
801003d8:	57                   	push   %edi
801003d9:	56                   	push   %esi
801003da:	53                   	push   %ebx
801003db:	83 ec 0c             	sub    $0xc,%esp
801003de:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e0:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003e5:	b0 0e                	mov    $0xe,%al
801003e7:	89 fa                	mov    %edi,%edx
801003e9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003ea:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003ef:	89 da                	mov    %ebx,%edx
801003f1:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003f2:	0f b6 c8             	movzbl %al,%ecx
801003f5:	c1 e1 08             	shl    $0x8,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003f8:	b0 0f                	mov    $0xf,%al
801003fa:	89 fa                	mov    %edi,%edx
801003fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003fd:	89 da                	mov    %ebx,%edx
801003ff:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100400:	0f b6 c0             	movzbl %al,%eax
80100403:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100405:	83 fe 0a             	cmp    $0xa,%esi
80100408:	74 61                	je     8010046b <cgaputc+0x96>
  else if(c == BACKSPACE){
8010040a:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100410:	74 69                	je     8010047b <cgaputc+0xa6>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100412:	89 f0                	mov    %esi,%eax
80100414:	0f b6 f0             	movzbl %al,%esi
80100417:	8d 59 01             	lea    0x1(%ecx),%ebx
8010041a:	81 ce 00 07 00 00    	or     $0x700,%esi
80100420:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100427:	80 
  if(pos < 0 || pos > 25*80)
80100428:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010042e:	77 58                	ja     80100488 <cgaputc+0xb3>
  if((pos/80) >= 24){  // Scroll up.
80100430:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100436:	7f 5d                	jg     80100495 <cgaputc+0xc0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100438:	be d4 03 00 00       	mov    $0x3d4,%esi
8010043d:	b0 0e                	mov    $0xe,%al
8010043f:	89 f2                	mov    %esi,%edx
80100441:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100442:	89 d8                	mov    %ebx,%eax
80100444:	c1 f8 08             	sar    $0x8,%eax
80100447:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010044c:	89 ca                	mov    %ecx,%edx
8010044e:	ee                   	out    %al,(%dx)
8010044f:	b0 0f                	mov    $0xf,%al
80100451:	89 f2                	mov    %esi,%edx
80100453:	ee                   	out    %al,(%dx)
80100454:	88 d8                	mov    %bl,%al
80100456:	89 ca                	mov    %ecx,%edx
80100458:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100459:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100460:	80 20 07 
}
80100463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100466:	5b                   	pop    %ebx
80100467:	5e                   	pop    %esi
80100468:	5f                   	pop    %edi
80100469:	5d                   	pop    %ebp
8010046a:	c3                   	ret    
    pos += 80 - pos%80;
8010046b:	bb 50 00 00 00       	mov    $0x50,%ebx
80100470:	89 c8                	mov    %ecx,%eax
80100472:	99                   	cltd   
80100473:	f7 fb                	idiv   %ebx
80100475:	29 d3                	sub    %edx,%ebx
80100477:	01 cb                	add    %ecx,%ebx
80100479:	eb ad                	jmp    80100428 <cgaputc+0x53>
    if(pos > 0) --pos;
8010047b:	85 c9                	test   %ecx,%ecx
8010047d:	7e 05                	jle    80100484 <cgaputc+0xaf>
8010047f:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100482:	eb a4                	jmp    80100428 <cgaputc+0x53>
  pos |= inb(CRTPORT+1);
80100484:	89 cb                	mov    %ecx,%ebx
80100486:	eb a0                	jmp    80100428 <cgaputc+0x53>
    panic("pos under/overflow");
80100488:	83 ec 0c             	sub    $0xc,%esp
8010048b:	68 e5 6a 10 80       	push   $0x80106ae5
80100490:	e8 c0 fe ff ff       	call   80100355 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100495:	83 ec 04             	sub    $0x4,%esp
80100498:	68 60 0e 00 00       	push   $0xe60
8010049d:	68 a0 80 0b 80       	push   $0x800b80a0
801004a2:	68 00 80 0b 80       	push   $0x800b8000
801004a7:	e8 95 3a 00 00       	call   80103f41 <memmove>
    pos -= 80;
801004ac:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004af:	b8 80 07 00 00       	mov    $0x780,%eax
801004b4:	29 d8                	sub    %ebx,%eax
801004b6:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004bd:	83 c4 0c             	add    $0xc,%esp
801004c0:	01 c0                	add    %eax,%eax
801004c2:	50                   	push   %eax
801004c3:	6a 00                	push   $0x0
801004c5:	52                   	push   %edx
801004c6:	e8 f8 39 00 00       	call   80103ec3 <memset>
801004cb:	83 c4 10             	add    $0x10,%esp
801004ce:	e9 65 ff ff ff       	jmp    80100438 <cgaputc+0x63>

801004d3 <consputc>:
  if(panicked){
801004d3:	83 3d 58 a5 10 80 00 	cmpl   $0x0,0x8010a558
801004da:	74 03                	je     801004df <consputc+0xc>
  asm volatile("cli");
801004dc:	fa                   	cli    
    for(;;)
801004dd:	eb fe                	jmp    801004dd <consputc+0xa>
{
801004df:	55                   	push   %ebp
801004e0:	89 e5                	mov    %esp,%ebp
801004e2:	53                   	push   %ebx
801004e3:	83 ec 04             	sub    $0x4,%esp
801004e6:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801004ed:	74 18                	je     80100507 <consputc+0x34>
    uartputc(c);
801004ef:	83 ec 0c             	sub    $0xc,%esp
801004f2:	50                   	push   %eax
801004f3:	e8 44 51 00 00       	call   8010563c <uartputc>
801004f8:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801004fb:	89 d8                	mov    %ebx,%eax
801004fd:	e8 d3 fe ff ff       	call   801003d5 <cgaputc>
}
80100502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100505:	c9                   	leave  
80100506:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100507:	83 ec 0c             	sub    $0xc,%esp
8010050a:	6a 08                	push   $0x8
8010050c:	e8 2b 51 00 00       	call   8010563c <uartputc>
80100511:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100518:	e8 1f 51 00 00       	call   8010563c <uartputc>
8010051d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100524:	e8 13 51 00 00       	call   8010563c <uartputc>
80100529:	83 c4 10             	add    $0x10,%esp
8010052c:	eb cd                	jmp    801004fb <consputc+0x28>

8010052e <printint>:
{
8010052e:	55                   	push   %ebp
8010052f:	89 e5                	mov    %esp,%ebp
80100531:	57                   	push   %edi
80100532:	56                   	push   %esi
80100533:	53                   	push   %ebx
80100534:	83 ec 2c             	sub    $0x2c,%esp
80100537:	89 d6                	mov    %edx,%esi
80100539:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010053c:	85 c9                	test   %ecx,%ecx
8010053e:	74 0c                	je     8010054c <printint+0x1e>
80100540:	89 c7                	mov    %eax,%edi
80100542:	c1 ef 1f             	shr    $0x1f,%edi
80100545:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100548:	85 c0                	test   %eax,%eax
8010054a:	78 35                	js     80100581 <printint+0x53>
    x = xx;
8010054c:	89 c1                	mov    %eax,%ecx
  i = 0;
8010054e:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100553:	89 c8                	mov    %ecx,%eax
80100555:	ba 00 00 00 00       	mov    $0x0,%edx
8010055a:	f7 f6                	div    %esi
8010055c:	89 df                	mov    %ebx,%edi
8010055e:	43                   	inc    %ebx
8010055f:	8a 92 10 6b 10 80    	mov    -0x7fef94f0(%edx),%dl
80100565:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
80100569:	89 ca                	mov    %ecx,%edx
8010056b:	89 c1                	mov    %eax,%ecx
8010056d:	39 d6                	cmp    %edx,%esi
8010056f:	76 e2                	jbe    80100553 <printint+0x25>
  if(sign)
80100571:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100575:	74 1a                	je     80100591 <printint+0x63>
    buf[i++] = '-';
80100577:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
8010057c:	8d 5f 02             	lea    0x2(%edi),%ebx
8010057f:	eb 10                	jmp    80100591 <printint+0x63>
    x = -xx;
80100581:	f7 d8                	neg    %eax
80100583:	89 c1                	mov    %eax,%ecx
80100585:	eb c7                	jmp    8010054e <printint+0x20>
    consputc(buf[i]);
80100587:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
8010058c:	e8 42 ff ff ff       	call   801004d3 <consputc>
  while(--i >= 0)
80100591:	4b                   	dec    %ebx
80100592:	79 f3                	jns    80100587 <printint+0x59>
}
80100594:	83 c4 2c             	add    $0x2c,%esp
80100597:	5b                   	pop    %ebx
80100598:	5e                   	pop    %esi
80100599:	5f                   	pop    %edi
8010059a:	5d                   	pop    %ebp
8010059b:	c3                   	ret    

8010059c <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010059c:	f3 0f 1e fb          	endbr32 
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 18             	sub    $0x18,%esp
801005a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005ac:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005af:	ff 75 08             	pushl  0x8(%ebp)
801005b2:	e8 a3 10 00 00       	call   8010165a <iunlock>
  acquire(&cons.lock);
801005b7:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005be:	e8 4c 38 00 00       	call   80103e0f <acquire>
  for(i = 0; i < n; i++)
801005c3:	83 c4 10             	add    $0x10,%esp
801005c6:	bb 00 00 00 00       	mov    $0x0,%ebx
801005cb:	39 f3                	cmp    %esi,%ebx
801005cd:	7d 0c                	jge    801005db <consolewrite+0x3f>
    consputc(buf[i] & 0xff);
801005cf:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005d3:	e8 fb fe ff ff       	call   801004d3 <consputc>
  for(i = 0; i < n; i++)
801005d8:	43                   	inc    %ebx
801005d9:	eb f0                	jmp    801005cb <consolewrite+0x2f>
  release(&cons.lock);
801005db:	83 ec 0c             	sub    $0xc,%esp
801005de:	68 20 a5 10 80       	push   $0x8010a520
801005e3:	e8 90 38 00 00       	call   80103e78 <release>
  ilock(ip);
801005e8:	83 c4 04             	add    $0x4,%esp
801005eb:	ff 75 08             	pushl  0x8(%ebp)
801005ee:	e8 a3 0f 00 00       	call   80101596 <ilock>

  return n;
}
801005f3:	89 f0                	mov    %esi,%eax
801005f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f8:	5b                   	pop    %ebx
801005f9:	5e                   	pop    %esi
801005fa:	5f                   	pop    %edi
801005fb:	5d                   	pop    %ebp
801005fc:	c3                   	ret    

801005fd <cprintf>:
{
801005fd:	f3 0f 1e fb          	endbr32 
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	57                   	push   %edi
80100605:	56                   	push   %esi
80100606:	53                   	push   %ebx
80100607:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010060a:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010060f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100612:	85 c0                	test   %eax,%eax
80100614:	75 10                	jne    80100626 <cprintf+0x29>
  if (fmt == 0)
80100616:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010061a:	74 1c                	je     80100638 <cprintf+0x3b>
  argp = (uint*)(void*)(&fmt + 1);
8010061c:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010061f:	be 00 00 00 00       	mov    $0x0,%esi
80100624:	eb 25                	jmp    8010064b <cprintf+0x4e>
    acquire(&cons.lock);
80100626:	83 ec 0c             	sub    $0xc,%esp
80100629:	68 20 a5 10 80       	push   $0x8010a520
8010062e:	e8 dc 37 00 00       	call   80103e0f <acquire>
80100633:	83 c4 10             	add    $0x10,%esp
80100636:	eb de                	jmp    80100616 <cprintf+0x19>
    panic("null fmt");
80100638:	83 ec 0c             	sub    $0xc,%esp
8010063b:	68 ff 6a 10 80       	push   $0x80106aff
80100640:	e8 10 fd ff ff       	call   80100355 <panic>
      consputc(c);
80100645:	e8 89 fe ff ff       	call   801004d3 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064a:	46                   	inc    %esi
8010064b:	8b 55 08             	mov    0x8(%ebp),%edx
8010064e:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
80100652:	85 c0                	test   %eax,%eax
80100654:	0f 84 ac 00 00 00    	je     80100706 <cprintf+0x109>
    if(c != '%'){
8010065a:	83 f8 25             	cmp    $0x25,%eax
8010065d:	75 e6                	jne    80100645 <cprintf+0x48>
    c = fmt[++i] & 0xff;
8010065f:	46                   	inc    %esi
80100660:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
80100664:	85 db                	test   %ebx,%ebx
80100666:	0f 84 9a 00 00 00    	je     80100706 <cprintf+0x109>
    switch(c){
8010066c:	83 fb 70             	cmp    $0x70,%ebx
8010066f:	74 2e                	je     8010069f <cprintf+0xa2>
80100671:	7f 22                	jg     80100695 <cprintf+0x98>
80100673:	83 fb 25             	cmp    $0x25,%ebx
80100676:	74 69                	je     801006e1 <cprintf+0xe4>
80100678:	83 fb 64             	cmp    $0x64,%ebx
8010067b:	75 73                	jne    801006f0 <cprintf+0xf3>
      printint(*argp++, 10, 1);
8010067d:	8d 5f 04             	lea    0x4(%edi),%ebx
80100680:	8b 07                	mov    (%edi),%eax
80100682:	b9 01 00 00 00       	mov    $0x1,%ecx
80100687:	ba 0a 00 00 00       	mov    $0xa,%edx
8010068c:	e8 9d fe ff ff       	call   8010052e <printint>
80100691:	89 df                	mov    %ebx,%edi
      break;
80100693:	eb b5                	jmp    8010064a <cprintf+0x4d>
    switch(c){
80100695:	83 fb 73             	cmp    $0x73,%ebx
80100698:	74 1d                	je     801006b7 <cprintf+0xba>
8010069a:	83 fb 78             	cmp    $0x78,%ebx
8010069d:	75 51                	jne    801006f0 <cprintf+0xf3>
      printint(*argp++, 16, 0);
8010069f:	8d 5f 04             	lea    0x4(%edi),%ebx
801006a2:	8b 07                	mov    (%edi),%eax
801006a4:	b9 00 00 00 00       	mov    $0x0,%ecx
801006a9:	ba 10 00 00 00       	mov    $0x10,%edx
801006ae:	e8 7b fe ff ff       	call   8010052e <printint>
801006b3:	89 df                	mov    %ebx,%edi
      break;
801006b5:	eb 93                	jmp    8010064a <cprintf+0x4d>
      if((s = (char*)*argp++) == 0)
801006b7:	8d 47 04             	lea    0x4(%edi),%eax
801006ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006bd:	8b 1f                	mov    (%edi),%ebx
801006bf:	85 db                	test   %ebx,%ebx
801006c1:	75 05                	jne    801006c8 <cprintf+0xcb>
        s = "(null)";
801006c3:	bb f8 6a 10 80       	mov    $0x80106af8,%ebx
      for(; *s; s++)
801006c8:	8a 03                	mov    (%ebx),%al
801006ca:	84 c0                	test   %al,%al
801006cc:	74 0b                	je     801006d9 <cprintf+0xdc>
        consputc(*s);
801006ce:	0f be c0             	movsbl %al,%eax
801006d1:	e8 fd fd ff ff       	call   801004d3 <consputc>
      for(; *s; s++)
801006d6:	43                   	inc    %ebx
801006d7:	eb ef                	jmp    801006c8 <cprintf+0xcb>
      if((s = (char*)*argp++) == 0)
801006d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801006dc:	e9 69 ff ff ff       	jmp    8010064a <cprintf+0x4d>
      consputc('%');
801006e1:	b8 25 00 00 00       	mov    $0x25,%eax
801006e6:	e8 e8 fd ff ff       	call   801004d3 <consputc>
      break;
801006eb:	e9 5a ff ff ff       	jmp    8010064a <cprintf+0x4d>
      consputc('%');
801006f0:	b8 25 00 00 00       	mov    $0x25,%eax
801006f5:	e8 d9 fd ff ff       	call   801004d3 <consputc>
      consputc(c);
801006fa:	89 d8                	mov    %ebx,%eax
801006fc:	e8 d2 fd ff ff       	call   801004d3 <consputc>
      break;
80100701:	e9 44 ff ff ff       	jmp    8010064a <cprintf+0x4d>
  if(locking)
80100706:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010070a:	75 08                	jne    80100714 <cprintf+0x117>
}
8010070c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010070f:	5b                   	pop    %ebx
80100710:	5e                   	pop    %esi
80100711:	5f                   	pop    %edi
80100712:	5d                   	pop    %ebp
80100713:	c3                   	ret    
    release(&cons.lock);
80100714:	83 ec 0c             	sub    $0xc,%esp
80100717:	68 20 a5 10 80       	push   $0x8010a520
8010071c:	e8 57 37 00 00       	call   80103e78 <release>
80100721:	83 c4 10             	add    $0x10,%esp
}
80100724:	eb e6                	jmp    8010070c <cprintf+0x10f>

80100726 <consoleintr>:
{
80100726:	f3 0f 1e fb          	endbr32 
8010072a:	55                   	push   %ebp
8010072b:	89 e5                	mov    %esp,%ebp
8010072d:	57                   	push   %edi
8010072e:	56                   	push   %esi
8010072f:	53                   	push   %ebx
80100730:	83 ec 18             	sub    $0x18,%esp
80100733:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100736:	68 20 a5 10 80       	push   $0x8010a520
8010073b:	e8 cf 36 00 00       	call   80103e0f <acquire>
  while((c = getc()) >= 0){
80100740:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100743:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
80100748:	eb 13                	jmp    8010075d <consoleintr+0x37>
    switch(c){
8010074a:	83 ff 08             	cmp    $0x8,%edi
8010074d:	0f 84 d1 00 00 00    	je     80100824 <consoleintr+0xfe>
80100753:	83 ff 10             	cmp    $0x10,%edi
80100756:	75 25                	jne    8010077d <consoleintr+0x57>
80100758:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
8010075d:	ff d3                	call   *%ebx
8010075f:	89 c7                	mov    %eax,%edi
80100761:	85 c0                	test   %eax,%eax
80100763:	0f 88 eb 00 00 00    	js     80100854 <consoleintr+0x12e>
    switch(c){
80100769:	83 ff 15             	cmp    $0x15,%edi
8010076c:	0f 84 8d 00 00 00    	je     801007ff <consoleintr+0xd9>
80100772:	7e d6                	jle    8010074a <consoleintr+0x24>
80100774:	83 ff 7f             	cmp    $0x7f,%edi
80100777:	0f 84 a7 00 00 00    	je     80100824 <consoleintr+0xfe>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010077d:	85 ff                	test   %edi,%edi
8010077f:	74 dc                	je     8010075d <consoleintr+0x37>
80100781:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100786:	89 c2                	mov    %eax,%edx
80100788:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
8010078e:	83 fa 7f             	cmp    $0x7f,%edx
80100791:	77 ca                	ja     8010075d <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
80100793:	83 ff 0d             	cmp    $0xd,%edi
80100796:	0f 84 ae 00 00 00    	je     8010084a <consoleintr+0x124>
        input.buf[input.e++ % INPUT_BUF] = c;
8010079c:	8d 50 01             	lea    0x1(%eax),%edx
8010079f:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
801007a5:	83 e0 7f             	and    $0x7f,%eax
801007a8:	89 f9                	mov    %edi,%ecx
801007aa:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801007b0:	89 f8                	mov    %edi,%eax
801007b2:	e8 1c fd ff ff       	call   801004d3 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007b7:	83 ff 0a             	cmp    $0xa,%edi
801007ba:	74 15                	je     801007d1 <consoleintr+0xab>
801007bc:	83 ff 04             	cmp    $0x4,%edi
801007bf:	74 10                	je     801007d1 <consoleintr+0xab>
801007c1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801007c6:	83 e8 80             	sub    $0xffffff80,%eax
801007c9:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801007cf:	75 8c                	jne    8010075d <consoleintr+0x37>
          input.w = input.e;
801007d1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007d6:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801007db:	83 ec 0c             	sub    $0xc,%esp
801007de:	68 a0 ff 10 80       	push   $0x8010ffa0
801007e3:	e8 8c 31 00 00       	call   80103974 <wakeup>
801007e8:	83 c4 10             	add    $0x10,%esp
801007eb:	e9 6d ff ff ff       	jmp    8010075d <consoleintr+0x37>
        input.e--;
801007f0:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801007f5:	b8 00 01 00 00       	mov    $0x100,%eax
801007fa:	e8 d4 fc ff ff       	call   801004d3 <consputc>
      while(input.e != input.w &&
801007ff:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100804:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010080a:	0f 84 4d ff ff ff    	je     8010075d <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100810:	48                   	dec    %eax
80100811:	89 c2                	mov    %eax,%edx
80100813:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100816:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010081d:	75 d1                	jne    801007f0 <consoleintr+0xca>
8010081f:	e9 39 ff ff ff       	jmp    8010075d <consoleintr+0x37>
      if(input.e != input.w){
80100824:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100829:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010082f:	0f 84 28 ff ff ff    	je     8010075d <consoleintr+0x37>
        input.e--;
80100835:	48                   	dec    %eax
80100836:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
8010083b:	b8 00 01 00 00       	mov    $0x100,%eax
80100840:	e8 8e fc ff ff       	call   801004d3 <consputc>
80100845:	e9 13 ff ff ff       	jmp    8010075d <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
8010084a:	bf 0a 00 00 00       	mov    $0xa,%edi
8010084f:	e9 48 ff ff ff       	jmp    8010079c <consoleintr+0x76>
  release(&cons.lock);
80100854:	83 ec 0c             	sub    $0xc,%esp
80100857:	68 20 a5 10 80       	push   $0x8010a520
8010085c:	e8 17 36 00 00       	call   80103e78 <release>
  if(doprocdump) {
80100861:	83 c4 10             	add    $0x10,%esp
80100864:	85 f6                	test   %esi,%esi
80100866:	75 08                	jne    80100870 <consoleintr+0x14a>
}
80100868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010086b:	5b                   	pop    %ebx
8010086c:	5e                   	pop    %esi
8010086d:	5f                   	pop    %edi
8010086e:	5d                   	pop    %ebp
8010086f:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
80100870:	e8 a6 31 00 00       	call   80103a1b <procdump>
}
80100875:	eb f1                	jmp    80100868 <consoleintr+0x142>

80100877 <consoleinit>:

void
consoleinit(void)
{
80100877:	f3 0f 1e fb          	endbr32 
8010087b:	55                   	push   %ebp
8010087c:	89 e5                	mov    %esp,%ebp
8010087e:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100881:	68 08 6b 10 80       	push   $0x80106b08
80100886:	68 20 a5 10 80       	push   $0x8010a520
8010088b:	e8 34 34 00 00       	call   80103cc4 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100890:	c7 05 6c 09 11 80 9c 	movl   $0x8010059c,0x8011096c
80100897:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010089a:	c7 05 68 09 11 80 74 	movl   $0x80100274,0x80110968
801008a1:	02 10 80 
  cons.locking = 1;
801008a4:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801008ab:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008ae:	83 c4 08             	add    $0x8,%esp
801008b1:	6a 00                	push   $0x0
801008b3:	6a 01                	push   $0x1
801008b5:	e8 fb 16 00 00       	call   80101fb5 <ioapicenable>
}
801008ba:	83 c4 10             	add    $0x10,%esp
801008bd:	c9                   	leave  
801008be:	c3                   	ret    

801008bf <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801008bf:	f3 0f 1e fb          	endbr32 
801008c3:	55                   	push   %ebp
801008c4:	89 e5                	mov    %esp,%ebp
801008c6:	57                   	push   %edi
801008c7:	56                   	push   %esi
801008c8:	53                   	push   %ebx
801008c9:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801008cf:	e8 a1 29 00 00       	call   80103275 <myproc>
801008d4:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801008da:	e8 04 1f 00 00       	call   801027e3 <begin_op>

  if((ip = namei(path)) == 0){
801008df:	83 ec 0c             	sub    $0xc,%esp
801008e2:	ff 75 08             	pushl  0x8(%ebp)
801008e5:	e8 38 13 00 00       	call   80101c22 <namei>
801008ea:	83 c4 10             	add    $0x10,%esp
801008ed:	85 c0                	test   %eax,%eax
801008ef:	74 56                	je     80100947 <exec+0x88>
801008f1:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801008f3:	83 ec 0c             	sub    $0xc,%esp
801008f6:	50                   	push   %eax
801008f7:	e8 9a 0c 00 00       	call   80101596 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801008fc:	6a 34                	push   $0x34
801008fe:	6a 00                	push   $0x0
80100900:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100906:	50                   	push   %eax
80100907:	53                   	push   %ebx
80100908:	e8 8a 0e 00 00       	call   80101797 <readi>
8010090d:	83 c4 20             	add    $0x20,%esp
80100910:	83 f8 34             	cmp    $0x34,%eax
80100913:	75 0c                	jne    80100921 <exec+0x62>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100915:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010091c:	45 4c 46 
8010091f:	74 42                	je     80100963 <exec+0xa4>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir, 1);
  if(ip){
80100921:	85 db                	test   %ebx,%ebx
80100923:	0f 84 e0 02 00 00    	je     80100c09 <exec+0x34a>
    iunlockput(ip);
80100929:	83 ec 0c             	sub    $0xc,%esp
8010092c:	53                   	push   %ebx
8010092d:	e8 13 0e 00 00       	call   80101745 <iunlockput>
    end_op();
80100932:	e8 2c 1f 00 00       	call   80102863 <end_op>
80100937:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
8010093a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010093f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100942:	5b                   	pop    %ebx
80100943:	5e                   	pop    %esi
80100944:	5f                   	pop    %edi
80100945:	5d                   	pop    %ebp
80100946:	c3                   	ret    
    end_op();
80100947:	e8 17 1f 00 00       	call   80102863 <end_op>
    cprintf("exec: fail\n");
8010094c:	83 ec 0c             	sub    $0xc,%esp
8010094f:	68 21 6b 10 80       	push   $0x80106b21
80100954:	e8 a4 fc ff ff       	call   801005fd <cprintf>
    return -1;
80100959:	83 c4 10             	add    $0x10,%esp
8010095c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100961:	eb dc                	jmp    8010093f <exec+0x80>
  if((pgdir = setupkvm()) == 0)
80100963:	e8 d1 5e 00 00       	call   80106839 <setupkvm>
80100968:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010096e:	85 c0                	test   %eax,%eax
80100970:	0f 84 24 01 00 00    	je     80100a9a <exec+0x1db>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100976:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
8010097c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100983:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100986:	be 00 00 00 00       	mov    $0x0,%esi
8010098b:	eb 04                	jmp    80100991 <exec+0xd2>
8010098d:	46                   	inc    %esi
8010098e:	8d 47 20             	lea    0x20(%edi),%eax
80100991:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100998:	39 f2                	cmp    %esi,%edx
8010099a:	0f 8e a5 00 00 00    	jle    80100a45 <exec+0x186>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009a0:	89 c7                	mov    %eax,%edi
801009a2:	6a 20                	push   $0x20
801009a4:	50                   	push   %eax
801009a5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009ab:	50                   	push   %eax
801009ac:	53                   	push   %ebx
801009ad:	e8 e5 0d 00 00       	call   80101797 <readi>
801009b2:	83 c4 10             	add    $0x10,%esp
801009b5:	83 f8 20             	cmp    $0x20,%eax
801009b8:	0f 85 dc 00 00 00    	jne    80100a9a <exec+0x1db>
    if(ph.type != ELF_PROG_LOAD || ph.memsz == 0)
801009be:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801009c5:	75 c6                	jne    8010098d <exec+0xce>
801009c7:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801009cd:	85 c0                	test   %eax,%eax
801009cf:	74 bc                	je     8010098d <exec+0xce>
    if(ph.memsz < ph.filesz)
801009d1:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009d7:	0f 82 bd 00 00 00    	jb     80100a9a <exec+0x1db>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009dd:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009e3:	0f 82 b1 00 00 00    	jb     80100a9a <exec+0x1db>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009e9:	83 ec 04             	sub    $0x4,%esp
801009ec:	50                   	push   %eax
801009ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801009f3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801009f9:	e8 d1 5c 00 00       	call   801066cf <allocuvm>
801009fe:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a04:	83 c4 10             	add    $0x10,%esp
80100a07:	85 c0                	test   %eax,%eax
80100a09:	0f 84 8b 00 00 00    	je     80100a9a <exec+0x1db>
    if(ph.vaddr % PGSIZE != 0)
80100a0f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a15:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a1a:	75 7e                	jne    80100a9a <exec+0x1db>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a1c:	83 ec 0c             	sub    $0xc,%esp
80100a1f:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a25:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a2b:	53                   	push   %ebx
80100a2c:	50                   	push   %eax
80100a2d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100a33:	e8 65 5b 00 00       	call   8010659d <loaduvm>
80100a38:	83 c4 20             	add    $0x20,%esp
80100a3b:	85 c0                	test   %eax,%eax
80100a3d:	0f 89 4a ff ff ff    	jns    8010098d <exec+0xce>
80100a43:	eb 55                	jmp    80100a9a <exec+0x1db>
  iunlockput(ip);
80100a45:	83 ec 0c             	sub    $0xc,%esp
80100a48:	53                   	push   %ebx
80100a49:	e8 f7 0c 00 00       	call   80101745 <iunlockput>
  end_op();
80100a4e:	e8 10 1e 00 00       	call   80102863 <end_op>
  sz = PGROUNDUP(sz);
80100a53:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a59:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  curproc->guard_page = sz; // Obtener la página de guarda
80100a63:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100a69:	89 81 80 00 00 00    	mov    %eax,0x80(%ecx)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a6f:	83 c4 0c             	add    $0xc,%esp
80100a72:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a78:	52                   	push   %edx
80100a79:	50                   	push   %eax
80100a7a:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100a80:	56                   	push   %esi
80100a81:	e8 49 5c 00 00       	call   801066cf <allocuvm>
80100a86:	89 c7                	mov    %eax,%edi
80100a88:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a8e:	83 c4 10             	add    $0x10,%esp
80100a91:	85 c0                	test   %eax,%eax
80100a93:	75 26                	jne    80100abb <exec+0x1fc>
  ip = 0;
80100a95:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100a9a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100aa0:	85 c0                	test   %eax,%eax
80100aa2:	0f 84 79 fe ff ff    	je     80100921 <exec+0x62>
    freevm(pgdir, 1);
80100aa8:	83 ec 08             	sub    $0x8,%esp
80100aab:	6a 01                	push   $0x1
80100aad:	50                   	push   %eax
80100aae:	e8 0c 5d 00 00       	call   801067bf <freevm>
80100ab3:	83 c4 10             	add    $0x10,%esp
80100ab6:	e9 66 fe ff ff       	jmp    80100921 <exec+0x62>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100abb:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ac1:	83 ec 08             	sub    $0x8,%esp
80100ac4:	50                   	push   %eax
80100ac5:	56                   	push   %esi
80100ac6:	e8 fd 5d 00 00       	call   801068c8 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100acb:	83 c4 10             	add    $0x10,%esp
80100ace:	be 00 00 00 00       	mov    $0x0,%esi
80100ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad6:	8d 1c b0             	lea    (%eax,%esi,4),%ebx
80100ad9:	8b 03                	mov    (%ebx),%eax
80100adb:	85 c0                	test   %eax,%eax
80100add:	74 47                	je     80100b26 <exec+0x267>
    if(argc >= MAXARG)
80100adf:	83 fe 1f             	cmp    $0x1f,%esi
80100ae2:	0f 87 0d 01 00 00    	ja     80100bf5 <exec+0x336>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ae8:	83 ec 0c             	sub    $0xc,%esp
80100aeb:	50                   	push   %eax
80100aec:	e8 7a 35 00 00       	call   8010406b <strlen>
80100af1:	29 c7                	sub    %eax,%edi
80100af3:	4f                   	dec    %edi
80100af4:	83 e7 fc             	and    $0xfffffffc,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100af7:	83 c4 04             	add    $0x4,%esp
80100afa:	ff 33                	pushl  (%ebx)
80100afc:	e8 6a 35 00 00       	call   8010406b <strlen>
80100b01:	40                   	inc    %eax
80100b02:	50                   	push   %eax
80100b03:	ff 33                	pushl  (%ebx)
80100b05:	57                   	push   %edi
80100b06:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b0c:	e8 f6 5e 00 00       	call   80106a07 <copyout>
80100b11:	83 c4 20             	add    $0x20,%esp
80100b14:	85 c0                	test   %eax,%eax
80100b16:	0f 88 e3 00 00 00    	js     80100bff <exec+0x340>
    ustack[3+argc] = sp;
80100b1c:	89 bc b5 64 ff ff ff 	mov    %edi,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b23:	46                   	inc    %esi
80100b24:	eb ad                	jmp    80100ad3 <exec+0x214>
80100b26:	89 f9                	mov    %edi,%ecx
80100b28:	89 c3                	mov    %eax,%ebx
  ustack[3+argc] = 0;
80100b2a:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100b31:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b35:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b3c:	ff ff ff 
  ustack[1] = argc;
80100b3f:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b45:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100b4c:	89 fa                	mov    %edi,%edx
80100b4e:	29 c2                	sub    %eax,%edx
80100b50:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b56:	8d 04 b5 10 00 00 00 	lea    0x10(,%esi,4),%eax
80100b5d:	29 c1                	sub    %eax,%ecx
80100b5f:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b61:	50                   	push   %eax
80100b62:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b68:	50                   	push   %eax
80100b69:	51                   	push   %ecx
80100b6a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b70:	e8 92 5e 00 00       	call   80106a07 <copyout>
80100b75:	83 c4 10             	add    $0x10,%esp
80100b78:	85 c0                	test   %eax,%eax
80100b7a:	0f 88 1a ff ff ff    	js     80100a9a <exec+0x1db>
  for(last=s=path; *s; s++)
80100b80:	8b 55 08             	mov    0x8(%ebp),%edx
80100b83:	89 d0                	mov    %edx,%eax
80100b85:	eb 01                	jmp    80100b88 <exec+0x2c9>
80100b87:	40                   	inc    %eax
80100b88:	8a 08                	mov    (%eax),%cl
80100b8a:	84 c9                	test   %cl,%cl
80100b8c:	74 0a                	je     80100b98 <exec+0x2d9>
    if(*s == '/')
80100b8e:	80 f9 2f             	cmp    $0x2f,%cl
80100b91:	75 f4                	jne    80100b87 <exec+0x2c8>
      last = s+1;
80100b93:	8d 50 01             	lea    0x1(%eax),%edx
80100b96:	eb ef                	jmp    80100b87 <exec+0x2c8>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100b98:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b9e:	89 f8                	mov    %edi,%eax
80100ba0:	83 c0 6c             	add    $0x6c,%eax
80100ba3:	83 ec 04             	sub    $0x4,%esp
80100ba6:	6a 10                	push   $0x10
80100ba8:	52                   	push   %edx
80100ba9:	50                   	push   %eax
80100baa:	e8 80 34 00 00       	call   8010402f <safestrcpy>
  oldpgdir = curproc->pgdir;
80100baf:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100bb2:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100bb8:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100bbb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100bc1:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100bc3:	8b 47 18             	mov    0x18(%edi),%eax
80100bc6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bcc:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bcf:	8b 47 18             	mov    0x18(%edi),%eax
80100bd2:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100bd5:	89 3c 24             	mov    %edi,(%esp)
80100bd8:	e8 3b 58 00 00       	call   80106418 <switchuvm>
  freevm(oldpgdir, 1);
80100bdd:	83 c4 08             	add    $0x8,%esp
80100be0:	6a 01                	push   $0x1
80100be2:	53                   	push   %ebx
80100be3:	e8 d7 5b 00 00       	call   801067bf <freevm>
  return 0;
80100be8:	83 c4 10             	add    $0x10,%esp
80100beb:	b8 00 00 00 00       	mov    $0x0,%eax
80100bf0:	e9 4a fd ff ff       	jmp    8010093f <exec+0x80>
  ip = 0;
80100bf5:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bfa:	e9 9b fe ff ff       	jmp    80100a9a <exec+0x1db>
80100bff:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c04:	e9 91 fe ff ff       	jmp    80100a9a <exec+0x1db>
  return -1;
80100c09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c0e:	e9 2c fd ff ff       	jmp    8010093f <exec+0x80>

80100c13 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c13:	f3 0f 1e fb          	endbr32 
80100c17:	55                   	push   %ebp
80100c18:	89 e5                	mov    %esp,%ebp
80100c1a:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c1d:	68 2d 6b 10 80       	push   $0x80106b2d
80100c22:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c27:	e8 98 30 00 00       	call   80103cc4 <initlock>
}
80100c2c:	83 c4 10             	add    $0x10,%esp
80100c2f:	c9                   	leave  
80100c30:	c3                   	ret    

80100c31 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c31:	f3 0f 1e fb          	endbr32 
80100c35:	55                   	push   %ebp
80100c36:	89 e5                	mov    %esp,%ebp
80100c38:	53                   	push   %ebx
80100c39:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c41:	e8 c9 31 00 00       	call   80103e0f <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c46:	83 c4 10             	add    $0x10,%esp
80100c49:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100c4e:	eb 03                	jmp    80100c53 <filealloc+0x22>
80100c50:	83 c3 18             	add    $0x18,%ebx
80100c53:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100c59:	73 24                	jae    80100c7f <filealloc+0x4e>
    if(f->ref == 0){
80100c5b:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c5f:	75 ef                	jne    80100c50 <filealloc+0x1f>
      f->ref = 1;
80100c61:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c68:	83 ec 0c             	sub    $0xc,%esp
80100c6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c70:	e8 03 32 00 00       	call   80103e78 <release>
      return f;
80100c75:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c78:	89 d8                	mov    %ebx,%eax
80100c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c7d:	c9                   	leave  
80100c7e:	c3                   	ret    
  release(&ftable.lock);
80100c7f:	83 ec 0c             	sub    $0xc,%esp
80100c82:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c87:	e8 ec 31 00 00       	call   80103e78 <release>
  return 0;
80100c8c:	83 c4 10             	add    $0x10,%esp
80100c8f:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c94:	eb e2                	jmp    80100c78 <filealloc+0x47>

80100c96 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100c96:	f3 0f 1e fb          	endbr32 
80100c9a:	55                   	push   %ebp
80100c9b:	89 e5                	mov    %esp,%ebp
80100c9d:	53                   	push   %ebx
80100c9e:	83 ec 10             	sub    $0x10,%esp
80100ca1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ca4:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ca9:	e8 61 31 00 00       	call   80103e0f <acquire>
  if(f->ref < 1)
80100cae:	8b 43 04             	mov    0x4(%ebx),%eax
80100cb1:	83 c4 10             	add    $0x10,%esp
80100cb4:	85 c0                	test   %eax,%eax
80100cb6:	7e 18                	jle    80100cd0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
80100cb8:	40                   	inc    %eax
80100cb9:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100cbc:	83 ec 0c             	sub    $0xc,%esp
80100cbf:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cc4:	e8 af 31 00 00       	call   80103e78 <release>
  return f;
}
80100cc9:	89 d8                	mov    %ebx,%eax
80100ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cce:	c9                   	leave  
80100ccf:	c3                   	ret    
    panic("filedup");
80100cd0:	83 ec 0c             	sub    $0xc,%esp
80100cd3:	68 34 6b 10 80       	push   $0x80106b34
80100cd8:	e8 78 f6 ff ff       	call   80100355 <panic>

80100cdd <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100cdd:	f3 0f 1e fb          	endbr32 
80100ce1:	55                   	push   %ebp
80100ce2:	89 e5                	mov    %esp,%ebp
80100ce4:	57                   	push   %edi
80100ce5:	56                   	push   %esi
80100ce6:	53                   	push   %ebx
80100ce7:	83 ec 38             	sub    $0x38,%esp
80100cea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ced:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cf2:	e8 18 31 00 00       	call   80103e0f <acquire>
  if(f->ref < 1)
80100cf7:	8b 43 04             	mov    0x4(%ebx),%eax
80100cfa:	83 c4 10             	add    $0x10,%esp
80100cfd:	85 c0                	test   %eax,%eax
80100cff:	7e 58                	jle    80100d59 <fileclose+0x7c>
    panic("fileclose");
  if(--f->ref > 0){
80100d01:	48                   	dec    %eax
80100d02:	89 43 04             	mov    %eax,0x4(%ebx)
80100d05:	85 c0                	test   %eax,%eax
80100d07:	7f 5d                	jg     80100d66 <fileclose+0x89>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100d09:	8d 7d d0             	lea    -0x30(%ebp),%edi
80100d0c:	b9 06 00 00 00       	mov    $0x6,%ecx
80100d11:	89 de                	mov    %ebx,%esi
80100d13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80100d15:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d1c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d22:	83 ec 0c             	sub    $0xc,%esp
80100d25:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d2a:	e8 49 31 00 00       	call   80103e78 <release>

  if(ff.type == FD_PIPE)
80100d2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100d32:	83 c4 10             	add    $0x10,%esp
80100d35:	83 f8 01             	cmp    $0x1,%eax
80100d38:	74 44                	je     80100d7e <fileclose+0xa1>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d3a:	83 f8 02             	cmp    $0x2,%eax
80100d3d:	75 37                	jne    80100d76 <fileclose+0x99>
    begin_op();
80100d3f:	e8 9f 1a 00 00       	call   801027e3 <begin_op>
    iput(ff.ip);
80100d44:	83 ec 0c             	sub    $0xc,%esp
80100d47:	ff 75 e0             	pushl  -0x20(%ebp)
80100d4a:	e8 54 09 00 00       	call   801016a3 <iput>
    end_op();
80100d4f:	e8 0f 1b 00 00       	call   80102863 <end_op>
80100d54:	83 c4 10             	add    $0x10,%esp
80100d57:	eb 1d                	jmp    80100d76 <fileclose+0x99>
    panic("fileclose");
80100d59:	83 ec 0c             	sub    $0xc,%esp
80100d5c:	68 3c 6b 10 80       	push   $0x80106b3c
80100d61:	e8 ef f5 ff ff       	call   80100355 <panic>
    release(&ftable.lock);
80100d66:	83 ec 0c             	sub    $0xc,%esp
80100d69:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d6e:	e8 05 31 00 00       	call   80103e78 <release>
    return;
80100d73:	83 c4 10             	add    $0x10,%esp
  }
}
80100d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d79:	5b                   	pop    %ebx
80100d7a:	5e                   	pop    %esi
80100d7b:	5f                   	pop    %edi
80100d7c:	5d                   	pop    %ebp
80100d7d:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100d7e:	83 ec 08             	sub    $0x8,%esp
80100d81:	0f be 45 d9          	movsbl -0x27(%ebp),%eax
80100d85:	50                   	push   %eax
80100d86:	ff 75 dc             	pushl  -0x24(%ebp)
80100d89:	e8 d6 20 00 00       	call   80102e64 <pipeclose>
80100d8e:	83 c4 10             	add    $0x10,%esp
80100d91:	eb e3                	jmp    80100d76 <fileclose+0x99>

80100d93 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100d93:	f3 0f 1e fb          	endbr32 
80100d97:	55                   	push   %ebp
80100d98:	89 e5                	mov    %esp,%ebp
80100d9a:	53                   	push   %ebx
80100d9b:	83 ec 04             	sub    $0x4,%esp
80100d9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100da1:	83 3b 02             	cmpl   $0x2,(%ebx)
80100da4:	75 31                	jne    80100dd7 <filestat+0x44>
    ilock(f->ip);
80100da6:	83 ec 0c             	sub    $0xc,%esp
80100da9:	ff 73 10             	pushl  0x10(%ebx)
80100dac:	e8 e5 07 00 00       	call   80101596 <ilock>
    stati(f->ip, st);
80100db1:	83 c4 08             	add    $0x8,%esp
80100db4:	ff 75 0c             	pushl  0xc(%ebp)
80100db7:	ff 73 10             	pushl  0x10(%ebx)
80100dba:	e8 aa 09 00 00       	call   80101769 <stati>
    iunlock(f->ip);
80100dbf:	83 c4 04             	add    $0x4,%esp
80100dc2:	ff 73 10             	pushl  0x10(%ebx)
80100dc5:	e8 90 08 00 00       	call   8010165a <iunlock>
    return 0;
80100dca:	83 c4 10             	add    $0x10,%esp
80100dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
  return -1;
80100dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ddc:	eb f4                	jmp    80100dd2 <filestat+0x3f>

80100dde <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100dde:	f3 0f 1e fb          	endbr32 
80100de2:	55                   	push   %ebp
80100de3:	89 e5                	mov    %esp,%ebp
80100de5:	56                   	push   %esi
80100de6:	53                   	push   %ebx
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100dea:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100dee:	74 70                	je     80100e60 <fileread+0x82>
    return -1;
  if(f->type == FD_PIPE)
80100df0:	8b 03                	mov    (%ebx),%eax
80100df2:	83 f8 01             	cmp    $0x1,%eax
80100df5:	74 44                	je     80100e3b <fileread+0x5d>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100df7:	83 f8 02             	cmp    $0x2,%eax
80100dfa:	75 57                	jne    80100e53 <fileread+0x75>
    ilock(f->ip);
80100dfc:	83 ec 0c             	sub    $0xc,%esp
80100dff:	ff 73 10             	pushl  0x10(%ebx)
80100e02:	e8 8f 07 00 00       	call   80101596 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e07:	ff 75 10             	pushl  0x10(%ebp)
80100e0a:	ff 73 14             	pushl  0x14(%ebx)
80100e0d:	ff 75 0c             	pushl  0xc(%ebp)
80100e10:	ff 73 10             	pushl  0x10(%ebx)
80100e13:	e8 7f 09 00 00       	call   80101797 <readi>
80100e18:	89 c6                	mov    %eax,%esi
80100e1a:	83 c4 20             	add    $0x20,%esp
80100e1d:	85 c0                	test   %eax,%eax
80100e1f:	7e 03                	jle    80100e24 <fileread+0x46>
      f->off += r;
80100e21:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e24:	83 ec 0c             	sub    $0xc,%esp
80100e27:	ff 73 10             	pushl  0x10(%ebx)
80100e2a:	e8 2b 08 00 00       	call   8010165a <iunlock>
    return r;
80100e2f:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e32:	89 f0                	mov    %esi,%eax
80100e34:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e37:	5b                   	pop    %ebx
80100e38:	5e                   	pop    %esi
80100e39:	5d                   	pop    %ebp
80100e3a:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e3b:	83 ec 04             	sub    $0x4,%esp
80100e3e:	ff 75 10             	pushl  0x10(%ebp)
80100e41:	ff 75 0c             	pushl  0xc(%ebp)
80100e44:	ff 73 0c             	pushl  0xc(%ebx)
80100e47:	e8 72 21 00 00       	call   80102fbe <piperead>
80100e4c:	89 c6                	mov    %eax,%esi
80100e4e:	83 c4 10             	add    $0x10,%esp
80100e51:	eb df                	jmp    80100e32 <fileread+0x54>
  panic("fileread");
80100e53:	83 ec 0c             	sub    $0xc,%esp
80100e56:	68 46 6b 10 80       	push   $0x80106b46
80100e5b:	e8 f5 f4 ff ff       	call   80100355 <panic>
    return -1;
80100e60:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e65:	eb cb                	jmp    80100e32 <fileread+0x54>

80100e67 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e67:	f3 0f 1e fb          	endbr32 
80100e6b:	55                   	push   %ebp
80100e6c:	89 e5                	mov    %esp,%ebp
80100e6e:	57                   	push   %edi
80100e6f:	56                   	push   %esi
80100e70:	53                   	push   %ebx
80100e71:	83 ec 1c             	sub    $0x1c,%esp
80100e74:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100e77:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e7b:	0f 84 cc 00 00 00    	je     80100f4d <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100e81:	8b 06                	mov    (%esi),%eax
80100e83:	83 f8 01             	cmp    $0x1,%eax
80100e86:	74 10                	je     80100e98 <filewrite+0x31>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e88:	83 f8 02             	cmp    $0x2,%eax
80100e8b:	0f 85 af 00 00 00    	jne    80100f40 <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100e91:	bf 00 00 00 00       	mov    $0x0,%edi
80100e96:	eb 67                	jmp    80100eff <filewrite+0x98>
    return pipewrite(f->pipe, addr, n);
80100e98:	83 ec 04             	sub    $0x4,%esp
80100e9b:	ff 75 10             	pushl  0x10(%ebp)
80100e9e:	ff 75 0c             	pushl  0xc(%ebp)
80100ea1:	ff 76 0c             	pushl  0xc(%esi)
80100ea4:	e8 4b 20 00 00       	call   80102ef4 <pipewrite>
80100ea9:	83 c4 10             	add    $0x10,%esp
80100eac:	e9 82 00 00 00       	jmp    80100f33 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100eb1:	e8 2d 19 00 00       	call   801027e3 <begin_op>
      ilock(f->ip);
80100eb6:	83 ec 0c             	sub    $0xc,%esp
80100eb9:	ff 76 10             	pushl  0x10(%esi)
80100ebc:	e8 d5 06 00 00       	call   80101596 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100ec1:	ff 75 e4             	pushl  -0x1c(%ebp)
80100ec4:	ff 76 14             	pushl  0x14(%esi)
80100ec7:	89 f8                	mov    %edi,%eax
80100ec9:	03 45 0c             	add    0xc(%ebp),%eax
80100ecc:	50                   	push   %eax
80100ecd:	ff 76 10             	pushl  0x10(%esi)
80100ed0:	e8 c6 09 00 00       	call   8010189b <writei>
80100ed5:	89 c3                	mov    %eax,%ebx
80100ed7:	83 c4 20             	add    $0x20,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 03                	jle    80100ee1 <filewrite+0x7a>
        f->off += r;
80100ede:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
80100ee4:	ff 76 10             	pushl  0x10(%esi)
80100ee7:	e8 6e 07 00 00       	call   8010165a <iunlock>
      end_op();
80100eec:	e8 72 19 00 00       	call   80102863 <end_op>

      if(r < 0)
80100ef1:	83 c4 10             	add    $0x10,%esp
80100ef4:	85 db                	test   %ebx,%ebx
80100ef6:	78 31                	js     80100f29 <filewrite+0xc2>
        break;
      if(r != n1)
80100ef8:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100efb:	75 1f                	jne    80100f1c <filewrite+0xb5>
        panic("short filewrite");
      i += r;
80100efd:	01 df                	add    %ebx,%edi
    while(i < n){
80100eff:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f02:	7d 25                	jge    80100f29 <filewrite+0xc2>
      int n1 = n - i;
80100f04:	8b 45 10             	mov    0x10(%ebp),%eax
80100f07:	29 f8                	sub    %edi,%eax
80100f09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100f0c:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f11:	7e 9e                	jle    80100eb1 <filewrite+0x4a>
        n1 = max;
80100f13:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100f1a:	eb 95                	jmp    80100eb1 <filewrite+0x4a>
        panic("short filewrite");
80100f1c:	83 ec 0c             	sub    $0xc,%esp
80100f1f:	68 4f 6b 10 80       	push   $0x80106b4f
80100f24:	e8 2c f4 ff ff       	call   80100355 <panic>
    }
    return i == n ? n : -1;
80100f29:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f2c:	74 0d                	je     80100f3b <filewrite+0xd4>
80100f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f36:	5b                   	pop    %ebx
80100f37:	5e                   	pop    %esi
80100f38:	5f                   	pop    %edi
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
    return i == n ? n : -1;
80100f3b:	8b 45 10             	mov    0x10(%ebp),%eax
80100f3e:	eb f3                	jmp    80100f33 <filewrite+0xcc>
  panic("filewrite");
80100f40:	83 ec 0c             	sub    $0xc,%esp
80100f43:	68 55 6b 10 80       	push   $0x80106b55
80100f48:	e8 08 f4 ff ff       	call   80100355 <panic>
    return -1;
80100f4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f52:	eb df                	jmp    80100f33 <filewrite+0xcc>

80100f54 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f54:	55                   	push   %ebp
80100f55:	89 e5                	mov    %esp,%ebp
80100f57:	57                   	push   %edi
80100f58:	56                   	push   %esi
80100f59:	53                   	push   %ebx
80100f5a:	83 ec 0c             	sub    $0xc,%esp
80100f5d:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f5f:	8a 10                	mov    (%eax),%dl
80100f61:	80 fa 2f             	cmp    $0x2f,%dl
80100f64:	75 03                	jne    80100f69 <skipelem+0x15>
    path++;
80100f66:	40                   	inc    %eax
80100f67:	eb f6                	jmp    80100f5f <skipelem+0xb>
  if(*path == 0)
80100f69:	84 d2                	test   %dl,%dl
80100f6b:	74 4e                	je     80100fbb <skipelem+0x67>
80100f6d:	89 c3                	mov    %eax,%ebx
80100f6f:	eb 01                	jmp    80100f72 <skipelem+0x1e>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f71:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80100f72:	8a 13                	mov    (%ebx),%dl
80100f74:	80 fa 2f             	cmp    $0x2f,%dl
80100f77:	74 04                	je     80100f7d <skipelem+0x29>
80100f79:	84 d2                	test   %dl,%dl
80100f7b:	75 f4                	jne    80100f71 <skipelem+0x1d>
  len = path - s;
80100f7d:	89 df                	mov    %ebx,%edi
80100f7f:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100f81:	83 ff 0d             	cmp    $0xd,%edi
80100f84:	7e 11                	jle    80100f97 <skipelem+0x43>
    memmove(name, s, DIRSIZ);
80100f86:	83 ec 04             	sub    $0x4,%esp
80100f89:	6a 0e                	push   $0xe
80100f8b:	50                   	push   %eax
80100f8c:	56                   	push   %esi
80100f8d:	e8 af 2f 00 00       	call   80103f41 <memmove>
80100f92:	83 c4 10             	add    $0x10,%esp
80100f95:	eb 15                	jmp    80100fac <skipelem+0x58>
  else {
    memmove(name, s, len);
80100f97:	83 ec 04             	sub    $0x4,%esp
80100f9a:	57                   	push   %edi
80100f9b:	50                   	push   %eax
80100f9c:	56                   	push   %esi
80100f9d:	e8 9f 2f 00 00       	call   80103f41 <memmove>
    name[len] = 0;
80100fa2:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100fa6:	83 c4 10             	add    $0x10,%esp
80100fa9:	eb 01                	jmp    80100fac <skipelem+0x58>
  }
  while(*path == '/')
    path++;
80100fab:	43                   	inc    %ebx
  while(*path == '/')
80100fac:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100faf:	74 fa                	je     80100fab <skipelem+0x57>
  return path;
}
80100fb1:	89 d8                	mov    %ebx,%eax
80100fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb6:	5b                   	pop    %ebx
80100fb7:	5e                   	pop    %esi
80100fb8:	5f                   	pop    %edi
80100fb9:	5d                   	pop    %ebp
80100fba:	c3                   	ret    
    return 0;
80100fbb:	bb 00 00 00 00       	mov    $0x0,%ebx
80100fc0:	eb ef                	jmp    80100fb1 <skipelem+0x5d>

80100fc2 <bzero>:
{
80100fc2:	55                   	push   %ebp
80100fc3:	89 e5                	mov    %esp,%ebp
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100fc9:	52                   	push   %edx
80100fca:	50                   	push   %eax
80100fcb:	e8 9e f1 ff ff       	call   8010016e <bread>
80100fd0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80100fd2:	8d 40 5c             	lea    0x5c(%eax),%eax
80100fd5:	83 c4 0c             	add    $0xc,%esp
80100fd8:	68 00 02 00 00       	push   $0x200
80100fdd:	6a 00                	push   $0x0
80100fdf:	50                   	push   %eax
80100fe0:	e8 de 2e 00 00       	call   80103ec3 <memset>
  log_write(bp);
80100fe5:	89 1c 24             	mov    %ebx,(%esp)
80100fe8:	e8 27 19 00 00       	call   80102914 <log_write>
  brelse(bp);
80100fed:	89 1c 24             	mov    %ebx,(%esp)
80100ff0:	e8 ea f1 ff ff       	call   801001df <brelse>
}
80100ff5:	83 c4 10             	add    $0x10,%esp
80100ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ffb:	c9                   	leave  
80100ffc:	c3                   	ret    

80100ffd <balloc>:
{
80100ffd:	55                   	push   %ebp
80100ffe:	89 e5                	mov    %esp,%ebp
80101000:	57                   	push   %edi
80101001:	56                   	push   %esi
80101002:	53                   	push   %ebx
80101003:	83 ec 1c             	sub    $0x1c,%esp
80101006:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101009:	bf 00 00 00 00       	mov    $0x0,%edi
8010100e:	eb 6d                	jmp    8010107d <balloc+0x80>
    bp = bread(dev, BBLOCK(b, sb));
80101010:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80101016:	eb 73                	jmp    8010108b <balloc+0x8e>
      m = 1 << (bi % 8);
80101018:	49                   	dec    %ecx
80101019:	83 c9 f8             	or     $0xfffffff8,%ecx
8010101c:	41                   	inc    %ecx
8010101d:	eb 38                	jmp    80101057 <balloc+0x5a>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010101f:	c1 f9 03             	sar    $0x3,%ecx
80101022:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80101025:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101028:	8a 4c 0e 5c          	mov    0x5c(%esi,%ecx,1),%cl
8010102c:	0f b6 f1             	movzbl %cl,%esi
8010102f:	85 d6                	test   %edx,%esi
80101031:	0f 84 83 00 00 00    	je     801010ba <balloc+0xbd>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101037:	40                   	inc    %eax
80101038:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010103d:	7f 2a                	jg     80101069 <balloc+0x6c>
8010103f:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80101042:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80101045:	3b 1d c0 09 11 80    	cmp    0x801109c0,%ebx
8010104b:	73 1c                	jae    80101069 <balloc+0x6c>
      m = 1 << (bi % 8);
8010104d:	89 c1                	mov    %eax,%ecx
8010104f:	81 e1 07 00 00 80    	and    $0x80000007,%ecx
80101055:	78 c1                	js     80101018 <balloc+0x1b>
80101057:	ba 01 00 00 00       	mov    $0x1,%edx
8010105c:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010105e:	89 c1                	mov    %eax,%ecx
80101060:	85 c0                	test   %eax,%eax
80101062:	79 bb                	jns    8010101f <balloc+0x22>
80101064:	8d 48 07             	lea    0x7(%eax),%ecx
80101067:	eb b6                	jmp    8010101f <balloc+0x22>
    brelse(bp);
80101069:	83 ec 0c             	sub    $0xc,%esp
8010106c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010106f:	e8 6b f1 ff ff       	call   801001df <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101074:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010107a:	83 c4 10             	add    $0x10,%esp
8010107d:	39 3d c0 09 11 80    	cmp    %edi,0x801109c0
80101083:	76 28                	jbe    801010ad <balloc+0xb0>
    bp = bread(dev, BBLOCK(b, sb));
80101085:	89 f8                	mov    %edi,%eax
80101087:	85 ff                	test   %edi,%edi
80101089:	78 85                	js     80101010 <balloc+0x13>
8010108b:	c1 f8 0c             	sar    $0xc,%eax
8010108e:	83 ec 08             	sub    $0x8,%esp
80101091:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101097:	50                   	push   %eax
80101098:	ff 75 d8             	pushl  -0x28(%ebp)
8010109b:	e8 ce f0 ff ff       	call   8010016e <bread>
801010a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010a3:	83 c4 10             	add    $0x10,%esp
801010a6:	b8 00 00 00 00       	mov    $0x0,%eax
801010ab:	eb 8b                	jmp    80101038 <balloc+0x3b>
  panic("balloc: out of blocks");
801010ad:	83 ec 0c             	sub    $0xc,%esp
801010b0:	68 5f 6b 10 80       	push   $0x80106b5f
801010b5:	e8 9b f2 ff ff       	call   80100355 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
801010ba:	09 ca                	or     %ecx,%edx
801010bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010bf:	8b 7d dc             	mov    -0x24(%ebp),%edi
801010c2:	88 54 38 5c          	mov    %dl,0x5c(%eax,%edi,1)
        log_write(bp);
801010c6:	83 ec 0c             	sub    $0xc,%esp
801010c9:	89 c7                	mov    %eax,%edi
801010cb:	50                   	push   %eax
801010cc:	e8 43 18 00 00       	call   80102914 <log_write>
        brelse(bp);
801010d1:	89 3c 24             	mov    %edi,(%esp)
801010d4:	e8 06 f1 ff ff       	call   801001df <brelse>
        bzero(dev, b + bi);
801010d9:	89 da                	mov    %ebx,%edx
801010db:	8b 45 d8             	mov    -0x28(%ebp),%eax
801010de:	e8 df fe ff ff       	call   80100fc2 <bzero>
}
801010e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
801010ed:	c3                   	ret    

801010ee <bmap>:
{
801010ee:	55                   	push   %ebp
801010ef:	89 e5                	mov    %esp,%ebp
801010f1:	57                   	push   %edi
801010f2:	56                   	push   %esi
801010f3:	53                   	push   %ebx
801010f4:	83 ec 1c             	sub    $0x1c,%esp
801010f7:	89 c3                	mov    %eax,%ebx
801010f9:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
801010fb:	83 fa 0b             	cmp    $0xb,%edx
801010fe:	76 45                	jbe    80101145 <bmap+0x57>
  bn -= NDIRECT;
80101100:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
80101103:	83 fe 7f             	cmp    $0x7f,%esi
80101106:	77 7f                	ja     80101187 <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101108:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010110e:	85 c0                	test   %eax,%eax
80101110:	74 4a                	je     8010115c <bmap+0x6e>
    bp = bread(ip->dev, addr);
80101112:	83 ec 08             	sub    $0x8,%esp
80101115:	50                   	push   %eax
80101116:	ff 33                	pushl  (%ebx)
80101118:	e8 51 f0 ff ff       	call   8010016e <bread>
8010111d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010111f:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
80101123:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101126:	8b 30                	mov    (%eax),%esi
80101128:	83 c4 10             	add    $0x10,%esp
8010112b:	85 f6                	test   %esi,%esi
8010112d:	74 3c                	je     8010116b <bmap+0x7d>
    brelse(bp);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	57                   	push   %edi
80101133:	e8 a7 f0 ff ff       	call   801001df <brelse>
    return addr;
80101138:	83 c4 10             	add    $0x10,%esp
}
8010113b:	89 f0                	mov    %esi,%eax
8010113d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101140:	5b                   	pop    %ebx
80101141:	5e                   	pop    %esi
80101142:	5f                   	pop    %edi
80101143:	5d                   	pop    %ebp
80101144:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
80101145:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
80101149:	85 f6                	test   %esi,%esi
8010114b:	75 ee                	jne    8010113b <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010114d:	8b 00                	mov    (%eax),%eax
8010114f:	e8 a9 fe ff ff       	call   80100ffd <balloc>
80101154:	89 c6                	mov    %eax,%esi
80101156:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
8010115a:	eb df                	jmp    8010113b <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
8010115c:	8b 03                	mov    (%ebx),%eax
8010115e:	e8 9a fe ff ff       	call   80100ffd <balloc>
80101163:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101169:	eb a7                	jmp    80101112 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
8010116b:	8b 03                	mov    (%ebx),%eax
8010116d:	e8 8b fe ff ff       	call   80100ffd <balloc>
80101172:	89 c6                	mov    %eax,%esi
80101174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101177:	89 30                	mov    %esi,(%eax)
      log_write(bp);
80101179:	83 ec 0c             	sub    $0xc,%esp
8010117c:	57                   	push   %edi
8010117d:	e8 92 17 00 00       	call   80102914 <log_write>
80101182:	83 c4 10             	add    $0x10,%esp
80101185:	eb a8                	jmp    8010112f <bmap+0x41>
  panic("bmap: out of range");
80101187:	83 ec 0c             	sub    $0xc,%esp
8010118a:	68 75 6b 10 80       	push   $0x80106b75
8010118f:	e8 c1 f1 ff ff       	call   80100355 <panic>

80101194 <iget>:
{
80101194:	55                   	push   %ebp
80101195:	89 e5                	mov    %esp,%ebp
80101197:	57                   	push   %edi
80101198:	56                   	push   %esi
80101199:	53                   	push   %ebx
8010119a:	83 ec 28             	sub    $0x28,%esp
8010119d:	89 c7                	mov    %eax,%edi
8010119f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801011a2:	68 e0 09 11 80       	push   $0x801109e0
801011a7:	e8 63 2c 00 00       	call   80103e0f <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011ac:	83 c4 10             	add    $0x10,%esp
  empty = 0;
801011af:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011b4:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
801011b9:	eb 0a                	jmp    801011c5 <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011bb:	85 f6                	test   %esi,%esi
801011bd:	74 39                	je     801011f8 <iget+0x64>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011bf:	81 c3 90 00 00 00    	add    $0x90,%ebx
801011c5:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801011cb:	73 33                	jae    80101200 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011cd:	8b 43 08             	mov    0x8(%ebx),%eax
801011d0:	85 c0                	test   %eax,%eax
801011d2:	7e e7                	jle    801011bb <iget+0x27>
801011d4:	39 3b                	cmp    %edi,(%ebx)
801011d6:	75 e3                	jne    801011bb <iget+0x27>
801011d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801011db:	39 4b 04             	cmp    %ecx,0x4(%ebx)
801011de:	75 db                	jne    801011bb <iget+0x27>
      ip->ref++;
801011e0:	40                   	inc    %eax
801011e1:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	68 e0 09 11 80       	push   $0x801109e0
801011ec:	e8 87 2c 00 00       	call   80103e78 <release>
      return ip;
801011f1:	83 c4 10             	add    $0x10,%esp
801011f4:	89 de                	mov    %ebx,%esi
801011f6:	eb 32                	jmp    8010122a <iget+0x96>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011f8:	85 c0                	test   %eax,%eax
801011fa:	75 c3                	jne    801011bf <iget+0x2b>
      empty = ip;
801011fc:	89 de                	mov    %ebx,%esi
801011fe:	eb bf                	jmp    801011bf <iget+0x2b>
  if(empty == 0)
80101200:	85 f6                	test   %esi,%esi
80101202:	74 30                	je     80101234 <iget+0xa0>
  ip->dev = dev;
80101204:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101209:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
8010120c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101213:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010121a:	83 ec 0c             	sub    $0xc,%esp
8010121d:	68 e0 09 11 80       	push   $0x801109e0
80101222:	e8 51 2c 00 00       	call   80103e78 <release>
  return ip;
80101227:	83 c4 10             	add    $0x10,%esp
}
8010122a:	89 f0                	mov    %esi,%eax
8010122c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010122f:	5b                   	pop    %ebx
80101230:	5e                   	pop    %esi
80101231:	5f                   	pop    %edi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("iget: no inodes");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 88 6b 10 80       	push   $0x80106b88
8010123c:	e8 14 f1 ff ff       	call   80100355 <panic>

80101241 <readsb>:
{
80101241:	f3 0f 1e fb          	endbr32 
80101245:	55                   	push   %ebp
80101246:	89 e5                	mov    %esp,%ebp
80101248:	53                   	push   %ebx
80101249:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
8010124c:	6a 01                	push   $0x1
8010124e:	ff 75 08             	pushl  0x8(%ebp)
80101251:	e8 18 ef ff ff       	call   8010016e <bread>
80101256:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101258:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125b:	83 c4 0c             	add    $0xc,%esp
8010125e:	6a 1c                	push   $0x1c
80101260:	50                   	push   %eax
80101261:	ff 75 0c             	pushl  0xc(%ebp)
80101264:	e8 d8 2c 00 00       	call   80103f41 <memmove>
  brelse(bp);
80101269:	89 1c 24             	mov    %ebx,(%esp)
8010126c:	e8 6e ef ff ff       	call   801001df <brelse>
}
80101271:	83 c4 10             	add    $0x10,%esp
80101274:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101277:	c9                   	leave  
80101278:	c3                   	ret    

80101279 <bfree>:
{
80101279:	55                   	push   %ebp
8010127a:	89 e5                	mov    %esp,%ebp
8010127c:	57                   	push   %edi
8010127d:	56                   	push   %esi
8010127e:	53                   	push   %ebx
8010127f:	83 ec 14             	sub    $0x14,%esp
80101282:	89 c3                	mov    %eax,%ebx
80101284:	89 d6                	mov    %edx,%esi
  readsb(dev, &sb);
80101286:	68 c0 09 11 80       	push   $0x801109c0
8010128b:	50                   	push   %eax
8010128c:	e8 b0 ff ff ff       	call   80101241 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101291:	89 f0                	mov    %esi,%eax
80101293:	c1 e8 0c             	shr    $0xc,%eax
80101296:	83 c4 08             	add    $0x8,%esp
80101299:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010129f:	50                   	push   %eax
801012a0:	53                   	push   %ebx
801012a1:	e8 c8 ee ff ff       	call   8010016e <bread>
801012a6:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
801012a8:	89 f7                	mov    %esi,%edi
801012aa:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  m = 1 << (bi % 8);
801012b0:	89 f1                	mov    %esi,%ecx
801012b2:	83 e1 07             	and    $0x7,%ecx
801012b5:	b8 01 00 00 00       	mov    $0x1,%eax
801012ba:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801012bc:	83 c4 10             	add    $0x10,%esp
801012bf:	c1 ff 03             	sar    $0x3,%edi
801012c2:	8a 54 3b 5c          	mov    0x5c(%ebx,%edi,1),%dl
801012c6:	0f b6 ca             	movzbl %dl,%ecx
801012c9:	85 c1                	test   %eax,%ecx
801012cb:	74 24                	je     801012f1 <bfree+0x78>
  bp->data[bi/8] &= ~m;
801012cd:	f7 d0                	not    %eax
801012cf:	21 d0                	and    %edx,%eax
801012d1:	88 44 3b 5c          	mov    %al,0x5c(%ebx,%edi,1)
  log_write(bp);
801012d5:	83 ec 0c             	sub    $0xc,%esp
801012d8:	53                   	push   %ebx
801012d9:	e8 36 16 00 00       	call   80102914 <log_write>
  brelse(bp);
801012de:	89 1c 24             	mov    %ebx,(%esp)
801012e1:	e8 f9 ee ff ff       	call   801001df <brelse>
}
801012e6:	83 c4 10             	add    $0x10,%esp
801012e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ec:	5b                   	pop    %ebx
801012ed:	5e                   	pop    %esi
801012ee:	5f                   	pop    %edi
801012ef:	5d                   	pop    %ebp
801012f0:	c3                   	ret    
    panic("freeing free block");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 98 6b 10 80       	push   $0x80106b98
801012f9:	e8 57 f0 ff ff       	call   80100355 <panic>

801012fe <iinit>:
{
801012fe:	f3 0f 1e fb          	endbr32 
80101302:	55                   	push   %ebp
80101303:	89 e5                	mov    %esp,%ebp
80101305:	53                   	push   %ebx
80101306:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101309:	68 ab 6b 10 80       	push   $0x80106bab
8010130e:	68 e0 09 11 80       	push   $0x801109e0
80101313:	e8 ac 29 00 00       	call   80103cc4 <initlock>
  for(i = 0; i < NINODE; i++) {
80101318:	83 c4 10             	add    $0x10,%esp
8010131b:	bb 00 00 00 00       	mov    $0x0,%ebx
80101320:	83 fb 31             	cmp    $0x31,%ebx
80101323:	7f 21                	jg     80101346 <iinit+0x48>
    initsleeplock(&icache.inode[i].lock, "inode");
80101325:	83 ec 08             	sub    $0x8,%esp
80101328:	68 b2 6b 10 80       	push   $0x80106bb2
8010132d:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101330:	89 d0                	mov    %edx,%eax
80101332:	c1 e0 04             	shl    $0x4,%eax
80101335:	05 20 0a 11 80       	add    $0x80110a20,%eax
8010133a:	50                   	push   %eax
8010133b:	e8 69 28 00 00       	call   80103ba9 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101340:	43                   	inc    %ebx
80101341:	83 c4 10             	add    $0x10,%esp
80101344:	eb da                	jmp    80101320 <iinit+0x22>
  readsb(dev, &sb);
80101346:	83 ec 08             	sub    $0x8,%esp
80101349:	68 c0 09 11 80       	push   $0x801109c0
8010134e:	ff 75 08             	pushl  0x8(%ebp)
80101351:	e8 eb fe ff ff       	call   80101241 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101356:	ff 35 d8 09 11 80    	pushl  0x801109d8
8010135c:	ff 35 d4 09 11 80    	pushl  0x801109d4
80101362:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101368:	ff 35 cc 09 11 80    	pushl  0x801109cc
8010136e:	ff 35 c8 09 11 80    	pushl  0x801109c8
80101374:	ff 35 c4 09 11 80    	pushl  0x801109c4
8010137a:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101380:	68 18 6c 10 80       	push   $0x80106c18
80101385:	e8 73 f2 ff ff       	call   801005fd <cprintf>
}
8010138a:	83 c4 30             	add    $0x30,%esp
8010138d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101390:	c9                   	leave  
80101391:	c3                   	ret    

80101392 <ialloc>:
{
80101392:	f3 0f 1e fb          	endbr32 
80101396:	55                   	push   %ebp
80101397:	89 e5                	mov    %esp,%ebp
80101399:	57                   	push   %edi
8010139a:	56                   	push   %esi
8010139b:	53                   	push   %ebx
8010139c:	83 ec 1c             	sub    $0x1c,%esp
8010139f:	8b 45 0c             	mov    0xc(%ebp),%eax
801013a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013a5:	bb 01 00 00 00       	mov    $0x1,%ebx
801013aa:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801013ad:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
801013b3:	76 73                	jbe    80101428 <ialloc+0x96>
    bp = bread(dev, IBLOCK(inum, sb));
801013b5:	89 d8                	mov    %ebx,%eax
801013b7:	c1 e8 03             	shr    $0x3,%eax
801013ba:	83 ec 08             	sub    $0x8,%esp
801013bd:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801013c3:	50                   	push   %eax
801013c4:	ff 75 08             	pushl  0x8(%ebp)
801013c7:	e8 a2 ed ff ff       	call   8010016e <bread>
801013cc:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013ce:	89 d8                	mov    %ebx,%eax
801013d0:	83 e0 07             	and    $0x7,%eax
801013d3:	c1 e0 06             	shl    $0x6,%eax
801013d6:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013da:	83 c4 10             	add    $0x10,%esp
801013dd:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013e1:	74 0f                	je     801013f2 <ialloc+0x60>
    brelse(bp);
801013e3:	83 ec 0c             	sub    $0xc,%esp
801013e6:	56                   	push   %esi
801013e7:	e8 f3 ed ff ff       	call   801001df <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013ec:	43                   	inc    %ebx
801013ed:	83 c4 10             	add    $0x10,%esp
801013f0:	eb b8                	jmp    801013aa <ialloc+0x18>
      memset(dip, 0, sizeof(*dip));
801013f2:	83 ec 04             	sub    $0x4,%esp
801013f5:	6a 40                	push   $0x40
801013f7:	6a 00                	push   $0x0
801013f9:	57                   	push   %edi
801013fa:	e8 c4 2a 00 00       	call   80103ec3 <memset>
      dip->type = type;
801013ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101402:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
80101405:	89 34 24             	mov    %esi,(%esp)
80101408:	e8 07 15 00 00       	call   80102914 <log_write>
      brelse(bp);
8010140d:	89 34 24             	mov    %esi,(%esp)
80101410:	e8 ca ed ff ff       	call   801001df <brelse>
      return iget(dev, inum);
80101415:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101418:	8b 45 08             	mov    0x8(%ebp),%eax
8010141b:	e8 74 fd ff ff       	call   80101194 <iget>
}
80101420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101423:	5b                   	pop    %ebx
80101424:	5e                   	pop    %esi
80101425:	5f                   	pop    %edi
80101426:	5d                   	pop    %ebp
80101427:	c3                   	ret    
  panic("ialloc: no inodes");
80101428:	83 ec 0c             	sub    $0xc,%esp
8010142b:	68 b8 6b 10 80       	push   $0x80106bb8
80101430:	e8 20 ef ff ff       	call   80100355 <panic>

80101435 <iupdate>:
{
80101435:	f3 0f 1e fb          	endbr32 
80101439:	55                   	push   %ebp
8010143a:	89 e5                	mov    %esp,%ebp
8010143c:	56                   	push   %esi
8010143d:	53                   	push   %ebx
8010143e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101441:	8b 43 04             	mov    0x4(%ebx),%eax
80101444:	c1 e8 03             	shr    $0x3,%eax
80101447:	83 ec 08             	sub    $0x8,%esp
8010144a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101450:	50                   	push   %eax
80101451:	ff 33                	pushl  (%ebx)
80101453:	e8 16 ed ff ff       	call   8010016e <bread>
80101458:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010145a:	8b 43 04             	mov    0x4(%ebx),%eax
8010145d:	83 e0 07             	and    $0x7,%eax
80101460:	c1 e0 06             	shl    $0x6,%eax
80101463:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101467:	8b 53 50             	mov    0x50(%ebx),%edx
8010146a:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010146d:	66 8b 53 52          	mov    0x52(%ebx),%dx
80101471:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101475:	8b 53 54             	mov    0x54(%ebx),%edx
80101478:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010147c:	66 8b 53 56          	mov    0x56(%ebx),%dx
80101480:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101484:	8b 53 58             	mov    0x58(%ebx),%edx
80101487:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010148a:	83 c3 5c             	add    $0x5c,%ebx
8010148d:	83 c0 0c             	add    $0xc,%eax
80101490:	83 c4 0c             	add    $0xc,%esp
80101493:	6a 34                	push   $0x34
80101495:	53                   	push   %ebx
80101496:	50                   	push   %eax
80101497:	e8 a5 2a 00 00       	call   80103f41 <memmove>
  log_write(bp);
8010149c:	89 34 24             	mov    %esi,(%esp)
8010149f:	e8 70 14 00 00       	call   80102914 <log_write>
  brelse(bp);
801014a4:	89 34 24             	mov    %esi,(%esp)
801014a7:	e8 33 ed ff ff       	call   801001df <brelse>
}
801014ac:	83 c4 10             	add    $0x10,%esp
801014af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014b2:	5b                   	pop    %ebx
801014b3:	5e                   	pop    %esi
801014b4:	5d                   	pop    %ebp
801014b5:	c3                   	ret    

801014b6 <itrunc>:
{
801014b6:	55                   	push   %ebp
801014b7:	89 e5                	mov    %esp,%ebp
801014b9:	57                   	push   %edi
801014ba:	56                   	push   %esi
801014bb:	53                   	push   %ebx
801014bc:	83 ec 1c             	sub    $0x1c,%esp
801014bf:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801014c1:	bb 00 00 00 00       	mov    $0x0,%ebx
801014c6:	eb 01                	jmp    801014c9 <itrunc+0x13>
801014c8:	43                   	inc    %ebx
801014c9:	83 fb 0b             	cmp    $0xb,%ebx
801014cc:	7f 19                	jg     801014e7 <itrunc+0x31>
    if(ip->addrs[i]){
801014ce:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
801014d2:	85 d2                	test   %edx,%edx
801014d4:	74 f2                	je     801014c8 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
801014d6:	8b 06                	mov    (%esi),%eax
801014d8:	e8 9c fd ff ff       	call   80101279 <bfree>
      ip->addrs[i] = 0;
801014dd:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
801014e4:	00 
801014e5:	eb e1                	jmp    801014c8 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
801014e7:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801014ed:	85 c0                	test   %eax,%eax
801014ef:	75 1b                	jne    8010150c <itrunc+0x56>
  ip->size = 0;
801014f1:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	56                   	push   %esi
801014fc:	e8 34 ff ff ff       	call   80101435 <iupdate>
}
80101501:	83 c4 10             	add    $0x10,%esp
80101504:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101507:	5b                   	pop    %ebx
80101508:	5e                   	pop    %esi
80101509:	5f                   	pop    %edi
8010150a:	5d                   	pop    %ebp
8010150b:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	50                   	push   %eax
80101510:	ff 36                	pushl  (%esi)
80101512:	e8 57 ec ff ff       	call   8010016e <bread>
80101517:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010151a:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010151d:	83 c4 10             	add    $0x10,%esp
80101520:	bb 00 00 00 00       	mov    $0x0,%ebx
80101525:	eb 08                	jmp    8010152f <itrunc+0x79>
        bfree(ip->dev, a[j]);
80101527:	8b 06                	mov    (%esi),%eax
80101529:	e8 4b fd ff ff       	call   80101279 <bfree>
    for(j = 0; j < NINDIRECT; j++){
8010152e:	43                   	inc    %ebx
8010152f:	83 fb 7f             	cmp    $0x7f,%ebx
80101532:	77 09                	ja     8010153d <itrunc+0x87>
      if(a[j])
80101534:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
80101537:	85 d2                	test   %edx,%edx
80101539:	74 f3                	je     8010152e <itrunc+0x78>
8010153b:	eb ea                	jmp    80101527 <itrunc+0x71>
    brelse(bp);
8010153d:	83 ec 0c             	sub    $0xc,%esp
80101540:	ff 75 e4             	pushl  -0x1c(%ebp)
80101543:	e8 97 ec ff ff       	call   801001df <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101548:	8b 06                	mov    (%esi),%eax
8010154a:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101550:	e8 24 fd ff ff       	call   80101279 <bfree>
    ip->addrs[NDIRECT] = 0;
80101555:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010155c:	00 00 00 
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	eb 8d                	jmp    801014f1 <itrunc+0x3b>

80101564 <idup>:
{
80101564:	f3 0f 1e fb          	endbr32 
80101568:	55                   	push   %ebp
80101569:	89 e5                	mov    %esp,%ebp
8010156b:	53                   	push   %ebx
8010156c:	83 ec 10             	sub    $0x10,%esp
8010156f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101572:	68 e0 09 11 80       	push   $0x801109e0
80101577:	e8 93 28 00 00       	call   80103e0f <acquire>
  ip->ref++;
8010157c:	8b 43 08             	mov    0x8(%ebx),%eax
8010157f:	40                   	inc    %eax
80101580:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101583:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010158a:	e8 e9 28 00 00       	call   80103e78 <release>
}
8010158f:	89 d8                	mov    %ebx,%eax
80101591:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101594:	c9                   	leave  
80101595:	c3                   	ret    

80101596 <ilock>:
{
80101596:	f3 0f 1e fb          	endbr32 
8010159a:	55                   	push   %ebp
8010159b:	89 e5                	mov    %esp,%ebp
8010159d:	56                   	push   %esi
8010159e:	53                   	push   %ebx
8010159f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801015a2:	85 db                	test   %ebx,%ebx
801015a4:	74 22                	je     801015c8 <ilock+0x32>
801015a6:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015aa:	7e 1c                	jle    801015c8 <ilock+0x32>
  acquiresleep(&ip->lock);
801015ac:	83 ec 0c             	sub    $0xc,%esp
801015af:	8d 43 0c             	lea    0xc(%ebx),%eax
801015b2:	50                   	push   %eax
801015b3:	e8 28 26 00 00       	call   80103be0 <acquiresleep>
  if(ip->valid == 0){
801015b8:	83 c4 10             	add    $0x10,%esp
801015bb:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801015bf:	74 14                	je     801015d5 <ilock+0x3f>
}
801015c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015c4:	5b                   	pop    %ebx
801015c5:	5e                   	pop    %esi
801015c6:	5d                   	pop    %ebp
801015c7:	c3                   	ret    
    panic("ilock");
801015c8:	83 ec 0c             	sub    $0xc,%esp
801015cb:	68 ca 6b 10 80       	push   $0x80106bca
801015d0:	e8 80 ed ff ff       	call   80100355 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d5:	8b 43 04             	mov    0x4(%ebx),%eax
801015d8:	c1 e8 03             	shr    $0x3,%eax
801015db:	83 ec 08             	sub    $0x8,%esp
801015de:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015e4:	50                   	push   %eax
801015e5:	ff 33                	pushl  (%ebx)
801015e7:	e8 82 eb ff ff       	call   8010016e <bread>
801015ec:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ee:	8b 43 04             	mov    0x4(%ebx),%eax
801015f1:	83 e0 07             	and    $0x7,%eax
801015f4:	c1 e0 06             	shl    $0x6,%eax
801015f7:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015fb:	8b 10                	mov    (%eax),%edx
801015fd:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101601:	66 8b 50 02          	mov    0x2(%eax),%dx
80101605:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101609:	8b 50 04             	mov    0x4(%eax),%edx
8010160c:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101610:	66 8b 50 06          	mov    0x6(%eax),%dx
80101614:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101618:	8b 50 08             	mov    0x8(%eax),%edx
8010161b:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010161e:	83 c0 0c             	add    $0xc,%eax
80101621:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101624:	83 c4 0c             	add    $0xc,%esp
80101627:	6a 34                	push   $0x34
80101629:	50                   	push   %eax
8010162a:	52                   	push   %edx
8010162b:	e8 11 29 00 00       	call   80103f41 <memmove>
    brelse(bp);
80101630:	89 34 24             	mov    %esi,(%esp)
80101633:	e8 a7 eb ff ff       	call   801001df <brelse>
    ip->valid = 1;
80101638:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010163f:	83 c4 10             	add    $0x10,%esp
80101642:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101647:	0f 85 74 ff ff ff    	jne    801015c1 <ilock+0x2b>
      panic("ilock: no type");
8010164d:	83 ec 0c             	sub    $0xc,%esp
80101650:	68 d0 6b 10 80       	push   $0x80106bd0
80101655:	e8 fb ec ff ff       	call   80100355 <panic>

8010165a <iunlock>:
{
8010165a:	f3 0f 1e fb          	endbr32 
8010165e:	55                   	push   %ebp
8010165f:	89 e5                	mov    %esp,%ebp
80101661:	56                   	push   %esi
80101662:	53                   	push   %ebx
80101663:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101666:	85 db                	test   %ebx,%ebx
80101668:	74 2c                	je     80101696 <iunlock+0x3c>
8010166a:	8d 73 0c             	lea    0xc(%ebx),%esi
8010166d:	83 ec 0c             	sub    $0xc,%esp
80101670:	56                   	push   %esi
80101671:	e8 fc 25 00 00       	call   80103c72 <holdingsleep>
80101676:	83 c4 10             	add    $0x10,%esp
80101679:	85 c0                	test   %eax,%eax
8010167b:	74 19                	je     80101696 <iunlock+0x3c>
8010167d:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101681:	7e 13                	jle    80101696 <iunlock+0x3c>
  releasesleep(&ip->lock);
80101683:	83 ec 0c             	sub    $0xc,%esp
80101686:	56                   	push   %esi
80101687:	e8 a7 25 00 00       	call   80103c33 <releasesleep>
}
8010168c:	83 c4 10             	add    $0x10,%esp
8010168f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101692:	5b                   	pop    %ebx
80101693:	5e                   	pop    %esi
80101694:	5d                   	pop    %ebp
80101695:	c3                   	ret    
    panic("iunlock");
80101696:	83 ec 0c             	sub    $0xc,%esp
80101699:	68 df 6b 10 80       	push   $0x80106bdf
8010169e:	e8 b2 ec ff ff       	call   80100355 <panic>

801016a3 <iput>:
{
801016a3:	f3 0f 1e fb          	endbr32 
801016a7:	55                   	push   %ebp
801016a8:	89 e5                	mov    %esp,%ebp
801016aa:	57                   	push   %edi
801016ab:	56                   	push   %esi
801016ac:	53                   	push   %ebx
801016ad:	83 ec 18             	sub    $0x18,%esp
801016b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801016b3:	8d 73 0c             	lea    0xc(%ebx),%esi
801016b6:	56                   	push   %esi
801016b7:	e8 24 25 00 00       	call   80103be0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016bc:	83 c4 10             	add    $0x10,%esp
801016bf:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801016c3:	74 07                	je     801016cc <iput+0x29>
801016c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801016ca:	74 33                	je     801016ff <iput+0x5c>
  releasesleep(&ip->lock);
801016cc:	83 ec 0c             	sub    $0xc,%esp
801016cf:	56                   	push   %esi
801016d0:	e8 5e 25 00 00       	call   80103c33 <releasesleep>
  acquire(&icache.lock);
801016d5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016dc:	e8 2e 27 00 00       	call   80103e0f <acquire>
  ip->ref--;
801016e1:	8b 43 08             	mov    0x8(%ebx),%eax
801016e4:	48                   	dec    %eax
801016e5:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801016e8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016ef:	e8 84 27 00 00       	call   80103e78 <release>
}
801016f4:	83 c4 10             	add    $0x10,%esp
801016f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016fa:	5b                   	pop    %ebx
801016fb:	5e                   	pop    %esi
801016fc:	5f                   	pop    %edi
801016fd:	5d                   	pop    %ebp
801016fe:	c3                   	ret    
    acquire(&icache.lock);
801016ff:	83 ec 0c             	sub    $0xc,%esp
80101702:	68 e0 09 11 80       	push   $0x801109e0
80101707:	e8 03 27 00 00       	call   80103e0f <acquire>
    int r = ip->ref;
8010170c:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
8010170f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101716:	e8 5d 27 00 00       	call   80103e78 <release>
    if(r == 1){
8010171b:	83 c4 10             	add    $0x10,%esp
8010171e:	83 ff 01             	cmp    $0x1,%edi
80101721:	75 a9                	jne    801016cc <iput+0x29>
      itrunc(ip);
80101723:	89 d8                	mov    %ebx,%eax
80101725:	e8 8c fd ff ff       	call   801014b6 <itrunc>
      ip->type = 0;
8010172a:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101730:	83 ec 0c             	sub    $0xc,%esp
80101733:	53                   	push   %ebx
80101734:	e8 fc fc ff ff       	call   80101435 <iupdate>
      ip->valid = 0;
80101739:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101740:	83 c4 10             	add    $0x10,%esp
80101743:	eb 87                	jmp    801016cc <iput+0x29>

80101745 <iunlockput>:
{
80101745:	f3 0f 1e fb          	endbr32 
80101749:	55                   	push   %ebp
8010174a:	89 e5                	mov    %esp,%ebp
8010174c:	53                   	push   %ebx
8010174d:	83 ec 10             	sub    $0x10,%esp
80101750:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101753:	53                   	push   %ebx
80101754:	e8 01 ff ff ff       	call   8010165a <iunlock>
  iput(ip);
80101759:	89 1c 24             	mov    %ebx,(%esp)
8010175c:	e8 42 ff ff ff       	call   801016a3 <iput>
}
80101761:	83 c4 10             	add    $0x10,%esp
80101764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101767:	c9                   	leave  
80101768:	c3                   	ret    

80101769 <stati>:
{
80101769:	f3 0f 1e fb          	endbr32 
8010176d:	55                   	push   %ebp
8010176e:	89 e5                	mov    %esp,%ebp
80101770:	8b 55 08             	mov    0x8(%ebp),%edx
80101773:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101776:	8b 0a                	mov    (%edx),%ecx
80101778:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010177b:	8b 4a 04             	mov    0x4(%edx),%ecx
8010177e:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101781:	8b 4a 50             	mov    0x50(%edx),%ecx
80101784:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101787:	66 8b 4a 56          	mov    0x56(%edx),%cx
8010178b:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
8010178f:	8b 52 58             	mov    0x58(%edx),%edx
80101792:	89 50 10             	mov    %edx,0x10(%eax)
}
80101795:	5d                   	pop    %ebp
80101796:	c3                   	ret    

80101797 <readi>:
{
80101797:	f3 0f 1e fb          	endbr32 
8010179b:	55                   	push   %ebp
8010179c:	89 e5                	mov    %esp,%ebp
8010179e:	57                   	push   %edi
8010179f:	56                   	push   %esi
801017a0:	53                   	push   %ebx
801017a1:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
801017a4:	8b 45 08             	mov    0x8(%ebp),%eax
801017a7:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801017ac:	74 2c                	je     801017da <readi+0x43>
  if(off > ip->size || off + n < off)
801017ae:	8b 45 08             	mov    0x8(%ebp),%eax
801017b1:	8b 40 58             	mov    0x58(%eax),%eax
801017b4:	3b 45 10             	cmp    0x10(%ebp),%eax
801017b7:	0f 82 d0 00 00 00    	jb     8010188d <readi+0xf6>
801017bd:	8b 55 10             	mov    0x10(%ebp),%edx
801017c0:	03 55 14             	add    0x14(%ebp),%edx
801017c3:	0f 82 cb 00 00 00    	jb     80101894 <readi+0xfd>
  if(off + n > ip->size)
801017c9:	39 d0                	cmp    %edx,%eax
801017cb:	73 06                	jae    801017d3 <readi+0x3c>
    n = ip->size - off;
801017cd:	2b 45 10             	sub    0x10(%ebp),%eax
801017d0:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017d3:	bf 00 00 00 00       	mov    $0x0,%edi
801017d8:	eb 55                	jmp    8010182f <readi+0x98>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801017da:	66 8b 40 52          	mov    0x52(%eax),%ax
801017de:	66 83 f8 09          	cmp    $0x9,%ax
801017e2:	0f 87 97 00 00 00    	ja     8010187f <readi+0xe8>
801017e8:	98                   	cwtl   
801017e9:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
801017f0:	85 c0                	test   %eax,%eax
801017f2:	0f 84 8e 00 00 00    	je     80101886 <readi+0xef>
    return devsw[ip->major].read(ip, dst, n);
801017f8:	83 ec 04             	sub    $0x4,%esp
801017fb:	ff 75 14             	pushl  0x14(%ebp)
801017fe:	ff 75 0c             	pushl  0xc(%ebp)
80101801:	ff 75 08             	pushl  0x8(%ebp)
80101804:	ff d0                	call   *%eax
80101806:	83 c4 10             	add    $0x10,%esp
80101809:	eb 6c                	jmp    80101877 <readi+0xe0>
    memmove(dst, bp->data + off%BSIZE, m);
8010180b:	83 ec 04             	sub    $0x4,%esp
8010180e:	53                   	push   %ebx
8010180f:	8d 44 16 5c          	lea    0x5c(%esi,%edx,1),%eax
80101813:	50                   	push   %eax
80101814:	ff 75 0c             	pushl  0xc(%ebp)
80101817:	e8 25 27 00 00       	call   80103f41 <memmove>
    brelse(bp);
8010181c:	89 34 24             	mov    %esi,(%esp)
8010181f:	e8 bb e9 ff ff       	call   801001df <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101824:	01 df                	add    %ebx,%edi
80101826:	01 5d 10             	add    %ebx,0x10(%ebp)
80101829:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010182c:	83 c4 10             	add    $0x10,%esp
8010182f:	39 7d 14             	cmp    %edi,0x14(%ebp)
80101832:	76 40                	jbe    80101874 <readi+0xdd>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101834:	8b 55 10             	mov    0x10(%ebp),%edx
80101837:	c1 ea 09             	shr    $0x9,%edx
8010183a:	8b 45 08             	mov    0x8(%ebp),%eax
8010183d:	e8 ac f8 ff ff       	call   801010ee <bmap>
80101842:	83 ec 08             	sub    $0x8,%esp
80101845:	50                   	push   %eax
80101846:	8b 45 08             	mov    0x8(%ebp),%eax
80101849:	ff 30                	pushl  (%eax)
8010184b:	e8 1e e9 ff ff       	call   8010016e <bread>
80101850:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101852:	8b 55 10             	mov    0x10(%ebp),%edx
80101855:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010185b:	b8 00 02 00 00       	mov    $0x200,%eax
80101860:	29 d0                	sub    %edx,%eax
80101862:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101865:	29 f9                	sub    %edi,%ecx
80101867:	89 c3                	mov    %eax,%ebx
80101869:	83 c4 10             	add    $0x10,%esp
8010186c:	39 c8                	cmp    %ecx,%eax
8010186e:	76 9b                	jbe    8010180b <readi+0x74>
80101870:	89 cb                	mov    %ecx,%ebx
80101872:	eb 97                	jmp    8010180b <readi+0x74>
  return n;
80101874:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101877:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010187a:	5b                   	pop    %ebx
8010187b:	5e                   	pop    %esi
8010187c:	5f                   	pop    %edi
8010187d:	5d                   	pop    %ebp
8010187e:	c3                   	ret    
      return -1;
8010187f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101884:	eb f1                	jmp    80101877 <readi+0xe0>
80101886:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010188b:	eb ea                	jmp    80101877 <readi+0xe0>
    return -1;
8010188d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101892:	eb e3                	jmp    80101877 <readi+0xe0>
80101894:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101899:	eb dc                	jmp    80101877 <readi+0xe0>

8010189b <writei>:
{
8010189b:	f3 0f 1e fb          	endbr32 
8010189f:	55                   	push   %ebp
801018a0:	89 e5                	mov    %esp,%ebp
801018a2:	57                   	push   %edi
801018a3:	56                   	push   %esi
801018a4:	53                   	push   %ebx
801018a5:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
801018a8:	8b 45 08             	mov    0x8(%ebp),%eax
801018ab:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018b0:	74 2c                	je     801018de <writei+0x43>
  if(off > ip->size || off + n < off)
801018b2:	8b 45 08             	mov    0x8(%ebp),%eax
801018b5:	8b 7d 10             	mov    0x10(%ebp),%edi
801018b8:	39 78 58             	cmp    %edi,0x58(%eax)
801018bb:	0f 82 fd 00 00 00    	jb     801019be <writei+0x123>
801018c1:	89 f8                	mov    %edi,%eax
801018c3:	03 45 14             	add    0x14(%ebp),%eax
801018c6:	0f 82 f9 00 00 00    	jb     801019c5 <writei+0x12a>
  if(off + n > MAXFILE*BSIZE)
801018cc:	3d 00 18 01 00       	cmp    $0x11800,%eax
801018d1:	0f 87 f5 00 00 00    	ja     801019cc <writei+0x131>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018d7:	bf 00 00 00 00       	mov    $0x0,%edi
801018dc:	eb 60                	jmp    8010193e <writei+0xa3>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801018de:	66 8b 40 52          	mov    0x52(%eax),%ax
801018e2:	66 83 f8 09          	cmp    $0x9,%ax
801018e6:	0f 87 c4 00 00 00    	ja     801019b0 <writei+0x115>
801018ec:	98                   	cwtl   
801018ed:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
801018f4:	85 c0                	test   %eax,%eax
801018f6:	0f 84 bb 00 00 00    	je     801019b7 <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801018fc:	83 ec 04             	sub    $0x4,%esp
801018ff:	ff 75 14             	pushl  0x14(%ebp)
80101902:	ff 75 0c             	pushl  0xc(%ebp)
80101905:	ff 75 08             	pushl  0x8(%ebp)
80101908:	ff d0                	call   *%eax
8010190a:	83 c4 10             	add    $0x10,%esp
8010190d:	e9 85 00 00 00       	jmp    80101997 <writei+0xfc>
    memmove(bp->data + off%BSIZE, src, m);
80101912:	83 ec 04             	sub    $0x4,%esp
80101915:	56                   	push   %esi
80101916:	ff 75 0c             	pushl  0xc(%ebp)
80101919:	8d 44 13 5c          	lea    0x5c(%ebx,%edx,1),%eax
8010191d:	50                   	push   %eax
8010191e:	e8 1e 26 00 00       	call   80103f41 <memmove>
    log_write(bp);
80101923:	89 1c 24             	mov    %ebx,(%esp)
80101926:	e8 e9 0f 00 00       	call   80102914 <log_write>
    brelse(bp);
8010192b:	89 1c 24             	mov    %ebx,(%esp)
8010192e:	e8 ac e8 ff ff       	call   801001df <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101933:	01 f7                	add    %esi,%edi
80101935:	01 75 10             	add    %esi,0x10(%ebp)
80101938:	01 75 0c             	add    %esi,0xc(%ebp)
8010193b:	83 c4 10             	add    $0x10,%esp
8010193e:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101941:	73 40                	jae    80101983 <writei+0xe8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101943:	8b 55 10             	mov    0x10(%ebp),%edx
80101946:	c1 ea 09             	shr    $0x9,%edx
80101949:	8b 45 08             	mov    0x8(%ebp),%eax
8010194c:	e8 9d f7 ff ff       	call   801010ee <bmap>
80101951:	83 ec 08             	sub    $0x8,%esp
80101954:	50                   	push   %eax
80101955:	8b 45 08             	mov    0x8(%ebp),%eax
80101958:	ff 30                	pushl  (%eax)
8010195a:	e8 0f e8 ff ff       	call   8010016e <bread>
8010195f:	89 c3                	mov    %eax,%ebx
    m = min(n - tot, BSIZE - off%BSIZE);
80101961:	8b 55 10             	mov    0x10(%ebp),%edx
80101964:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010196a:	b8 00 02 00 00       	mov    $0x200,%eax
8010196f:	29 d0                	sub    %edx,%eax
80101971:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101974:	29 f9                	sub    %edi,%ecx
80101976:	89 c6                	mov    %eax,%esi
80101978:	83 c4 10             	add    $0x10,%esp
8010197b:	39 c8                	cmp    %ecx,%eax
8010197d:	76 93                	jbe    80101912 <writei+0x77>
8010197f:	89 ce                	mov    %ecx,%esi
80101981:	eb 8f                	jmp    80101912 <writei+0x77>
  if(n > 0 && off > ip->size){
80101983:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101987:	74 0b                	je     80101994 <writei+0xf9>
80101989:	8b 45 08             	mov    0x8(%ebp),%eax
8010198c:	8b 7d 10             	mov    0x10(%ebp),%edi
8010198f:	39 78 58             	cmp    %edi,0x58(%eax)
80101992:	72 0b                	jb     8010199f <writei+0x104>
  return n;
80101994:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101997:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010199a:	5b                   	pop    %ebx
8010199b:	5e                   	pop    %esi
8010199c:	5f                   	pop    %edi
8010199d:	5d                   	pop    %ebp
8010199e:	c3                   	ret    
    ip->size = off;
8010199f:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
801019a2:	83 ec 0c             	sub    $0xc,%esp
801019a5:	50                   	push   %eax
801019a6:	e8 8a fa ff ff       	call   80101435 <iupdate>
801019ab:	83 c4 10             	add    $0x10,%esp
801019ae:	eb e4                	jmp    80101994 <writei+0xf9>
      return -1;
801019b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019b5:	eb e0                	jmp    80101997 <writei+0xfc>
801019b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019bc:	eb d9                	jmp    80101997 <writei+0xfc>
    return -1;
801019be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019c3:	eb d2                	jmp    80101997 <writei+0xfc>
801019c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019ca:	eb cb                	jmp    80101997 <writei+0xfc>
    return -1;
801019cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019d1:	eb c4                	jmp    80101997 <writei+0xfc>

801019d3 <namecmp>:
{
801019d3:	f3 0f 1e fb          	endbr32 
801019d7:	55                   	push   %ebp
801019d8:	89 e5                	mov    %esp,%ebp
801019da:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801019dd:	6a 0e                	push   $0xe
801019df:	ff 75 0c             	pushl  0xc(%ebp)
801019e2:	ff 75 08             	pushl  0x8(%ebp)
801019e5:	e8 c3 25 00 00       	call   80103fad <strncmp>
}
801019ea:	c9                   	leave  
801019eb:	c3                   	ret    

801019ec <dirlookup>:
{
801019ec:	f3 0f 1e fb          	endbr32 
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 1c             	sub    $0x1c,%esp
801019f9:	8b 75 08             	mov    0x8(%ebp),%esi
801019fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
801019ff:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a04:	75 07                	jne    80101a0d <dirlookup+0x21>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a06:	bb 00 00 00 00       	mov    $0x0,%ebx
80101a0b:	eb 1d                	jmp    80101a2a <dirlookup+0x3e>
    panic("dirlookup not DIR");
80101a0d:	83 ec 0c             	sub    $0xc,%esp
80101a10:	68 e7 6b 10 80       	push   $0x80106be7
80101a15:	e8 3b e9 ff ff       	call   80100355 <panic>
      panic("dirlookup read");
80101a1a:	83 ec 0c             	sub    $0xc,%esp
80101a1d:	68 f9 6b 10 80       	push   $0x80106bf9
80101a22:	e8 2e e9 ff ff       	call   80100355 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a27:	83 c3 10             	add    $0x10,%ebx
80101a2a:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a2d:	76 48                	jbe    80101a77 <dirlookup+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a2f:	6a 10                	push   $0x10
80101a31:	53                   	push   %ebx
80101a32:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101a35:	50                   	push   %eax
80101a36:	56                   	push   %esi
80101a37:	e8 5b fd ff ff       	call   80101797 <readi>
80101a3c:	83 c4 10             	add    $0x10,%esp
80101a3f:	83 f8 10             	cmp    $0x10,%eax
80101a42:	75 d6                	jne    80101a1a <dirlookup+0x2e>
    if(de.inum == 0)
80101a44:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a49:	74 dc                	je     80101a27 <dirlookup+0x3b>
    if(namecmp(name, de.name) == 0){
80101a4b:	83 ec 08             	sub    $0x8,%esp
80101a4e:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a51:	50                   	push   %eax
80101a52:	57                   	push   %edi
80101a53:	e8 7b ff ff ff       	call   801019d3 <namecmp>
80101a58:	83 c4 10             	add    $0x10,%esp
80101a5b:	85 c0                	test   %eax,%eax
80101a5d:	75 c8                	jne    80101a27 <dirlookup+0x3b>
      if(poff)
80101a5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a63:	74 05                	je     80101a6a <dirlookup+0x7e>
        *poff = off;
80101a65:	8b 45 10             	mov    0x10(%ebp),%eax
80101a68:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a6a:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a6e:	8b 06                	mov    (%esi),%eax
80101a70:	e8 1f f7 ff ff       	call   80101194 <iget>
80101a75:	eb 05                	jmp    80101a7c <dirlookup+0x90>
  return 0;
80101a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a7f:	5b                   	pop    %ebx
80101a80:	5e                   	pop    %esi
80101a81:	5f                   	pop    %edi
80101a82:	5d                   	pop    %ebp
80101a83:	c3                   	ret    

80101a84 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a84:	55                   	push   %ebp
80101a85:	89 e5                	mov    %esp,%ebp
80101a87:	57                   	push   %edi
80101a88:	56                   	push   %esi
80101a89:	53                   	push   %ebx
80101a8a:	83 ec 1c             	sub    $0x1c,%esp
80101a8d:	89 c3                	mov    %eax,%ebx
80101a8f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101a92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a95:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a98:	74 17                	je     80101ab1 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a9a:	e8 d6 17 00 00       	call   80103275 <myproc>
80101a9f:	83 ec 0c             	sub    $0xc,%esp
80101aa2:	ff 70 68             	pushl  0x68(%eax)
80101aa5:	e8 ba fa ff ff       	call   80101564 <idup>
80101aaa:	89 c6                	mov    %eax,%esi
80101aac:	83 c4 10             	add    $0x10,%esp
80101aaf:	eb 53                	jmp    80101b04 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101ab1:	ba 01 00 00 00       	mov    $0x1,%edx
80101ab6:	b8 01 00 00 00       	mov    $0x1,%eax
80101abb:	e8 d4 f6 ff ff       	call   80101194 <iget>
80101ac0:	89 c6                	mov    %eax,%esi
80101ac2:	eb 40                	jmp    80101b04 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101ac4:	83 ec 0c             	sub    $0xc,%esp
80101ac7:	56                   	push   %esi
80101ac8:	e8 78 fc ff ff       	call   80101745 <iunlockput>
      return 0;
80101acd:	83 c4 10             	add    $0x10,%esp
80101ad0:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ad5:	89 f0                	mov    %esi,%eax
80101ad7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ada:	5b                   	pop    %ebx
80101adb:	5e                   	pop    %esi
80101adc:	5f                   	pop    %edi
80101add:	5d                   	pop    %ebp
80101ade:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101adf:	83 ec 04             	sub    $0x4,%esp
80101ae2:	6a 00                	push   $0x0
80101ae4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ae7:	56                   	push   %esi
80101ae8:	e8 ff fe ff ff       	call   801019ec <dirlookup>
80101aed:	89 c7                	mov    %eax,%edi
80101aef:	83 c4 10             	add    $0x10,%esp
80101af2:	85 c0                	test   %eax,%eax
80101af4:	74 4a                	je     80101b40 <namex+0xbc>
    iunlockput(ip);
80101af6:	83 ec 0c             	sub    $0xc,%esp
80101af9:	56                   	push   %esi
80101afa:	e8 46 fc ff ff       	call   80101745 <iunlockput>
80101aff:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101b02:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101b04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b07:	89 d8                	mov    %ebx,%eax
80101b09:	e8 46 f4 ff ff       	call   80100f54 <skipelem>
80101b0e:	89 c3                	mov    %eax,%ebx
80101b10:	85 c0                	test   %eax,%eax
80101b12:	74 3c                	je     80101b50 <namex+0xcc>
    ilock(ip);
80101b14:	83 ec 0c             	sub    $0xc,%esp
80101b17:	56                   	push   %esi
80101b18:	e8 79 fa ff ff       	call   80101596 <ilock>
    if(ip->type != T_DIR){
80101b1d:	83 c4 10             	add    $0x10,%esp
80101b20:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b25:	75 9d                	jne    80101ac4 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101b27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b2b:	74 b2                	je     80101adf <namex+0x5b>
80101b2d:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b30:	75 ad                	jne    80101adf <namex+0x5b>
      iunlock(ip);
80101b32:	83 ec 0c             	sub    $0xc,%esp
80101b35:	56                   	push   %esi
80101b36:	e8 1f fb ff ff       	call   8010165a <iunlock>
      return ip;
80101b3b:	83 c4 10             	add    $0x10,%esp
80101b3e:	eb 95                	jmp    80101ad5 <namex+0x51>
      iunlockput(ip);
80101b40:	83 ec 0c             	sub    $0xc,%esp
80101b43:	56                   	push   %esi
80101b44:	e8 fc fb ff ff       	call   80101745 <iunlockput>
      return 0;
80101b49:	83 c4 10             	add    $0x10,%esp
80101b4c:	89 fe                	mov    %edi,%esi
80101b4e:	eb 85                	jmp    80101ad5 <namex+0x51>
  if(nameiparent){
80101b50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b54:	0f 84 7b ff ff ff    	je     80101ad5 <namex+0x51>
    iput(ip);
80101b5a:	83 ec 0c             	sub    $0xc,%esp
80101b5d:	56                   	push   %esi
80101b5e:	e8 40 fb ff ff       	call   801016a3 <iput>
    return 0;
80101b63:	83 c4 10             	add    $0x10,%esp
80101b66:	89 de                	mov    %ebx,%esi
80101b68:	e9 68 ff ff ff       	jmp    80101ad5 <namex+0x51>

80101b6d <dirlink>:
{
80101b6d:	f3 0f 1e fb          	endbr32 
80101b71:	55                   	push   %ebp
80101b72:	89 e5                	mov    %esp,%ebp
80101b74:	57                   	push   %edi
80101b75:	56                   	push   %esi
80101b76:	53                   	push   %ebx
80101b77:	83 ec 20             	sub    $0x20,%esp
80101b7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101b80:	6a 00                	push   $0x0
80101b82:	57                   	push   %edi
80101b83:	53                   	push   %ebx
80101b84:	e8 63 fe ff ff       	call   801019ec <dirlookup>
80101b89:	83 c4 10             	add    $0x10,%esp
80101b8c:	85 c0                	test   %eax,%eax
80101b8e:	75 07                	jne    80101b97 <dirlink+0x2a>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b90:	b8 00 00 00 00       	mov    $0x0,%eax
80101b95:	eb 23                	jmp    80101bba <dirlink+0x4d>
    iput(ip);
80101b97:	83 ec 0c             	sub    $0xc,%esp
80101b9a:	50                   	push   %eax
80101b9b:	e8 03 fb ff ff       	call   801016a3 <iput>
    return -1;
80101ba0:	83 c4 10             	add    $0x10,%esp
80101ba3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba8:	eb 63                	jmp    80101c0d <dirlink+0xa0>
      panic("dirlink read");
80101baa:	83 ec 0c             	sub    $0xc,%esp
80101bad:	68 08 6c 10 80       	push   $0x80106c08
80101bb2:	e8 9e e7 ff ff       	call   80100355 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8d 46 10             	lea    0x10(%esi),%eax
80101bba:	89 c6                	mov    %eax,%esi
80101bbc:	39 43 58             	cmp    %eax,0x58(%ebx)
80101bbf:	76 1c                	jbe    80101bdd <dirlink+0x70>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bc1:	6a 10                	push   $0x10
80101bc3:	50                   	push   %eax
80101bc4:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101bc7:	50                   	push   %eax
80101bc8:	53                   	push   %ebx
80101bc9:	e8 c9 fb ff ff       	call   80101797 <readi>
80101bce:	83 c4 10             	add    $0x10,%esp
80101bd1:	83 f8 10             	cmp    $0x10,%eax
80101bd4:	75 d4                	jne    80101baa <dirlink+0x3d>
    if(de.inum == 0)
80101bd6:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bdb:	75 da                	jne    80101bb7 <dirlink+0x4a>
  strncpy(de.name, name, DIRSIZ);
80101bdd:	83 ec 04             	sub    $0x4,%esp
80101be0:	6a 0e                	push   $0xe
80101be2:	57                   	push   %edi
80101be3:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101be6:	8d 45 da             	lea    -0x26(%ebp),%eax
80101be9:	50                   	push   %eax
80101bea:	e8 f8 23 00 00       	call   80103fe7 <strncpy>
  de.inum = inum;
80101bef:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf6:	6a 10                	push   $0x10
80101bf8:	56                   	push   %esi
80101bf9:	57                   	push   %edi
80101bfa:	53                   	push   %ebx
80101bfb:	e8 9b fc ff ff       	call   8010189b <writei>
80101c00:	83 c4 20             	add    $0x20,%esp
80101c03:	83 f8 10             	cmp    $0x10,%eax
80101c06:	75 0d                	jne    80101c15 <dirlink+0xa8>
  return 0;
80101c08:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c10:	5b                   	pop    %ebx
80101c11:	5e                   	pop    %esi
80101c12:	5f                   	pop    %edi
80101c13:	5d                   	pop    %ebp
80101c14:	c3                   	ret    
    panic("dirlink");
80101c15:	83 ec 0c             	sub    $0xc,%esp
80101c18:	68 00 72 10 80       	push   $0x80107200
80101c1d:	e8 33 e7 ff ff       	call   80100355 <panic>

80101c22 <namei>:

struct inode*
namei(char *path)
{
80101c22:	f3 0f 1e fb          	endbr32 
80101c26:	55                   	push   %ebp
80101c27:	89 e5                	mov    %esp,%ebp
80101c29:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c2c:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c2f:	ba 00 00 00 00       	mov    $0x0,%edx
80101c34:	8b 45 08             	mov    0x8(%ebp),%eax
80101c37:	e8 48 fe ff ff       	call   80101a84 <namex>
}
80101c3c:	c9                   	leave  
80101c3d:	c3                   	ret    

80101c3e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c3e:	f3 0f 1e fb          	endbr32 
80101c42:	55                   	push   %ebp
80101c43:	89 e5                	mov    %esp,%ebp
80101c45:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c4b:	ba 01 00 00 00       	mov    $0x1,%edx
80101c50:	8b 45 08             	mov    0x8(%ebp),%eax
80101c53:	e8 2c fe ff ff       	call   80101a84 <namex>
}
80101c58:	c9                   	leave  
80101c59:	c3                   	ret    

80101c5a <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101c5a:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c5c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c61:	ec                   	in     (%dx),%al
80101c62:	88 c2                	mov    %al,%dl
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c64:	83 e0 c0             	and    $0xffffffc0,%eax
80101c67:	3c 40                	cmp    $0x40,%al
80101c69:	75 f1                	jne    80101c5c <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c6b:	85 c9                	test   %ecx,%ecx
80101c6d:	74 0a                	je     80101c79 <idewait+0x1f>
80101c6f:	f6 c2 21             	test   $0x21,%dl
80101c72:	75 08                	jne    80101c7c <idewait+0x22>
    return -1;
  return 0;
80101c74:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101c79:	89 c8                	mov    %ecx,%eax
80101c7b:	c3                   	ret    
    return -1;
80101c7c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101c81:	eb f6                	jmp    80101c79 <idewait+0x1f>

80101c83 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101c83:	55                   	push   %ebp
80101c84:	89 e5                	mov    %esp,%ebp
80101c86:	56                   	push   %esi
80101c87:	53                   	push   %ebx
  if(b == 0)
80101c88:	85 c0                	test   %eax,%eax
80101c8a:	0f 84 87 00 00 00    	je     80101d17 <idestart+0x94>
80101c90:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c92:	8b 58 08             	mov    0x8(%eax),%ebx
80101c95:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101c9b:	0f 87 83 00 00 00    	ja     80101d24 <idestart+0xa1>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101ca1:	b8 00 00 00 00       	mov    $0x0,%eax
80101ca6:	e8 af ff ff ff       	call   80101c5a <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cab:	b0 00                	mov    $0x0,%al
80101cad:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101cb2:	ee                   	out    %al,(%dx)
80101cb3:	b0 01                	mov    $0x1,%al
80101cb5:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101cba:	ee                   	out    %al,(%dx)
80101cbb:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cc0:	88 d8                	mov    %bl,%al
80101cc2:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cc3:	89 d8                	mov    %ebx,%eax
80101cc5:	c1 f8 08             	sar    $0x8,%eax
80101cc8:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101ccd:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101cce:	89 d8                	mov    %ebx,%eax
80101cd0:	c1 f8 10             	sar    $0x10,%eax
80101cd3:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101cd8:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101cd9:	8a 46 04             	mov    0x4(%esi),%al
80101cdc:	c1 e0 04             	shl    $0x4,%eax
80101cdf:	83 e0 10             	and    $0x10,%eax
80101ce2:	c1 fb 18             	sar    $0x18,%ebx
80101ce5:	83 e3 0f             	and    $0xf,%ebx
80101ce8:	09 d8                	or     %ebx,%eax
80101cea:	83 c8 e0             	or     $0xffffffe0,%eax
80101ced:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101cf2:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101cf3:	f6 06 04             	testb  $0x4,(%esi)
80101cf6:	74 39                	je     80101d31 <idestart+0xae>
80101cf8:	b0 30                	mov    $0x30,%al
80101cfa:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cff:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101d00:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101d03:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d08:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d0d:	fc                   	cld    
80101d0e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d13:	5b                   	pop    %ebx
80101d14:	5e                   	pop    %esi
80101d15:	5d                   	pop    %ebp
80101d16:	c3                   	ret    
    panic("idestart");
80101d17:	83 ec 0c             	sub    $0xc,%esp
80101d1a:	68 6b 6c 10 80       	push   $0x80106c6b
80101d1f:	e8 31 e6 ff ff       	call   80100355 <panic>
    panic("incorrect blockno");
80101d24:	83 ec 0c             	sub    $0xc,%esp
80101d27:	68 74 6c 10 80       	push   $0x80106c74
80101d2c:	e8 24 e6 ff ff       	call   80100355 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d31:	b0 20                	mov    $0x20,%al
80101d33:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d38:	ee                   	out    %al,(%dx)
}
80101d39:	eb d5                	jmp    80101d10 <idestart+0x8d>

80101d3b <ideinit>:
{
80101d3b:	f3 0f 1e fb          	endbr32 
80101d3f:	55                   	push   %ebp
80101d40:	89 e5                	mov    %esp,%ebp
80101d42:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d45:	68 86 6c 10 80       	push   $0x80106c86
80101d4a:	68 80 a5 10 80       	push   $0x8010a580
80101d4f:	e8 70 1f 00 00       	call   80103cc4 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d54:	83 c4 08             	add    $0x8,%esp
80101d57:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101d5c:	48                   	dec    %eax
80101d5d:	50                   	push   %eax
80101d5e:	6a 0e                	push   $0xe
80101d60:	e8 50 02 00 00       	call   80101fb5 <ioapicenable>
  idewait(0);
80101d65:	b8 00 00 00 00       	mov    $0x0,%eax
80101d6a:	e8 eb fe ff ff       	call   80101c5a <idewait>
80101d6f:	b0 f0                	mov    $0xf0,%al
80101d71:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d76:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101d77:	83 c4 10             	add    $0x10,%esp
80101d7a:	b9 00 00 00 00       	mov    $0x0,%ecx
80101d7f:	eb 01                	jmp    80101d82 <ideinit+0x47>
80101d81:	41                   	inc    %ecx
80101d82:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101d88:	7f 14                	jg     80101d9e <ideinit+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d8a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d8f:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101d90:	84 c0                	test   %al,%al
80101d92:	74 ed                	je     80101d81 <ideinit+0x46>
      havedisk1 = 1;
80101d94:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101d9b:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d9e:	b0 e0                	mov    $0xe0,%al
80101da0:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101da5:	ee                   	out    %al,(%dx)
}
80101da6:	c9                   	leave  
80101da7:	c3                   	ret    

80101da8 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101da8:	f3 0f 1e fb          	endbr32 
80101dac:	55                   	push   %ebp
80101dad:	89 e5                	mov    %esp,%ebp
80101daf:	57                   	push   %edi
80101db0:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101db1:	83 ec 0c             	sub    $0xc,%esp
80101db4:	68 80 a5 10 80       	push   $0x8010a580
80101db9:	e8 51 20 00 00       	call   80103e0f <acquire>

  if((b = idequeue) == 0){
80101dbe:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101dc4:	83 c4 10             	add    $0x10,%esp
80101dc7:	85 db                	test   %ebx,%ebx
80101dc9:	74 48                	je     80101e13 <ideintr+0x6b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101dcb:	8b 43 58             	mov    0x58(%ebx),%eax
80101dce:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101dd3:	f6 03 04             	testb  $0x4,(%ebx)
80101dd6:	74 4d                	je     80101e25 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101dd8:	8b 03                	mov    (%ebx),%eax
80101dda:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101ddd:	83 e0 fb             	and    $0xfffffffb,%eax
80101de0:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101de2:	83 ec 0c             	sub    $0xc,%esp
80101de5:	53                   	push   %ebx
80101de6:	e8 89 1b 00 00       	call   80103974 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101deb:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101df0:	83 c4 10             	add    $0x10,%esp
80101df3:	85 c0                	test   %eax,%eax
80101df5:	74 05                	je     80101dfc <ideintr+0x54>
    idestart(idequeue);
80101df7:	e8 87 fe ff ff       	call   80101c83 <idestart>

  release(&idelock);
80101dfc:	83 ec 0c             	sub    $0xc,%esp
80101dff:	68 80 a5 10 80       	push   $0x8010a580
80101e04:	e8 6f 20 00 00       	call   80103e78 <release>
80101e09:	83 c4 10             	add    $0x10,%esp
}
80101e0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e0f:	5b                   	pop    %ebx
80101e10:	5f                   	pop    %edi
80101e11:	5d                   	pop    %ebp
80101e12:	c3                   	ret    
    release(&idelock);
80101e13:	83 ec 0c             	sub    $0xc,%esp
80101e16:	68 80 a5 10 80       	push   $0x8010a580
80101e1b:	e8 58 20 00 00       	call   80103e78 <release>
    return;
80101e20:	83 c4 10             	add    $0x10,%esp
80101e23:	eb e7                	jmp    80101e0c <ideintr+0x64>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e25:	b8 01 00 00 00       	mov    $0x1,%eax
80101e2a:	e8 2b fe ff ff       	call   80101c5a <idewait>
80101e2f:	85 c0                	test   %eax,%eax
80101e31:	78 a5                	js     80101dd8 <ideintr+0x30>
    insl(0x1f0, b->data, BSIZE/4);
80101e33:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e36:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e3b:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e40:	fc                   	cld    
80101e41:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101e43:	eb 93                	jmp    80101dd8 <ideintr+0x30>

80101e45 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e45:	f3 0f 1e fb          	endbr32 
80101e49:	55                   	push   %ebp
80101e4a:	89 e5                	mov    %esp,%ebp
80101e4c:	53                   	push   %ebx
80101e4d:	83 ec 10             	sub    $0x10,%esp
80101e50:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e53:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e56:	50                   	push   %eax
80101e57:	e8 16 1e 00 00       	call   80103c72 <holdingsleep>
80101e5c:	83 c4 10             	add    $0x10,%esp
80101e5f:	85 c0                	test   %eax,%eax
80101e61:	74 37                	je     80101e9a <iderw+0x55>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101e63:	8b 03                	mov    (%ebx),%eax
80101e65:	83 e0 06             	and    $0x6,%eax
80101e68:	83 f8 02             	cmp    $0x2,%eax
80101e6b:	74 3a                	je     80101ea7 <iderw+0x62>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101e6d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101e71:	74 09                	je     80101e7c <iderw+0x37>
80101e73:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101e7a:	74 38                	je     80101eb4 <iderw+0x6f>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101e7c:	83 ec 0c             	sub    $0xc,%esp
80101e7f:	68 80 a5 10 80       	push   $0x8010a580
80101e84:	e8 86 1f 00 00       	call   80103e0f <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101e89:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e90:	83 c4 10             	add    $0x10,%esp
80101e93:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101e98:	eb 2a                	jmp    80101ec4 <iderw+0x7f>
    panic("iderw: buf not locked");
80101e9a:	83 ec 0c             	sub    $0xc,%esp
80101e9d:	68 8a 6c 10 80       	push   $0x80106c8a
80101ea2:	e8 ae e4 ff ff       	call   80100355 <panic>
    panic("iderw: nothing to do");
80101ea7:	83 ec 0c             	sub    $0xc,%esp
80101eaa:	68 a0 6c 10 80       	push   $0x80106ca0
80101eaf:	e8 a1 e4 ff ff       	call   80100355 <panic>
    panic("iderw: ide disk 1 not present");
80101eb4:	83 ec 0c             	sub    $0xc,%esp
80101eb7:	68 b5 6c 10 80       	push   $0x80106cb5
80101ebc:	e8 94 e4 ff ff       	call   80100355 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101ec1:	8d 50 58             	lea    0x58(%eax),%edx
80101ec4:	8b 02                	mov    (%edx),%eax
80101ec6:	85 c0                	test   %eax,%eax
80101ec8:	75 f7                	jne    80101ec1 <iderw+0x7c>
    ;
  *pp = b;
80101eca:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101ecc:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101ed2:	75 1a                	jne    80101eee <iderw+0xa9>
    idestart(b);
80101ed4:	89 d8                	mov    %ebx,%eax
80101ed6:	e8 a8 fd ff ff       	call   80101c83 <idestart>
80101edb:	eb 11                	jmp    80101eee <iderw+0xa9>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101edd:	83 ec 08             	sub    $0x8,%esp
80101ee0:	68 80 a5 10 80       	push   $0x8010a580
80101ee5:	53                   	push   %ebx
80101ee6:	e8 0f 19 00 00       	call   801037fa <sleep>
80101eeb:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101eee:	8b 03                	mov    (%ebx),%eax
80101ef0:	83 e0 06             	and    $0x6,%eax
80101ef3:	83 f8 02             	cmp    $0x2,%eax
80101ef6:	75 e5                	jne    80101edd <iderw+0x98>
  }


  release(&idelock);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 80 a5 10 80       	push   $0x8010a580
80101f00:	e8 73 1f 00 00       	call   80103e78 <release>
}
80101f05:	83 c4 10             	add    $0x10,%esp
80101f08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f0b:	c9                   	leave  
80101f0c:	c3                   	ret    

80101f0d <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101f0d:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80101f13:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101f15:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f1a:	8b 40 10             	mov    0x10(%eax),%eax
}
80101f1d:	c3                   	ret    

80101f1e <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101f1e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101f24:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101f26:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f2b:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f2e:	c3                   	ret    

80101f2f <ioapicinit>:

void
ioapicinit(void)
{
80101f2f:	f3 0f 1e fb          	endbr32 
80101f33:	55                   	push   %ebp
80101f34:	89 e5                	mov    %esp,%ebp
80101f36:	57                   	push   %edi
80101f37:	56                   	push   %esi
80101f38:	53                   	push   %ebx
80101f39:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f3c:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101f43:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f46:	b8 01 00 00 00       	mov    $0x1,%eax
80101f4b:	e8 bd ff ff ff       	call   80101f0d <ioapicread>
80101f50:	c1 e8 10             	shr    $0x10,%eax
80101f53:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f56:	b8 00 00 00 00       	mov    $0x0,%eax
80101f5b:	e8 ad ff ff ff       	call   80101f0d <ioapicread>
80101f60:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101f63:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80101f6a:	39 c2                	cmp    %eax,%edx
80101f6c:	75 2d                	jne    80101f9b <ioapicinit+0x6c>
{
80101f6e:	bb 00 00 00 00       	mov    $0x0,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80101f73:	39 fb                	cmp    %edi,%ebx
80101f75:	7f 36                	jg     80101fad <ioapicinit+0x7e>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101f77:	8d 53 20             	lea    0x20(%ebx),%edx
80101f7a:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101f80:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101f84:	89 f0                	mov    %esi,%eax
80101f86:	e8 93 ff ff ff       	call   80101f1e <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101f8b:	8d 46 01             	lea    0x1(%esi),%eax
80101f8e:	ba 00 00 00 00       	mov    $0x0,%edx
80101f93:	e8 86 ff ff ff       	call   80101f1e <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101f98:	43                   	inc    %ebx
80101f99:	eb d8                	jmp    80101f73 <ioapicinit+0x44>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101f9b:	83 ec 0c             	sub    $0xc,%esp
80101f9e:	68 d4 6c 10 80       	push   $0x80106cd4
80101fa3:	e8 55 e6 ff ff       	call   801005fd <cprintf>
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	eb c1                	jmp    80101f6e <ioapicinit+0x3f>
  }
}
80101fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb0:	5b                   	pop    %ebx
80101fb1:	5e                   	pop    %esi
80101fb2:	5f                   	pop    %edi
80101fb3:	5d                   	pop    %ebp
80101fb4:	c3                   	ret    

80101fb5 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101fb5:	f3 0f 1e fb          	endbr32 
80101fb9:	55                   	push   %ebp
80101fba:	89 e5                	mov    %esp,%ebp
80101fbc:	53                   	push   %ebx
80101fbd:	83 ec 04             	sub    $0x4,%esp
80101fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101fc3:	8d 50 20             	lea    0x20(%eax),%edx
80101fc6:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101fca:	89 d8                	mov    %ebx,%eax
80101fcc:	e8 4d ff ff ff       	call   80101f1e <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fd4:	c1 e2 18             	shl    $0x18,%edx
80101fd7:	8d 43 01             	lea    0x1(%ebx),%eax
80101fda:	e8 3f ff ff ff       	call   80101f1e <ioapicwrite>
}
80101fdf:	83 c4 04             	add    $0x4,%esp
80101fe2:	5b                   	pop    %ebx
80101fe3:	5d                   	pop    %ebp
80101fe4:	c3                   	ret    

80101fe5 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101fe5:	f3 0f 1e fb          	endbr32 
80101fe9:	55                   	push   %ebp
80101fea:	89 e5                	mov    %esp,%ebp
80101fec:	53                   	push   %ebx
80101fed:	83 ec 04             	sub    $0x4,%esp
80101ff0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101ff3:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101ff9:	75 4c                	jne    80102047 <kfree+0x62>
80101ffb:	81 fb a8 57 11 80    	cmp    $0x801157a8,%ebx
80102001:	72 44                	jb     80102047 <kfree+0x62>
80102003:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102009:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
8010200e:	77 37                	ja     80102047 <kfree+0x62>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102010:	83 ec 04             	sub    $0x4,%esp
80102013:	68 00 10 00 00       	push   $0x1000
80102018:	6a 01                	push   $0x1
8010201a:	53                   	push   %ebx
8010201b:	e8 a3 1e 00 00       	call   80103ec3 <memset>

  if(kmem.use_lock)
80102020:	83 c4 10             	add    $0x10,%esp
80102023:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010202a:	75 28                	jne    80102054 <kfree+0x6f>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010202c:	a1 78 26 11 80       	mov    0x80112678,%eax
80102031:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102033:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102039:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102040:	75 24                	jne    80102066 <kfree+0x81>
    release(&kmem.lock);
}
80102042:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102045:	c9                   	leave  
80102046:	c3                   	ret    
    panic("kfree");
80102047:	83 ec 0c             	sub    $0xc,%esp
8010204a:	68 06 6d 10 80       	push   $0x80106d06
8010204f:	e8 01 e3 ff ff       	call   80100355 <panic>
    acquire(&kmem.lock);
80102054:	83 ec 0c             	sub    $0xc,%esp
80102057:	68 40 26 11 80       	push   $0x80112640
8010205c:	e8 ae 1d 00 00       	call   80103e0f <acquire>
80102061:	83 c4 10             	add    $0x10,%esp
80102064:	eb c6                	jmp    8010202c <kfree+0x47>
    release(&kmem.lock);
80102066:	83 ec 0c             	sub    $0xc,%esp
80102069:	68 40 26 11 80       	push   $0x80112640
8010206e:	e8 05 1e 00 00       	call   80103e78 <release>
80102073:	83 c4 10             	add    $0x10,%esp
}
80102076:	eb ca                	jmp    80102042 <kfree+0x5d>

80102078 <freerange>:
{
80102078:	f3 0f 1e fb          	endbr32 
8010207c:	55                   	push   %ebp
8010207d:	89 e5                	mov    %esp,%ebp
8010207f:	56                   	push   %esi
80102080:	53                   	push   %ebx
80102081:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102084:	8b 45 08             	mov    0x8(%ebp),%eax
80102087:	05 ff 0f 00 00       	add    $0xfff,%eax
8010208c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102091:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80102097:	39 de                	cmp    %ebx,%esi
80102099:	77 10                	ja     801020ab <freerange+0x33>
    kfree(p);
8010209b:	83 ec 0c             	sub    $0xc,%esp
8010209e:	50                   	push   %eax
8010209f:	e8 41 ff ff ff       	call   80101fe5 <kfree>
801020a4:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020a7:	89 f0                	mov    %esi,%eax
801020a9:	eb e6                	jmp    80102091 <freerange+0x19>
}
801020ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020ae:	5b                   	pop    %ebx
801020af:	5e                   	pop    %esi
801020b0:	5d                   	pop    %ebp
801020b1:	c3                   	ret    

801020b2 <kinit1>:
{
801020b2:	f3 0f 1e fb          	endbr32 
801020b6:	55                   	push   %ebp
801020b7:	89 e5                	mov    %esp,%ebp
801020b9:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
801020bc:	68 0c 6d 10 80       	push   $0x80106d0c
801020c1:	68 40 26 11 80       	push   $0x80112640
801020c6:	e8 f9 1b 00 00       	call   80103cc4 <initlock>
  kmem.use_lock = 0;
801020cb:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801020d2:	00 00 00 
  freerange(vstart, vend);
801020d5:	83 c4 08             	add    $0x8,%esp
801020d8:	ff 75 0c             	pushl  0xc(%ebp)
801020db:	ff 75 08             	pushl  0x8(%ebp)
801020de:	e8 95 ff ff ff       	call   80102078 <freerange>
}
801020e3:	83 c4 10             	add    $0x10,%esp
801020e6:	c9                   	leave  
801020e7:	c3                   	ret    

801020e8 <kinit2>:
{
801020e8:	f3 0f 1e fb          	endbr32 
801020ec:	55                   	push   %ebp
801020ed:	89 e5                	mov    %esp,%ebp
801020ef:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
801020f2:	ff 75 0c             	pushl  0xc(%ebp)
801020f5:	ff 75 08             	pushl  0x8(%ebp)
801020f8:	e8 7b ff ff ff       	call   80102078 <freerange>
  kmem.use_lock = 1;
801020fd:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102104:	00 00 00 
}
80102107:	83 c4 10             	add    $0x10,%esp
8010210a:	c9                   	leave  
8010210b:	c3                   	ret    

8010210c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010210c:	f3 0f 1e fb          	endbr32 
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102117:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010211e:	75 21                	jne    80102141 <kalloc+0x35>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102120:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102126:	85 db                	test   %ebx,%ebx
80102128:	74 07                	je     80102131 <kalloc+0x25>
    kmem.freelist = r->next;
8010212a:	8b 03                	mov    (%ebx),%eax
8010212c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
80102131:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102138:	75 19                	jne    80102153 <kalloc+0x47>
    release(&kmem.lock);
  return (char*)r;
}
8010213a:	89 d8                	mov    %ebx,%eax
8010213c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010213f:	c9                   	leave  
80102140:	c3                   	ret    
    acquire(&kmem.lock);
80102141:	83 ec 0c             	sub    $0xc,%esp
80102144:	68 40 26 11 80       	push   $0x80112640
80102149:	e8 c1 1c 00 00       	call   80103e0f <acquire>
8010214e:	83 c4 10             	add    $0x10,%esp
80102151:	eb cd                	jmp    80102120 <kalloc+0x14>
    release(&kmem.lock);
80102153:	83 ec 0c             	sub    $0xc,%esp
80102156:	68 40 26 11 80       	push   $0x80112640
8010215b:	e8 18 1d 00 00       	call   80103e78 <release>
80102160:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102163:	eb d5                	jmp    8010213a <kalloc+0x2e>

80102165 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102165:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102169:	ba 64 00 00 00       	mov    $0x64,%edx
8010216e:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010216f:	a8 01                	test   $0x1,%al
80102171:	0f 84 ac 00 00 00    	je     80102223 <kbdgetc+0xbe>
80102177:	ba 60 00 00 00       	mov    $0x60,%edx
8010217c:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010217d:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102180:	3c e0                	cmp    $0xe0,%al
80102182:	74 5b                	je     801021df <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102184:	84 c0                	test   %al,%al
80102186:	78 64                	js     801021ec <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102188:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
8010218e:	f6 c1 40             	test   $0x40,%cl
80102191:	74 0f                	je     801021a2 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102193:	83 c8 80             	or     $0xffffff80,%eax
80102196:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
80102199:	83 e1 bf             	and    $0xffffffbf,%ecx
8010219c:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
801021a2:	0f b6 8a 40 6e 10 80 	movzbl -0x7fef91c0(%edx),%ecx
801021a9:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
801021af:	0f b6 82 40 6d 10 80 	movzbl -0x7fef92c0(%edx),%eax
801021b6:	31 c1                	xor    %eax,%ecx
801021b8:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801021be:	89 c8                	mov    %ecx,%eax
801021c0:	83 e0 03             	and    $0x3,%eax
801021c3:	8b 04 85 20 6d 10 80 	mov    -0x7fef92e0(,%eax,4),%eax
801021ca:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801021ce:	f6 c1 08             	test   $0x8,%cl
801021d1:	74 55                	je     80102228 <kbdgetc+0xc3>
    if('a' <= c && c <= 'z')
801021d3:	8d 50 9f             	lea    -0x61(%eax),%edx
801021d6:	83 fa 19             	cmp    $0x19,%edx
801021d9:	77 3c                	ja     80102217 <kbdgetc+0xb2>
      c += 'A' - 'a';
801021db:	83 e8 20             	sub    $0x20,%eax
801021de:	c3                   	ret    
    shift |= E0ESC;
801021df:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801021e6:	b8 00 00 00 00       	mov    $0x0,%eax
801021eb:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801021ec:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
801021f2:	f6 c1 40             	test   $0x40,%cl
801021f5:	75 05                	jne    801021fc <kbdgetc+0x97>
801021f7:	89 c2                	mov    %eax,%edx
801021f9:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801021fc:	8a 82 40 6e 10 80    	mov    -0x7fef91c0(%edx),%al
80102202:	83 c8 40             	or     $0x40,%eax
80102205:	0f b6 c0             	movzbl %al,%eax
80102208:	f7 d0                	not    %eax
8010220a:	21 c8                	and    %ecx,%eax
8010220c:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
80102211:	b8 00 00 00 00       	mov    $0x0,%eax
80102216:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102217:	8d 50 bf             	lea    -0x41(%eax),%edx
8010221a:	83 fa 19             	cmp    $0x19,%edx
8010221d:	77 09                	ja     80102228 <kbdgetc+0xc3>
      c += 'a' - 'A';
8010221f:	83 c0 20             	add    $0x20,%eax
  }
  return c;
80102222:	c3                   	ret    
    return -1;
80102223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102228:	c3                   	ret    

80102229 <kbdintr>:

void
kbdintr(void)
{
80102229:	f3 0f 1e fb          	endbr32 
8010222d:	55                   	push   %ebp
8010222e:	89 e5                	mov    %esp,%ebp
80102230:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102233:	68 65 21 10 80       	push   $0x80102165
80102238:	e8 e9 e4 ff ff       	call   80100726 <consoleintr>
}
8010223d:	83 c4 10             	add    $0x10,%esp
80102240:	c9                   	leave  
80102241:	c3                   	ret    

80102242 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102242:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
80102248:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010224b:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010224d:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102252:	8b 40 20             	mov    0x20(%eax),%eax
}
80102255:	c3                   	ret    

80102256 <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102256:	ba 70 00 00 00       	mov    $0x70,%edx
8010225b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010225c:	ba 71 00 00 00       	mov    $0x71,%edx
80102261:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102262:	0f b6 c0             	movzbl %al,%eax
}
80102265:	c3                   	ret    

80102266 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
80102266:	55                   	push   %ebp
80102267:	89 e5                	mov    %esp,%ebp
80102269:	53                   	push   %ebx
8010226a:	83 ec 04             	sub    $0x4,%esp
8010226d:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
8010226f:	b8 00 00 00 00       	mov    $0x0,%eax
80102274:	e8 dd ff ff ff       	call   80102256 <cmos_read>
80102279:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
8010227b:	b8 02 00 00 00       	mov    $0x2,%eax
80102280:	e8 d1 ff ff ff       	call   80102256 <cmos_read>
80102285:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
80102288:	b8 04 00 00 00       	mov    $0x4,%eax
8010228d:	e8 c4 ff ff ff       	call   80102256 <cmos_read>
80102292:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
80102295:	b8 07 00 00 00       	mov    $0x7,%eax
8010229a:	e8 b7 ff ff ff       	call   80102256 <cmos_read>
8010229f:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
801022a2:	b8 08 00 00 00       	mov    $0x8,%eax
801022a7:	e8 aa ff ff ff       	call   80102256 <cmos_read>
801022ac:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
801022af:	b8 09 00 00 00       	mov    $0x9,%eax
801022b4:	e8 9d ff ff ff       	call   80102256 <cmos_read>
801022b9:	89 43 14             	mov    %eax,0x14(%ebx)
}
801022bc:	83 c4 04             	add    $0x4,%esp
801022bf:	5b                   	pop    %ebx
801022c0:	5d                   	pop    %ebp
801022c1:	c3                   	ret    

801022c2 <lapicinit>:
{
801022c2:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801022c6:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
801022cd:	0f 84 fe 00 00 00    	je     801023d1 <lapicinit+0x10f>
{
801022d3:	55                   	push   %ebp
801022d4:	89 e5                	mov    %esp,%ebp
801022d6:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801022d9:	ba 3f 01 00 00       	mov    $0x13f,%edx
801022de:	b8 3c 00 00 00       	mov    $0x3c,%eax
801022e3:	e8 5a ff ff ff       	call   80102242 <lapicw>
  lapicw(TDCR, X1);
801022e8:	ba 0b 00 00 00       	mov    $0xb,%edx
801022ed:	b8 f8 00 00 00       	mov    $0xf8,%eax
801022f2:	e8 4b ff ff ff       	call   80102242 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801022f7:	ba 20 00 02 00       	mov    $0x20020,%edx
801022fc:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102301:	e8 3c ff ff ff       	call   80102242 <lapicw>
  lapicw(TICR, 10000000);
80102306:	ba 80 96 98 00       	mov    $0x989680,%edx
8010230b:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102310:	e8 2d ff ff ff       	call   80102242 <lapicw>
  lapicw(LINT0, MASKED);
80102315:	ba 00 00 01 00       	mov    $0x10000,%edx
8010231a:	b8 d4 00 00 00       	mov    $0xd4,%eax
8010231f:	e8 1e ff ff ff       	call   80102242 <lapicw>
  lapicw(LINT1, MASKED);
80102324:	ba 00 00 01 00       	mov    $0x10000,%edx
80102329:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010232e:	e8 0f ff ff ff       	call   80102242 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102333:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102338:	8b 40 30             	mov    0x30(%eax),%eax
8010233b:	c1 e8 10             	shr    $0x10,%eax
8010233e:	a8 fc                	test   $0xfc,%al
80102340:	75 7b                	jne    801023bd <lapicinit+0xfb>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102342:	ba 33 00 00 00       	mov    $0x33,%edx
80102347:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010234c:	e8 f1 fe ff ff       	call   80102242 <lapicw>
  lapicw(ESR, 0);
80102351:	ba 00 00 00 00       	mov    $0x0,%edx
80102356:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010235b:	e8 e2 fe ff ff       	call   80102242 <lapicw>
  lapicw(ESR, 0);
80102360:	ba 00 00 00 00       	mov    $0x0,%edx
80102365:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010236a:	e8 d3 fe ff ff       	call   80102242 <lapicw>
  lapicw(EOI, 0);
8010236f:	ba 00 00 00 00       	mov    $0x0,%edx
80102374:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102379:	e8 c4 fe ff ff       	call   80102242 <lapicw>
  lapicw(ICRHI, 0);
8010237e:	ba 00 00 00 00       	mov    $0x0,%edx
80102383:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102388:	e8 b5 fe ff ff       	call   80102242 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010238d:	ba 00 85 08 00       	mov    $0x88500,%edx
80102392:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102397:	e8 a6 fe ff ff       	call   80102242 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010239c:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801023a1:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
801023a7:	f6 c4 10             	test   $0x10,%ah
801023aa:	75 f0                	jne    8010239c <lapicinit+0xda>
  lapicw(TPR, 0);
801023ac:	ba 00 00 00 00       	mov    $0x0,%edx
801023b1:	b8 20 00 00 00       	mov    $0x20,%eax
801023b6:	e8 87 fe ff ff       	call   80102242 <lapicw>
}
801023bb:	c9                   	leave  
801023bc:	c3                   	ret    
    lapicw(PCINT, MASKED);
801023bd:	ba 00 00 01 00       	mov    $0x10000,%edx
801023c2:	b8 d0 00 00 00       	mov    $0xd0,%eax
801023c7:	e8 76 fe ff ff       	call   80102242 <lapicw>
801023cc:	e9 71 ff ff ff       	jmp    80102342 <lapicinit+0x80>
801023d1:	c3                   	ret    

801023d2 <lapicid>:
{
801023d2:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801023d6:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801023db:	85 c0                	test   %eax,%eax
801023dd:	74 07                	je     801023e6 <lapicid+0x14>
  return lapic[ID] >> 24;
801023df:	8b 40 20             	mov    0x20(%eax),%eax
801023e2:	c1 e8 18             	shr    $0x18,%eax
801023e5:	c3                   	ret    
    return 0;
801023e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023eb:	c3                   	ret    

801023ec <lapiceoi>:
{
801023ec:	f3 0f 1e fb          	endbr32 
  if(lapic)
801023f0:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
801023f7:	74 17                	je     80102410 <lapiceoi+0x24>
{
801023f9:	55                   	push   %ebp
801023fa:	89 e5                	mov    %esp,%ebp
801023fc:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
801023ff:	ba 00 00 00 00       	mov    $0x0,%edx
80102404:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102409:	e8 34 fe ff ff       	call   80102242 <lapicw>
}
8010240e:	c9                   	leave  
8010240f:	c3                   	ret    
80102410:	c3                   	ret    

80102411 <microdelay>:
{
80102411:	f3 0f 1e fb          	endbr32 
}
80102415:	c3                   	ret    

80102416 <lapicstartap>:
{
80102416:	f3 0f 1e fb          	endbr32 
8010241a:	55                   	push   %ebp
8010241b:	89 e5                	mov    %esp,%ebp
8010241d:	57                   	push   %edi
8010241e:	56                   	push   %esi
8010241f:	53                   	push   %ebx
80102420:	83 ec 0c             	sub    $0xc,%esp
80102423:	8b 75 08             	mov    0x8(%ebp),%esi
80102426:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102429:	b0 0f                	mov    $0xf,%al
8010242b:	ba 70 00 00 00       	mov    $0x70,%edx
80102430:	ee                   	out    %al,(%dx)
80102431:	b0 0a                	mov    $0xa,%al
80102433:	ba 71 00 00 00       	mov    $0x71,%edx
80102438:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102439:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102440:	00 00 
  wrv[1] = addr >> 4;
80102442:	89 f8                	mov    %edi,%eax
80102444:	c1 e8 04             	shr    $0x4,%eax
80102447:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
8010244d:	c1 e6 18             	shl    $0x18,%esi
80102450:	89 f2                	mov    %esi,%edx
80102452:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102457:	e8 e6 fd ff ff       	call   80102242 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010245c:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102461:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102466:	e8 d7 fd ff ff       	call   80102242 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
8010246b:	ba 00 85 00 00       	mov    $0x8500,%edx
80102470:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102475:	e8 c8 fd ff ff       	call   80102242 <lapicw>
  for(i = 0; i < 2; i++){
8010247a:	bb 00 00 00 00       	mov    $0x0,%ebx
8010247f:	eb 1f                	jmp    801024a0 <lapicstartap+0x8a>
    lapicw(ICRHI, apicid<<24);
80102481:	89 f2                	mov    %esi,%edx
80102483:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102488:	e8 b5 fd ff ff       	call   80102242 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010248d:	89 fa                	mov    %edi,%edx
8010248f:	c1 ea 0c             	shr    $0xc,%edx
80102492:	80 ce 06             	or     $0x6,%dh
80102495:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010249a:	e8 a3 fd ff ff       	call   80102242 <lapicw>
  for(i = 0; i < 2; i++){
8010249f:	43                   	inc    %ebx
801024a0:	83 fb 01             	cmp    $0x1,%ebx
801024a3:	7e dc                	jle    80102481 <lapicstartap+0x6b>
}
801024a5:	83 c4 0c             	add    $0xc,%esp
801024a8:	5b                   	pop    %ebx
801024a9:	5e                   	pop    %esi
801024aa:	5f                   	pop    %edi
801024ab:	5d                   	pop    %ebp
801024ac:	c3                   	ret    

801024ad <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801024ad:	f3 0f 1e fb          	endbr32 
801024b1:	55                   	push   %ebp
801024b2:	89 e5                	mov    %esp,%ebp
801024b4:	57                   	push   %edi
801024b5:	56                   	push   %esi
801024b6:	53                   	push   %ebx
801024b7:	83 ec 3c             	sub    $0x3c,%esp
801024ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801024bd:	b8 0b 00 00 00       	mov    $0xb,%eax
801024c2:	e8 8f fd ff ff       	call   80102256 <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
801024c7:	83 e0 04             	and    $0x4,%eax
801024ca:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801024cc:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024cf:	e8 92 fd ff ff       	call   80102266 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801024d4:	b8 0a 00 00 00       	mov    $0xa,%eax
801024d9:	e8 78 fd ff ff       	call   80102256 <cmos_read>
801024de:	a8 80                	test   $0x80,%al
801024e0:	75 ea                	jne    801024cc <cmostime+0x1f>
        continue;
    fill_rtcdate(&t2);
801024e2:	8d 75 b8             	lea    -0x48(%ebp),%esi
801024e5:	89 f0                	mov    %esi,%eax
801024e7:	e8 7a fd ff ff       	call   80102266 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801024ec:	83 ec 04             	sub    $0x4,%esp
801024ef:	6a 18                	push   $0x18
801024f1:	56                   	push   %esi
801024f2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024f5:	50                   	push   %eax
801024f6:	e8 13 1a 00 00       	call   80103f0e <memcmp>
801024fb:	83 c4 10             	add    $0x10,%esp
801024fe:	85 c0                	test   %eax,%eax
80102500:	75 ca                	jne    801024cc <cmostime+0x1f>
      break;
  }

  // convert
  if(bcd) {
80102502:	85 ff                	test   %edi,%edi
80102504:	75 7e                	jne    80102584 <cmostime+0xd7>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102506:	8b 55 d0             	mov    -0x30(%ebp),%edx
80102509:	89 d0                	mov    %edx,%eax
8010250b:	c1 e8 04             	shr    $0x4,%eax
8010250e:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102511:	01 c0                	add    %eax,%eax
80102513:	83 e2 0f             	and    $0xf,%edx
80102516:	01 d0                	add    %edx,%eax
80102518:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010251b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010251e:	89 d0                	mov    %edx,%eax
80102520:	c1 e8 04             	shr    $0x4,%eax
80102523:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102526:	01 c0                	add    %eax,%eax
80102528:	83 e2 0f             	and    $0xf,%edx
8010252b:	01 d0                	add    %edx,%eax
8010252d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
80102530:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102533:	89 d0                	mov    %edx,%eax
80102535:	c1 e8 04             	shr    $0x4,%eax
80102538:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010253b:	01 c0                	add    %eax,%eax
8010253d:	83 e2 0f             	and    $0xf,%edx
80102540:	01 d0                	add    %edx,%eax
80102542:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102545:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102548:	89 d0                	mov    %edx,%eax
8010254a:	c1 e8 04             	shr    $0x4,%eax
8010254d:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102550:	01 c0                	add    %eax,%eax
80102552:	83 e2 0f             	and    $0xf,%edx
80102555:	01 d0                	add    %edx,%eax
80102557:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
8010255a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010255d:	89 d0                	mov    %edx,%eax
8010255f:	c1 e8 04             	shr    $0x4,%eax
80102562:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102565:	01 c0                	add    %eax,%eax
80102567:	83 e2 0f             	and    $0xf,%edx
8010256a:	01 d0                	add    %edx,%eax
8010256c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
8010256f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102572:	89 d0                	mov    %edx,%eax
80102574:	c1 e8 04             	shr    $0x4,%eax
80102577:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010257a:	01 c0                	add    %eax,%eax
8010257c:	83 e2 0f             	and    $0xf,%edx
8010257f:	01 d0                	add    %edx,%eax
80102581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102584:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102587:	b9 06 00 00 00       	mov    $0x6,%ecx
8010258c:	89 df                	mov    %ebx,%edi
8010258e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
80102590:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102597:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010259a:	5b                   	pop    %ebx
8010259b:	5e                   	pop    %esi
8010259c:	5f                   	pop    %edi
8010259d:	5d                   	pop    %ebp
8010259e:	c3                   	ret    

8010259f <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010259f:	55                   	push   %ebp
801025a0:	89 e5                	mov    %esp,%ebp
801025a2:	53                   	push   %ebx
801025a3:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801025a6:	ff 35 b4 26 11 80    	pushl  0x801126b4
801025ac:	ff 35 c4 26 11 80    	pushl  0x801126c4
801025b2:	e8 b7 db ff ff       	call   8010016e <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801025b7:	8b 58 5c             	mov    0x5c(%eax),%ebx
801025ba:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
801025c0:	83 c4 10             	add    $0x10,%esp
801025c3:	ba 00 00 00 00       	mov    $0x0,%edx
801025c8:	39 d3                	cmp    %edx,%ebx
801025ca:	7e 0e                	jle    801025da <read_head+0x3b>
    log.lh.block[i] = lh->block[i];
801025cc:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801025d0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801025d7:	42                   	inc    %edx
801025d8:	eb ee                	jmp    801025c8 <read_head+0x29>
  }
  brelse(buf);
801025da:	83 ec 0c             	sub    $0xc,%esp
801025dd:	50                   	push   %eax
801025de:	e8 fc db ff ff       	call   801001df <brelse>
}
801025e3:	83 c4 10             	add    $0x10,%esp
801025e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025e9:	c9                   	leave  
801025ea:	c3                   	ret    

801025eb <install_trans>:
{
801025eb:	55                   	push   %ebp
801025ec:	89 e5                	mov    %esp,%ebp
801025ee:	57                   	push   %edi
801025ef:	56                   	push   %esi
801025f0:	53                   	push   %ebx
801025f1:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801025f4:	be 00 00 00 00       	mov    $0x0,%esi
801025f9:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
801025ff:	7e 64                	jle    80102665 <install_trans+0x7a>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102601:	89 f0                	mov    %esi,%eax
80102603:	03 05 b4 26 11 80    	add    0x801126b4,%eax
80102609:	40                   	inc    %eax
8010260a:	83 ec 08             	sub    $0x8,%esp
8010260d:	50                   	push   %eax
8010260e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102614:	e8 55 db ff ff       	call   8010016e <bread>
80102619:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010261b:	83 c4 08             	add    $0x8,%esp
8010261e:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
80102625:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010262b:	e8 3e db ff ff       	call   8010016e <bread>
80102630:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102632:	8d 57 5c             	lea    0x5c(%edi),%edx
80102635:	8d 40 5c             	lea    0x5c(%eax),%eax
80102638:	83 c4 0c             	add    $0xc,%esp
8010263b:	68 00 02 00 00       	push   $0x200
80102640:	52                   	push   %edx
80102641:	50                   	push   %eax
80102642:	e8 fa 18 00 00       	call   80103f41 <memmove>
    bwrite(dbuf);  // write dst to disk
80102647:	89 1c 24             	mov    %ebx,(%esp)
8010264a:	e8 51 db ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
8010264f:	89 3c 24             	mov    %edi,(%esp)
80102652:	e8 88 db ff ff       	call   801001df <brelse>
    brelse(dbuf);
80102657:	89 1c 24             	mov    %ebx,(%esp)
8010265a:	e8 80 db ff ff       	call   801001df <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010265f:	46                   	inc    %esi
80102660:	83 c4 10             	add    $0x10,%esp
80102663:	eb 94                	jmp    801025f9 <install_trans+0xe>
}
80102665:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102668:	5b                   	pop    %ebx
80102669:	5e                   	pop    %esi
8010266a:	5f                   	pop    %edi
8010266b:	5d                   	pop    %ebp
8010266c:	c3                   	ret    

8010266d <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010266d:	55                   	push   %ebp
8010266e:	89 e5                	mov    %esp,%ebp
80102670:	53                   	push   %ebx
80102671:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102674:	ff 35 b4 26 11 80    	pushl  0x801126b4
8010267a:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102680:	e8 e9 da ff ff       	call   8010016e <bread>
80102685:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102687:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
8010268d:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102690:	83 c4 10             	add    $0x10,%esp
80102693:	b8 00 00 00 00       	mov    $0x0,%eax
80102698:	39 c1                	cmp    %eax,%ecx
8010269a:	7e 0e                	jle    801026aa <write_head+0x3d>
    hb->block[i] = log.lh.block[i];
8010269c:	8b 14 85 cc 26 11 80 	mov    -0x7feed934(,%eax,4),%edx
801026a3:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
801026a7:	40                   	inc    %eax
801026a8:	eb ee                	jmp    80102698 <write_head+0x2b>
  }
  bwrite(buf);
801026aa:	83 ec 0c             	sub    $0xc,%esp
801026ad:	53                   	push   %ebx
801026ae:	e8 ed da ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801026b3:	89 1c 24             	mov    %ebx,(%esp)
801026b6:	e8 24 db ff ff       	call   801001df <brelse>
}
801026bb:	83 c4 10             	add    $0x10,%esp
801026be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026c1:	c9                   	leave  
801026c2:	c3                   	ret    

801026c3 <recover_from_log>:

static void
recover_from_log(void)
{
801026c3:	55                   	push   %ebp
801026c4:	89 e5                	mov    %esp,%ebp
801026c6:	83 ec 08             	sub    $0x8,%esp
  read_head();
801026c9:	e8 d1 fe ff ff       	call   8010259f <read_head>
  install_trans(); // if committed, copy from log to disk
801026ce:	e8 18 ff ff ff       	call   801025eb <install_trans>
  log.lh.n = 0;
801026d3:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
801026da:	00 00 00 
  write_head(); // clear the log
801026dd:	e8 8b ff ff ff       	call   8010266d <write_head>
}
801026e2:	c9                   	leave  
801026e3:	c3                   	ret    

801026e4 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801026e4:	55                   	push   %ebp
801026e5:	89 e5                	mov    %esp,%ebp
801026e7:	57                   	push   %edi
801026e8:	56                   	push   %esi
801026e9:	53                   	push   %ebx
801026ea:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026ed:	be 00 00 00 00       	mov    $0x0,%esi
801026f2:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
801026f8:	7e 64                	jle    8010275e <write_log+0x7a>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801026fa:	89 f0                	mov    %esi,%eax
801026fc:	03 05 b4 26 11 80    	add    0x801126b4,%eax
80102702:	40                   	inc    %eax
80102703:	83 ec 08             	sub    $0x8,%esp
80102706:	50                   	push   %eax
80102707:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010270d:	e8 5c da ff ff       	call   8010016e <bread>
80102712:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102714:	83 c4 08             	add    $0x8,%esp
80102717:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
8010271e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102724:	e8 45 da ff ff       	call   8010016e <bread>
80102729:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010272b:	8d 50 5c             	lea    0x5c(%eax),%edx
8010272e:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102731:	83 c4 0c             	add    $0xc,%esp
80102734:	68 00 02 00 00       	push   $0x200
80102739:	52                   	push   %edx
8010273a:	50                   	push   %eax
8010273b:	e8 01 18 00 00       	call   80103f41 <memmove>
    bwrite(to);  // write the log
80102740:	89 1c 24             	mov    %ebx,(%esp)
80102743:	e8 58 da ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102748:	89 3c 24             	mov    %edi,(%esp)
8010274b:	e8 8f da ff ff       	call   801001df <brelse>
    brelse(to);
80102750:	89 1c 24             	mov    %ebx,(%esp)
80102753:	e8 87 da ff ff       	call   801001df <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102758:	46                   	inc    %esi
80102759:	83 c4 10             	add    $0x10,%esp
8010275c:	eb 94                	jmp    801026f2 <write_log+0xe>
  }
}
8010275e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102761:	5b                   	pop    %ebx
80102762:	5e                   	pop    %esi
80102763:	5f                   	pop    %edi
80102764:	5d                   	pop    %ebp
80102765:	c3                   	ret    

80102766 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102766:	83 3d c8 26 11 80 00 	cmpl   $0x0,0x801126c8
8010276d:	7f 01                	jg     80102770 <commit+0xa>
8010276f:	c3                   	ret    
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102776:	e8 69 ff ff ff       	call   801026e4 <write_log>
    write_head();    // Write header to disk -- the real commit
8010277b:	e8 ed fe ff ff       	call   8010266d <write_head>
    install_trans(); // Now install writes to home locations
80102780:	e8 66 fe ff ff       	call   801025eb <install_trans>
    log.lh.n = 0;
80102785:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
8010278c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010278f:	e8 d9 fe ff ff       	call   8010266d <write_head>
  }
}
80102794:	c9                   	leave  
80102795:	c3                   	ret    

80102796 <initlog>:
{
80102796:	f3 0f 1e fb          	endbr32 
8010279a:	55                   	push   %ebp
8010279b:	89 e5                	mov    %esp,%ebp
8010279d:	53                   	push   %ebx
8010279e:	83 ec 2c             	sub    $0x2c,%esp
801027a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801027a4:	68 40 6f 10 80       	push   $0x80106f40
801027a9:	68 80 26 11 80       	push   $0x80112680
801027ae:	e8 11 15 00 00       	call   80103cc4 <initlock>
  readsb(dev, &sb);
801027b3:	83 c4 08             	add    $0x8,%esp
801027b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
801027b9:	50                   	push   %eax
801027ba:	53                   	push   %ebx
801027bb:	e8 81 ea ff ff       	call   80101241 <readsb>
  log.start = sb.logstart;
801027c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027c3:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
801027c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801027cb:	a3 b8 26 11 80       	mov    %eax,0x801126b8
  log.dev = dev;
801027d0:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  recover_from_log();
801027d6:	e8 e8 fe ff ff       	call   801026c3 <recover_from_log>
}
801027db:	83 c4 10             	add    $0x10,%esp
801027de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027e1:	c9                   	leave  
801027e2:	c3                   	ret    

801027e3 <begin_op>:
{
801027e3:	f3 0f 1e fb          	endbr32 
801027e7:	55                   	push   %ebp
801027e8:	89 e5                	mov    %esp,%ebp
801027ea:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801027ed:	68 80 26 11 80       	push   $0x80112680
801027f2:	e8 18 16 00 00       	call   80103e0f <acquire>
801027f7:	83 c4 10             	add    $0x10,%esp
801027fa:	eb 15                	jmp    80102811 <begin_op+0x2e>
      sleep(&log, &log.lock);
801027fc:	83 ec 08             	sub    $0x8,%esp
801027ff:	68 80 26 11 80       	push   $0x80112680
80102804:	68 80 26 11 80       	push   $0x80112680
80102809:	e8 ec 0f 00 00       	call   801037fa <sleep>
8010280e:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102811:	83 3d c0 26 11 80 00 	cmpl   $0x0,0x801126c0
80102818:	75 e2                	jne    801027fc <begin_op+0x19>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010281a:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010281f:	8d 48 01             	lea    0x1(%eax),%ecx
80102822:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
80102826:	8d 04 12             	lea    (%edx,%edx,1),%eax
80102829:	03 05 c8 26 11 80    	add    0x801126c8,%eax
8010282f:	83 f8 1e             	cmp    $0x1e,%eax
80102832:	7e 17                	jle    8010284b <begin_op+0x68>
      sleep(&log, &log.lock);
80102834:	83 ec 08             	sub    $0x8,%esp
80102837:	68 80 26 11 80       	push   $0x80112680
8010283c:	68 80 26 11 80       	push   $0x80112680
80102841:	e8 b4 0f 00 00       	call   801037fa <sleep>
80102846:	83 c4 10             	add    $0x10,%esp
80102849:	eb c6                	jmp    80102811 <begin_op+0x2e>
      log.outstanding += 1;
8010284b:	89 0d bc 26 11 80    	mov    %ecx,0x801126bc
      release(&log.lock);
80102851:	83 ec 0c             	sub    $0xc,%esp
80102854:	68 80 26 11 80       	push   $0x80112680
80102859:	e8 1a 16 00 00       	call   80103e78 <release>
}
8010285e:	83 c4 10             	add    $0x10,%esp
80102861:	c9                   	leave  
80102862:	c3                   	ret    

80102863 <end_op>:
{
80102863:	f3 0f 1e fb          	endbr32 
80102867:	55                   	push   %ebp
80102868:	89 e5                	mov    %esp,%ebp
8010286a:	53                   	push   %ebx
8010286b:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010286e:	68 80 26 11 80       	push   $0x80112680
80102873:	e8 97 15 00 00       	call   80103e0f <acquire>
  log.outstanding -= 1;
80102878:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010287d:	48                   	dec    %eax
8010287e:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102883:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102889:	83 c4 10             	add    $0x10,%esp
8010288c:	85 db                	test   %ebx,%ebx
8010288e:	75 2c                	jne    801028bc <end_op+0x59>
  if(log.outstanding == 0){
80102890:	85 c0                	test   %eax,%eax
80102892:	75 35                	jne    801028c9 <end_op+0x66>
    log.committing = 1;
80102894:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
8010289b:	00 00 00 
    do_commit = 1;
8010289e:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
801028a3:	83 ec 0c             	sub    $0xc,%esp
801028a6:	68 80 26 11 80       	push   $0x80112680
801028ab:	e8 c8 15 00 00       	call   80103e78 <release>
  if(do_commit){
801028b0:	83 c4 10             	add    $0x10,%esp
801028b3:	85 db                	test   %ebx,%ebx
801028b5:	75 24                	jne    801028db <end_op+0x78>
}
801028b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028ba:	c9                   	leave  
801028bb:	c3                   	ret    
    panic("log.committing");
801028bc:	83 ec 0c             	sub    $0xc,%esp
801028bf:	68 44 6f 10 80       	push   $0x80106f44
801028c4:	e8 8c da ff ff       	call   80100355 <panic>
    wakeup(&log);
801028c9:	83 ec 0c             	sub    $0xc,%esp
801028cc:	68 80 26 11 80       	push   $0x80112680
801028d1:	e8 9e 10 00 00       	call   80103974 <wakeup>
801028d6:	83 c4 10             	add    $0x10,%esp
801028d9:	eb c8                	jmp    801028a3 <end_op+0x40>
    commit();
801028db:	e8 86 fe ff ff       	call   80102766 <commit>
    acquire(&log.lock);
801028e0:	83 ec 0c             	sub    $0xc,%esp
801028e3:	68 80 26 11 80       	push   $0x80112680
801028e8:	e8 22 15 00 00       	call   80103e0f <acquire>
    log.committing = 0;
801028ed:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
801028f4:	00 00 00 
    wakeup(&log);
801028f7:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028fe:	e8 71 10 00 00       	call   80103974 <wakeup>
    release(&log.lock);
80102903:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
8010290a:	e8 69 15 00 00       	call   80103e78 <release>
8010290f:	83 c4 10             	add    $0x10,%esp
}
80102912:	eb a3                	jmp    801028b7 <end_op+0x54>

80102914 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102914:	f3 0f 1e fb          	endbr32 
80102918:	55                   	push   %ebp
80102919:	89 e5                	mov    %esp,%ebp
8010291b:	53                   	push   %ebx
8010291c:	83 ec 04             	sub    $0x4,%esp
8010291f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102922:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102928:	83 fa 1d             	cmp    $0x1d,%edx
8010292b:	7f 41                	jg     8010296e <log_write+0x5a>
8010292d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102932:	48                   	dec    %eax
80102933:	39 c2                	cmp    %eax,%edx
80102935:	7d 37                	jge    8010296e <log_write+0x5a>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102937:	83 3d bc 26 11 80 00 	cmpl   $0x0,0x801126bc
8010293e:	7e 3b                	jle    8010297b <log_write+0x67>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102940:	83 ec 0c             	sub    $0xc,%esp
80102943:	68 80 26 11 80       	push   $0x80112680
80102948:	e8 c2 14 00 00       	call   80103e0f <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010294d:	83 c4 10             	add    $0x10,%esp
80102950:	b8 00 00 00 00       	mov    $0x0,%eax
80102955:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
8010295b:	39 c2                	cmp    %eax,%edx
8010295d:	7e 29                	jle    80102988 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010295f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102962:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102969:	74 1d                	je     80102988 <log_write+0x74>
  for (i = 0; i < log.lh.n; i++) {
8010296b:	40                   	inc    %eax
8010296c:	eb e7                	jmp    80102955 <log_write+0x41>
    panic("too big a transaction");
8010296e:	83 ec 0c             	sub    $0xc,%esp
80102971:	68 53 6f 10 80       	push   $0x80106f53
80102976:	e8 da d9 ff ff       	call   80100355 <panic>
    panic("log_write outside of trans");
8010297b:	83 ec 0c             	sub    $0xc,%esp
8010297e:	68 69 6f 10 80       	push   $0x80106f69
80102983:	e8 cd d9 ff ff       	call   80100355 <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
80102988:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010298b:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102992:	39 c2                	cmp    %eax,%edx
80102994:	74 18                	je     801029ae <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102996:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102999:	83 ec 0c             	sub    $0xc,%esp
8010299c:	68 80 26 11 80       	push   $0x80112680
801029a1:	e8 d2 14 00 00       	call   80103e78 <release>
}
801029a6:	83 c4 10             	add    $0x10,%esp
801029a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ac:	c9                   	leave  
801029ad:	c3                   	ret    
    log.lh.n++;
801029ae:	42                   	inc    %edx
801029af:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
801029b5:	eb df                	jmp    80102996 <log_write+0x82>

801029b7 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801029b7:	55                   	push   %ebp
801029b8:	89 e5                	mov    %esp,%ebp
801029ba:	53                   	push   %ebx
801029bb:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801029be:	68 8e 00 00 00       	push   $0x8e
801029c3:	68 8c a4 10 80       	push   $0x8010a48c
801029c8:	68 00 70 00 80       	push   $0x80007000
801029cd:	e8 6f 15 00 00       	call   80103f41 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801029d2:	83 c4 10             	add    $0x10,%esp
801029d5:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801029da:	eb 47                	jmp    80102a23 <startothers+0x6c>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801029dc:	e8 2b f7 ff ff       	call   8010210c <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801029e1:	05 00 10 00 00       	add    $0x1000,%eax
801029e6:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
801029eb:	c7 05 f8 6f 00 80 8b 	movl   $0x80102a8b,0x80006ff8
801029f2:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801029f5:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801029fc:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
801029ff:	83 ec 08             	sub    $0x8,%esp
80102a02:	68 00 70 00 00       	push   $0x7000
80102a07:	0f b6 03             	movzbl (%ebx),%eax
80102a0a:	50                   	push   %eax
80102a0b:	e8 06 fa ff ff       	call   80102416 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102a10:	83 c4 10             	add    $0x10,%esp
80102a13:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102a19:	85 c0                	test   %eax,%eax
80102a1b:	74 f6                	je     80102a13 <startothers+0x5c>
  for(c = cpus; c < cpus+ncpu; c++){
80102a1d:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102a23:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80102a29:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102a2c:	01 c0                	add    %eax,%eax
80102a2e:	01 d0                	add    %edx,%eax
80102a30:	c1 e0 04             	shl    $0x4,%eax
80102a33:	05 80 27 11 80       	add    $0x80112780,%eax
80102a38:	39 d8                	cmp    %ebx,%eax
80102a3a:	76 0b                	jbe    80102a47 <startothers+0x90>
    if(c == mycpu())  // We've started already.
80102a3c:	e8 98 07 00 00       	call   801031d9 <mycpu>
80102a41:	39 c3                	cmp    %eax,%ebx
80102a43:	74 d8                	je     80102a1d <startothers+0x66>
80102a45:	eb 95                	jmp    801029dc <startothers+0x25>
      ;
  }
}
80102a47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a4a:	c9                   	leave  
80102a4b:	c3                   	ret    

80102a4c <mpmain>:
{
80102a4c:	55                   	push   %ebp
80102a4d:	89 e5                	mov    %esp,%ebp
80102a4f:	53                   	push   %ebx
80102a50:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102a53:	e8 e8 07 00 00       	call   80103240 <cpuid>
80102a58:	89 c3                	mov    %eax,%ebx
80102a5a:	e8 e1 07 00 00       	call   80103240 <cpuid>
80102a5f:	83 ec 04             	sub    $0x4,%esp
80102a62:	53                   	push   %ebx
80102a63:	50                   	push   %eax
80102a64:	68 84 6f 10 80       	push   $0x80106f84
80102a69:	e8 8f db ff ff       	call   801005fd <cprintf>
  idtinit();       // load idt register
80102a6e:	e8 8a 27 00 00       	call   801051fd <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a73:	e8 61 07 00 00       	call   801031d9 <mycpu>
80102a78:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a7a:	b8 01 00 00 00       	mov    $0x1,%eax
80102a7f:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a86:	e8 7d 0a 00 00       	call   80103508 <scheduler>

80102a8b <mpenter>:
{
80102a8b:	f3 0f 1e fb          	endbr32 
80102a8f:	55                   	push   %ebp
80102a90:	89 e5                	mov    %esp,%ebp
80102a92:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a95:	e8 6c 39 00 00       	call   80106406 <switchkvm>
  seginit();
80102a9a:	e8 74 37 00 00       	call   80106213 <seginit>
  lapicinit();
80102a9f:	e8 1e f8 ff ff       	call   801022c2 <lapicinit>
  mpmain();
80102aa4:	e8 a3 ff ff ff       	call   80102a4c <mpmain>

80102aa9 <main>:
{
80102aa9:	f3 0f 1e fb          	endbr32 
80102aad:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ab1:	83 e4 f0             	and    $0xfffffff0,%esp
80102ab4:	ff 71 fc             	pushl  -0x4(%ecx)
80102ab7:	55                   	push   %ebp
80102ab8:	89 e5                	mov    %esp,%ebp
80102aba:	51                   	push   %ecx
80102abb:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102abe:	68 00 00 40 80       	push   $0x80400000
80102ac3:	68 a8 57 11 80       	push   $0x801157a8
80102ac8:	e8 e5 f5 ff ff       	call   801020b2 <kinit1>
  kvmalloc();      // kernel page table
80102acd:	e8 db 3d 00 00       	call   801068ad <kvmalloc>
  mpinit();        // detect other processors
80102ad2:	e8 b8 01 00 00       	call   80102c8f <mpinit>
  lapicinit();     // interrupt controller
80102ad7:	e8 e6 f7 ff ff       	call   801022c2 <lapicinit>
  seginit();       // segment descriptors
80102adc:	e8 32 37 00 00       	call   80106213 <seginit>
  picinit();       // disable pic
80102ae1:	e8 7d 02 00 00       	call   80102d63 <picinit>
  ioapicinit();    // another interrupt controller
80102ae6:	e8 44 f4 ff ff       	call   80101f2f <ioapicinit>
  consoleinit();   // console hardware
80102aeb:	e8 87 dd ff ff       	call   80100877 <consoleinit>
  uartinit();      // serial port
80102af0:	e8 8e 2b 00 00       	call   80105683 <uartinit>
  pinit();         // process table
80102af5:	e8 c1 06 00 00       	call   801031bb <pinit>
  tvinit();        // trap vectors
80102afa:	e8 4e 26 00 00       	call   8010514d <tvinit>
  binit();         // buffer cache
80102aff:	e8 ee d5 ff ff       	call   801000f2 <binit>
  fileinit();      // file table
80102b04:	e8 0a e1 ff ff       	call   80100c13 <fileinit>
  ideinit();       // disk 
80102b09:	e8 2d f2 ff ff       	call   80101d3b <ideinit>
  startothers();   // start other processors
80102b0e:	e8 a4 fe ff ff       	call   801029b7 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102b13:	83 c4 08             	add    $0x8,%esp
80102b16:	68 00 00 00 8e       	push   $0x8e000000
80102b1b:	68 00 00 40 80       	push   $0x80400000
80102b20:	e8 c3 f5 ff ff       	call   801020e8 <kinit2>
  userinit();      // first user process
80102b25:	e8 73 07 00 00       	call   8010329d <userinit>
  mpmain();        // finish this processor's setup
80102b2a:	e8 1d ff ff ff       	call   80102a4c <mpmain>

80102b2f <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102b2f:	55                   	push   %ebp
80102b30:	89 e5                	mov    %esp,%ebp
80102b32:	56                   	push   %esi
80102b33:	53                   	push   %ebx
80102b34:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102b36:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102b3b:	b9 00 00 00 00       	mov    $0x0,%ecx
80102b40:	39 d1                	cmp    %edx,%ecx
80102b42:	7d 09                	jge    80102b4d <sum+0x1e>
    sum += addr[i];
80102b44:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102b48:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102b4a:	41                   	inc    %ecx
80102b4b:	eb f3                	jmp    80102b40 <sum+0x11>
  return sum;
}
80102b4d:	5b                   	pop    %ebx
80102b4e:	5e                   	pop    %esi
80102b4f:	5d                   	pop    %ebp
80102b50:	c3                   	ret    

80102b51 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102b51:	55                   	push   %ebp
80102b52:	89 e5                	mov    %esp,%ebp
80102b54:	56                   	push   %esi
80102b55:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102b56:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102b5c:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102b5e:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102b60:	eb 03                	jmp    80102b65 <mpsearch1+0x14>
80102b62:	83 c3 10             	add    $0x10,%ebx
80102b65:	39 f3                	cmp    %esi,%ebx
80102b67:	73 29                	jae    80102b92 <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102b69:	83 ec 04             	sub    $0x4,%esp
80102b6c:	6a 04                	push   $0x4
80102b6e:	68 98 6f 10 80       	push   $0x80106f98
80102b73:	53                   	push   %ebx
80102b74:	e8 95 13 00 00       	call   80103f0e <memcmp>
80102b79:	83 c4 10             	add    $0x10,%esp
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	75 e2                	jne    80102b62 <mpsearch1+0x11>
80102b80:	ba 10 00 00 00       	mov    $0x10,%edx
80102b85:	89 d8                	mov    %ebx,%eax
80102b87:	e8 a3 ff ff ff       	call   80102b2f <sum>
80102b8c:	84 c0                	test   %al,%al
80102b8e:	75 d2                	jne    80102b62 <mpsearch1+0x11>
80102b90:	eb 05                	jmp    80102b97 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102b92:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102b97:	89 d8                	mov    %ebx,%eax
80102b99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b9c:	5b                   	pop    %ebx
80102b9d:	5e                   	pop    %esi
80102b9e:	5d                   	pop    %ebp
80102b9f:	c3                   	ret    

80102ba0 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ba6:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102bad:	c1 e0 08             	shl    $0x8,%eax
80102bb0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102bb7:	09 d0                	or     %edx,%eax
80102bb9:	c1 e0 04             	shl    $0x4,%eax
80102bbc:	74 1f                	je     80102bdd <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102bbe:	ba 00 04 00 00       	mov    $0x400,%edx
80102bc3:	e8 89 ff ff ff       	call   80102b51 <mpsearch1>
80102bc8:	85 c0                	test   %eax,%eax
80102bca:	75 0f                	jne    80102bdb <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102bcc:	ba 00 00 01 00       	mov    $0x10000,%edx
80102bd1:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102bd6:	e8 76 ff ff ff       	call   80102b51 <mpsearch1>
}
80102bdb:	c9                   	leave  
80102bdc:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102bdd:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102be4:	c1 e0 08             	shl    $0x8,%eax
80102be7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102bee:	09 d0                	or     %edx,%eax
80102bf0:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102bf3:	2d 00 04 00 00       	sub    $0x400,%eax
80102bf8:	ba 00 04 00 00       	mov    $0x400,%edx
80102bfd:	e8 4f ff ff ff       	call   80102b51 <mpsearch1>
80102c02:	85 c0                	test   %eax,%eax
80102c04:	75 d5                	jne    80102bdb <mpsearch+0x3b>
80102c06:	eb c4                	jmp    80102bcc <mpsearch+0x2c>

80102c08 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102c08:	55                   	push   %ebp
80102c09:	89 e5                	mov    %esp,%ebp
80102c0b:	57                   	push   %edi
80102c0c:	56                   	push   %esi
80102c0d:	53                   	push   %ebx
80102c0e:	83 ec 1c             	sub    $0x1c,%esp
80102c11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c14:	e8 87 ff ff ff       	call   80102ba0 <mpsearch>
80102c19:	89 c3                	mov    %eax,%ebx
80102c1b:	85 c0                	test   %eax,%eax
80102c1d:	74 53                	je     80102c72 <mpconfig+0x6a>
80102c1f:	8b 70 04             	mov    0x4(%eax),%esi
80102c22:	85 f6                	test   %esi,%esi
80102c24:	74 50                	je     80102c76 <mpconfig+0x6e>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c26:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c2c:	83 ec 04             	sub    $0x4,%esp
80102c2f:	6a 04                	push   $0x4
80102c31:	68 9d 6f 10 80       	push   $0x80106f9d
80102c36:	57                   	push   %edi
80102c37:	e8 d2 12 00 00       	call   80103f0e <memcmp>
80102c3c:	83 c4 10             	add    $0x10,%esp
80102c3f:	85 c0                	test   %eax,%eax
80102c41:	75 37                	jne    80102c7a <mpconfig+0x72>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102c43:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102c49:	3c 01                	cmp    $0x1,%al
80102c4b:	74 04                	je     80102c51 <mpconfig+0x49>
80102c4d:	3c 04                	cmp    $0x4,%al
80102c4f:	75 30                	jne    80102c81 <mpconfig+0x79>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102c51:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102c58:	89 f8                	mov    %edi,%eax
80102c5a:	e8 d0 fe ff ff       	call   80102b2f <sum>
80102c5f:	84 c0                	test   %al,%al
80102c61:	75 25                	jne    80102c88 <mpconfig+0x80>
    return 0;
  *pmp = mp;
80102c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c66:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102c68:	89 f8                	mov    %edi,%eax
80102c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c6d:	5b                   	pop    %ebx
80102c6e:	5e                   	pop    %esi
80102c6f:	5f                   	pop    %edi
80102c70:	5d                   	pop    %ebp
80102c71:	c3                   	ret    
    return 0;
80102c72:	89 c7                	mov    %eax,%edi
80102c74:	eb f2                	jmp    80102c68 <mpconfig+0x60>
80102c76:	89 f7                	mov    %esi,%edi
80102c78:	eb ee                	jmp    80102c68 <mpconfig+0x60>
    return 0;
80102c7a:	bf 00 00 00 00       	mov    $0x0,%edi
80102c7f:	eb e7                	jmp    80102c68 <mpconfig+0x60>
    return 0;
80102c81:	bf 00 00 00 00       	mov    $0x0,%edi
80102c86:	eb e0                	jmp    80102c68 <mpconfig+0x60>
    return 0;
80102c88:	bf 00 00 00 00       	mov    $0x0,%edi
80102c8d:	eb d9                	jmp    80102c68 <mpconfig+0x60>

80102c8f <mpinit>:

void
mpinit(void)
{
80102c8f:	f3 0f 1e fb          	endbr32 
80102c93:	55                   	push   %ebp
80102c94:	89 e5                	mov    %esp,%ebp
80102c96:	57                   	push   %edi
80102c97:	56                   	push   %esi
80102c98:	53                   	push   %ebx
80102c99:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102c9c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102c9f:	e8 64 ff ff ff       	call   80102c08 <mpconfig>
80102ca4:	85 c0                	test   %eax,%eax
80102ca6:	74 19                	je     80102cc1 <mpinit+0x32>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102ca8:	8b 50 24             	mov    0x24(%eax),%edx
80102cab:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cb1:	8d 50 2c             	lea    0x2c(%eax),%edx
80102cb4:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102cb8:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102cba:	bf 01 00 00 00       	mov    $0x1,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cbf:	eb 20                	jmp    80102ce1 <mpinit+0x52>
    panic("Expect to run on an SMP");
80102cc1:	83 ec 0c             	sub    $0xc,%esp
80102cc4:	68 a2 6f 10 80       	push   $0x80106fa2
80102cc9:	e8 87 d6 ff ff       	call   80100355 <panic>
    switch(*p){
80102cce:	bf 00 00 00 00       	mov    $0x0,%edi
80102cd3:	eb 0c                	jmp    80102ce1 <mpinit+0x52>
80102cd5:	83 e8 03             	sub    $0x3,%eax
80102cd8:	3c 01                	cmp    $0x1,%al
80102cda:	76 19                	jbe    80102cf5 <mpinit+0x66>
80102cdc:	bf 00 00 00 00       	mov    $0x0,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ce1:	39 ca                	cmp    %ecx,%edx
80102ce3:	73 4a                	jae    80102d2f <mpinit+0xa0>
    switch(*p){
80102ce5:	8a 02                	mov    (%edx),%al
80102ce7:	3c 02                	cmp    $0x2,%al
80102ce9:	74 37                	je     80102d22 <mpinit+0x93>
80102ceb:	77 e8                	ja     80102cd5 <mpinit+0x46>
80102ced:	84 c0                	test   %al,%al
80102cef:	74 09                	je     80102cfa <mpinit+0x6b>
80102cf1:	3c 01                	cmp    $0x1,%al
80102cf3:	75 d9                	jne    80102cce <mpinit+0x3f>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102cf5:	83 c2 08             	add    $0x8,%edx
      continue;
80102cf8:	eb e7                	jmp    80102ce1 <mpinit+0x52>
      if(ncpu < NCPU) {
80102cfa:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80102cff:	83 f8 07             	cmp    $0x7,%eax
80102d02:	7f 19                	jg     80102d1d <mpinit+0x8e>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102d04:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102d07:	01 f6                	add    %esi,%esi
80102d09:	01 c6                	add    %eax,%esi
80102d0b:	c1 e6 04             	shl    $0x4,%esi
80102d0e:	8a 5a 01             	mov    0x1(%edx),%bl
80102d11:	88 9e 80 27 11 80    	mov    %bl,-0x7feed880(%esi)
        ncpu++;
80102d17:	40                   	inc    %eax
80102d18:	a3 00 2d 11 80       	mov    %eax,0x80112d00
      p += sizeof(struct mpproc);
80102d1d:	83 c2 14             	add    $0x14,%edx
      continue;
80102d20:	eb bf                	jmp    80102ce1 <mpinit+0x52>
      ioapicid = ioapic->apicno;
80102d22:	8a 42 01             	mov    0x1(%edx),%al
80102d25:	a2 60 27 11 80       	mov    %al,0x80112760
      p += sizeof(struct mpioapic);
80102d2a:	83 c2 08             	add    $0x8,%edx
      continue;
80102d2d:	eb b2                	jmp    80102ce1 <mpinit+0x52>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102d2f:	85 ff                	test   %edi,%edi
80102d31:	74 23                	je     80102d56 <mpinit+0xc7>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d36:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102d3a:	74 12                	je     80102d4e <mpinit+0xbf>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3c:	b0 70                	mov    $0x70,%al
80102d3e:	ba 22 00 00 00       	mov    $0x22,%edx
80102d43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d44:	ba 23 00 00 00       	mov    $0x23,%edx
80102d49:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102d4a:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d4d:	ee                   	out    %al,(%dx)
  }
}
80102d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d51:	5b                   	pop    %ebx
80102d52:	5e                   	pop    %esi
80102d53:	5f                   	pop    %edi
80102d54:	5d                   	pop    %ebp
80102d55:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102d56:	83 ec 0c             	sub    $0xc,%esp
80102d59:	68 bc 6f 10 80       	push   $0x80106fbc
80102d5e:	e8 f2 d5 ff ff       	call   80100355 <panic>

80102d63 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102d63:	f3 0f 1e fb          	endbr32 
80102d67:	b0 ff                	mov    $0xff,%al
80102d69:	ba 21 00 00 00       	mov    $0x21,%edx
80102d6e:	ee                   	out    %al,(%dx)
80102d6f:	ba a1 00 00 00       	mov    $0xa1,%edx
80102d74:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102d75:	c3                   	ret    

80102d76 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102d76:	f3 0f 1e fb          	endbr32 
80102d7a:	55                   	push   %ebp
80102d7b:	89 e5                	mov    %esp,%ebp
80102d7d:	57                   	push   %edi
80102d7e:	56                   	push   %esi
80102d7f:	53                   	push   %ebx
80102d80:	83 ec 0c             	sub    $0xc,%esp
80102d83:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d86:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102d89:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d8f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102d95:	e8 97 de ff ff       	call   80100c31 <filealloc>
80102d9a:	89 03                	mov    %eax,(%ebx)
80102d9c:	85 c0                	test   %eax,%eax
80102d9e:	0f 84 88 00 00 00    	je     80102e2c <pipealloc+0xb6>
80102da4:	e8 88 de ff ff       	call   80100c31 <filealloc>
80102da9:	89 06                	mov    %eax,(%esi)
80102dab:	85 c0                	test   %eax,%eax
80102dad:	74 7d                	je     80102e2c <pipealloc+0xb6>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102daf:	e8 58 f3 ff ff       	call   8010210c <kalloc>
80102db4:	89 c7                	mov    %eax,%edi
80102db6:	85 c0                	test   %eax,%eax
80102db8:	74 72                	je     80102e2c <pipealloc+0xb6>
    goto bad;
  p->readopen = 1;
80102dba:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102dc1:	00 00 00 
  p->writeopen = 1;
80102dc4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102dcb:	00 00 00 
  p->nwrite = 0;
80102dce:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102dd5:	00 00 00 
  p->nread = 0;
80102dd8:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102ddf:	00 00 00 
  initlock(&p->lock, "pipe");
80102de2:	83 ec 08             	sub    $0x8,%esp
80102de5:	68 db 6f 10 80       	push   $0x80106fdb
80102dea:	50                   	push   %eax
80102deb:	e8 d4 0e 00 00       	call   80103cc4 <initlock>
  (*f0)->type = FD_PIPE;
80102df0:	8b 03                	mov    (%ebx),%eax
80102df2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102df8:	8b 03                	mov    (%ebx),%eax
80102dfa:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102dfe:	8b 03                	mov    (%ebx),%eax
80102e00:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e04:	8b 03                	mov    (%ebx),%eax
80102e06:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102e09:	8b 06                	mov    (%esi),%eax
80102e0b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e11:	8b 06                	mov    (%esi),%eax
80102e13:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e17:	8b 06                	mov    (%esi),%eax
80102e19:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e1d:	8b 06                	mov    (%esi),%eax
80102e1f:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102e22:	83 c4 10             	add    $0x10,%esp
80102e25:	b8 00 00 00 00       	mov    $0x0,%eax
80102e2a:	eb 29                	jmp    80102e55 <pipealloc+0xdf>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102e2c:	8b 03                	mov    (%ebx),%eax
80102e2e:	85 c0                	test   %eax,%eax
80102e30:	74 0c                	je     80102e3e <pipealloc+0xc8>
    fileclose(*f0);
80102e32:	83 ec 0c             	sub    $0xc,%esp
80102e35:	50                   	push   %eax
80102e36:	e8 a2 de ff ff       	call   80100cdd <fileclose>
80102e3b:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102e3e:	8b 06                	mov    (%esi),%eax
80102e40:	85 c0                	test   %eax,%eax
80102e42:	74 19                	je     80102e5d <pipealloc+0xe7>
    fileclose(*f1);
80102e44:	83 ec 0c             	sub    $0xc,%esp
80102e47:	50                   	push   %eax
80102e48:	e8 90 de ff ff       	call   80100cdd <fileclose>
80102e4d:	83 c4 10             	add    $0x10,%esp
  return -1;
80102e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e58:	5b                   	pop    %ebx
80102e59:	5e                   	pop    %esi
80102e5a:	5f                   	pop    %edi
80102e5b:	5d                   	pop    %ebp
80102e5c:	c3                   	ret    
  return -1;
80102e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e62:	eb f1                	jmp    80102e55 <pipealloc+0xdf>

80102e64 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102e64:	f3 0f 1e fb          	endbr32 
80102e68:	55                   	push   %ebp
80102e69:	89 e5                	mov    %esp,%ebp
80102e6b:	53                   	push   %ebx
80102e6c:	83 ec 10             	sub    $0x10,%esp
80102e6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102e72:	53                   	push   %ebx
80102e73:	e8 97 0f 00 00       	call   80103e0f <acquire>
  if(writable){
80102e78:	83 c4 10             	add    $0x10,%esp
80102e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102e7f:	74 3f                	je     80102ec0 <pipeclose+0x5c>
    p->writeopen = 0;
80102e81:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102e88:	00 00 00 
    wakeup(&p->nread);
80102e8b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e91:	83 ec 0c             	sub    $0xc,%esp
80102e94:	50                   	push   %eax
80102e95:	e8 da 0a 00 00       	call   80103974 <wakeup>
80102e9a:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102e9d:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102ea4:	75 09                	jne    80102eaf <pipeclose+0x4b>
80102ea6:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102ead:	74 2f                	je     80102ede <pipeclose+0x7a>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102eaf:	83 ec 0c             	sub    $0xc,%esp
80102eb2:	53                   	push   %ebx
80102eb3:	e8 c0 0f 00 00       	call   80103e78 <release>
80102eb8:	83 c4 10             	add    $0x10,%esp
}
80102ebb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ebe:	c9                   	leave  
80102ebf:	c3                   	ret    
    p->readopen = 0;
80102ec0:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102ec7:	00 00 00 
    wakeup(&p->nwrite);
80102eca:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	50                   	push   %eax
80102ed4:	e8 9b 0a 00 00       	call   80103974 <wakeup>
80102ed9:	83 c4 10             	add    $0x10,%esp
80102edc:	eb bf                	jmp    80102e9d <pipeclose+0x39>
    release(&p->lock);
80102ede:	83 ec 0c             	sub    $0xc,%esp
80102ee1:	53                   	push   %ebx
80102ee2:	e8 91 0f 00 00       	call   80103e78 <release>
    kfree((char*)p);
80102ee7:	89 1c 24             	mov    %ebx,(%esp)
80102eea:	e8 f6 f0 ff ff       	call   80101fe5 <kfree>
80102eef:	83 c4 10             	add    $0x10,%esp
80102ef2:	eb c7                	jmp    80102ebb <pipeclose+0x57>

80102ef4 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102ef4:	f3 0f 1e fb          	endbr32 
80102ef8:	55                   	push   %ebp
80102ef9:	89 e5                	mov    %esp,%ebp
80102efb:	57                   	push   %edi
80102efc:	56                   	push   %esi
80102efd:	53                   	push   %ebx
80102efe:	83 ec 28             	sub    $0x28,%esp
80102f01:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102f04:	89 de                	mov    %ebx,%esi
80102f06:	53                   	push   %ebx
80102f07:	e8 03 0f 00 00       	call   80103e0f <acquire>
  for(i = 0; i < n; i++){
80102f0c:	83 c4 10             	add    $0x10,%esp
80102f0f:	bf 00 00 00 00       	mov    $0x0,%edi
80102f14:	3b 7d 10             	cmp    0x10(%ebp),%edi
80102f17:	7c 41                	jl     80102f5a <pipewrite+0x66>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102f19:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f1f:	83 ec 0c             	sub    $0xc,%esp
80102f22:	50                   	push   %eax
80102f23:	e8 4c 0a 00 00       	call   80103974 <wakeup>
  release(&p->lock);
80102f28:	89 1c 24             	mov    %ebx,(%esp)
80102f2b:	e8 48 0f 00 00       	call   80103e78 <release>
  return n;
80102f30:	83 c4 10             	add    $0x10,%esp
80102f33:	8b 45 10             	mov    0x10(%ebp),%eax
80102f36:	eb 5c                	jmp    80102f94 <pipewrite+0xa0>
      wakeup(&p->nread);
80102f38:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f3e:	83 ec 0c             	sub    $0xc,%esp
80102f41:	50                   	push   %eax
80102f42:	e8 2d 0a 00 00       	call   80103974 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f47:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f4d:	83 c4 08             	add    $0x8,%esp
80102f50:	56                   	push   %esi
80102f51:	50                   	push   %eax
80102f52:	e8 a3 08 00 00       	call   801037fa <sleep>
80102f57:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f5a:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102f60:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f66:	05 00 02 00 00       	add    $0x200,%eax
80102f6b:	39 c2                	cmp    %eax,%edx
80102f6d:	75 2d                	jne    80102f9c <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80102f6f:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f76:	74 0b                	je     80102f83 <pipewrite+0x8f>
80102f78:	e8 f8 02 00 00       	call   80103275 <myproc>
80102f7d:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f81:	74 b5                	je     80102f38 <pipewrite+0x44>
        release(&p->lock);
80102f83:	83 ec 0c             	sub    $0xc,%esp
80102f86:	53                   	push   %ebx
80102f87:	e8 ec 0e 00 00       	call   80103e78 <release>
        return -1;
80102f8c:	83 c4 10             	add    $0x10,%esp
80102f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f97:	5b                   	pop    %ebx
80102f98:	5e                   	pop    %esi
80102f99:	5f                   	pop    %edi
80102f9a:	5d                   	pop    %ebp
80102f9b:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102f9c:	8d 42 01             	lea    0x1(%edx),%eax
80102f9f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102fa5:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102fab:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fae:	8a 04 38             	mov    (%eax,%edi,1),%al
80102fb1:	88 45 e7             	mov    %al,-0x19(%ebp)
80102fb4:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102fb8:	47                   	inc    %edi
80102fb9:	e9 56 ff ff ff       	jmp    80102f14 <pipewrite+0x20>

80102fbe <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102fbe:	f3 0f 1e fb          	endbr32 
80102fc2:	55                   	push   %ebp
80102fc3:	89 e5                	mov    %esp,%ebp
80102fc5:	57                   	push   %edi
80102fc6:	56                   	push   %esi
80102fc7:	53                   	push   %ebx
80102fc8:	83 ec 18             	sub    $0x18,%esp
80102fcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102fce:	89 df                	mov    %ebx,%edi
80102fd0:	53                   	push   %ebx
80102fd1:	e8 39 0e 00 00       	call   80103e0f <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fd6:	83 c4 10             	add    $0x10,%esp
80102fd9:	eb 13                	jmp    80102fee <piperead+0x30>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102fdb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fe1:	83 ec 08             	sub    $0x8,%esp
80102fe4:	57                   	push   %edi
80102fe5:	50                   	push   %eax
80102fe6:	e8 0f 08 00 00       	call   801037fa <sleep>
80102feb:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fee:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102ff4:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102ffa:	75 28                	jne    80103024 <piperead+0x66>
80102ffc:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80103002:	85 f6                	test   %esi,%esi
80103004:	74 23                	je     80103029 <piperead+0x6b>
    if(myproc()->killed){
80103006:	e8 6a 02 00 00       	call   80103275 <myproc>
8010300b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010300f:	74 ca                	je     80102fdb <piperead+0x1d>
      release(&p->lock);
80103011:	83 ec 0c             	sub    $0xc,%esp
80103014:	53                   	push   %ebx
80103015:	e8 5e 0e 00 00       	call   80103e78 <release>
      return -1;
8010301a:	83 c4 10             	add    $0x10,%esp
8010301d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103022:	eb 4d                	jmp    80103071 <piperead+0xb3>
80103024:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103029:	3b 75 10             	cmp    0x10(%ebp),%esi
8010302c:	7d 29                	jge    80103057 <piperead+0x99>
    if(p->nread == p->nwrite)
8010302e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103034:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
8010303a:	74 1b                	je     80103057 <piperead+0x99>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010303c:	8d 50 01             	lea    0x1(%eax),%edx
8010303f:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80103045:	25 ff 01 00 00       	and    $0x1ff,%eax
8010304a:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
8010304e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103051:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103054:	46                   	inc    %esi
80103055:	eb d2                	jmp    80103029 <piperead+0x6b>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103057:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010305d:	83 ec 0c             	sub    $0xc,%esp
80103060:	50                   	push   %eax
80103061:	e8 0e 09 00 00       	call   80103974 <wakeup>
  release(&p->lock);
80103066:	89 1c 24             	mov    %ebx,(%esp)
80103069:	e8 0a 0e 00 00       	call   80103e78 <release>
  return i;
8010306e:	83 c4 10             	add    $0x10,%esp
}
80103071:	89 f0                	mov    %esi,%eax
80103073:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103076:	5b                   	pop    %ebx
80103077:	5e                   	pop    %esi
80103078:	5f                   	pop    %edi
80103079:	5d                   	pop    %ebp
8010307a:	c3                   	ret    

8010307b <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010307b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103080:	eb 0d                	jmp    8010308f <wakeup1+0x14>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
80103082:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103089:	81 c2 88 00 00 00    	add    $0x88,%edx
8010308f:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103095:	73 0d                	jae    801030a4 <wakeup1+0x29>
    if(p->state == SLEEPING && p->chan == chan)
80103097:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
8010309b:	75 ec                	jne    80103089 <wakeup1+0xe>
8010309d:	39 42 20             	cmp    %eax,0x20(%edx)
801030a0:	75 e7                	jne    80103089 <wakeup1+0xe>
801030a2:	eb de                	jmp    80103082 <wakeup1+0x7>
}
801030a4:	c3                   	ret    

801030a5 <allocproc>:
{
801030a5:	55                   	push   %ebp
801030a6:	89 e5                	mov    %esp,%ebp
801030a8:	53                   	push   %ebx
801030a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801030ac:	68 20 2d 11 80       	push   $0x80112d20
801030b1:	e8 59 0d 00 00       	call   80103e0f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030b6:	83 c4 10             	add    $0x10,%esp
801030b9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801030be:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801030c4:	0f 83 88 00 00 00    	jae    80103152 <allocproc+0xad>
    if(p->state == UNUSED)
801030ca:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
801030ce:	74 08                	je     801030d8 <allocproc+0x33>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030d0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801030d6:	eb e6                	jmp    801030be <allocproc+0x19>
  p->state = EMBRYO;
801030d8:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801030df:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801030e4:	8d 50 01             	lea    0x1(%eax),%edx
801030e7:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801030ed:	89 43 10             	mov    %eax,0x10(%ebx)
  p->prio = NORM_PRIO;
801030f0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801030f7:	00 00 00 
  release(&ptable.lock);
801030fa:	83 ec 0c             	sub    $0xc,%esp
801030fd:	68 20 2d 11 80       	push   $0x80112d20
80103102:	e8 71 0d 00 00       	call   80103e78 <release>
  if((p->kstack = kalloc()) == 0){
80103107:	e8 00 f0 ff ff       	call   8010210c <kalloc>
8010310c:	89 43 08             	mov    %eax,0x8(%ebx)
8010310f:	83 c4 10             	add    $0x10,%esp
80103112:	85 c0                	test   %eax,%eax
80103114:	74 53                	je     80103169 <allocproc+0xc4>
  sp -= sizeof *p->tf;
80103116:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
8010311c:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010311f:	c7 80 b0 0f 00 00 42 	movl   $0x80105142,0xfb0(%eax)
80103126:	51 10 80 
  sp -= sizeof *p->context;
80103129:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
8010312e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103131:	83 ec 04             	sub    $0x4,%esp
80103134:	6a 14                	push   $0x14
80103136:	6a 00                	push   $0x0
80103138:	50                   	push   %eax
80103139:	e8 85 0d 00 00       	call   80103ec3 <memset>
  p->context->eip = (uint)forkret;
8010313e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103141:	c7 40 10 74 31 10 80 	movl   $0x80103174,0x10(%eax)
  return p;
80103148:	83 c4 10             	add    $0x10,%esp
}
8010314b:	89 d8                	mov    %ebx,%eax
8010314d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103150:	c9                   	leave  
80103151:	c3                   	ret    
  release(&ptable.lock);
80103152:	83 ec 0c             	sub    $0xc,%esp
80103155:	68 20 2d 11 80       	push   $0x80112d20
8010315a:	e8 19 0d 00 00       	call   80103e78 <release>
  return 0;
8010315f:	83 c4 10             	add    $0x10,%esp
80103162:	bb 00 00 00 00       	mov    $0x0,%ebx
80103167:	eb e2                	jmp    8010314b <allocproc+0xa6>
    p->state = UNUSED;
80103169:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103170:	89 c3                	mov    %eax,%ebx
80103172:	eb d7                	jmp    8010314b <allocproc+0xa6>

80103174 <forkret>:
{
80103174:	f3 0f 1e fb          	endbr32 
80103178:	55                   	push   %ebp
80103179:	89 e5                	mov    %esp,%ebp
8010317b:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
8010317e:	68 20 2d 11 80       	push   $0x80112d20
80103183:	e8 f0 0c 00 00       	call   80103e78 <release>
  if (first) {
80103188:	83 c4 10             	add    $0x10,%esp
8010318b:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
80103192:	75 02                	jne    80103196 <forkret+0x22>
}
80103194:	c9                   	leave  
80103195:	c3                   	ret    
    first = 0;
80103196:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010319d:	00 00 00 
    iinit(ROOTDEV);
801031a0:	83 ec 0c             	sub    $0xc,%esp
801031a3:	6a 01                	push   $0x1
801031a5:	e8 54 e1 ff ff       	call   801012fe <iinit>
    initlog(ROOTDEV);
801031aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801031b1:	e8 e0 f5 ff ff       	call   80102796 <initlog>
801031b6:	83 c4 10             	add    $0x10,%esp
}
801031b9:	eb d9                	jmp    80103194 <forkret+0x20>

801031bb <pinit>:
{
801031bb:	f3 0f 1e fb          	endbr32 
801031bf:	55                   	push   %ebp
801031c0:	89 e5                	mov    %esp,%ebp
801031c2:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801031c5:	68 e0 6f 10 80       	push   $0x80106fe0
801031ca:	68 20 2d 11 80       	push   $0x80112d20
801031cf:	e8 f0 0a 00 00       	call   80103cc4 <initlock>
}
801031d4:	83 c4 10             	add    $0x10,%esp
801031d7:	c9                   	leave  
801031d8:	c3                   	ret    

801031d9 <mycpu>:
{
801031d9:	f3 0f 1e fb          	endbr32 
801031dd:	55                   	push   %ebp
801031de:	89 e5                	mov    %esp,%ebp
801031e0:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031e3:	9c                   	pushf  
801031e4:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801031e5:	f6 c4 02             	test   $0x2,%ah
801031e8:	75 2a                	jne    80103214 <mycpu+0x3b>
  apicid = lapicid();
801031ea:	e8 e3 f1 ff ff       	call   801023d2 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801031ef:	b9 00 00 00 00       	mov    $0x0,%ecx
801031f4:	39 0d 00 2d 11 80    	cmp    %ecx,0x80112d00
801031fa:	7e 37                	jle    80103233 <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801031fc:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
801031ff:	01 d2                	add    %edx,%edx
80103201:	01 ca                	add    %ecx,%edx
80103203:	c1 e2 04             	shl    $0x4,%edx
80103206:	0f b6 92 80 27 11 80 	movzbl -0x7feed880(%edx),%edx
8010320d:	39 c2                	cmp    %eax,%edx
8010320f:	74 10                	je     80103221 <mycpu+0x48>
  for (i = 0; i < ncpu; ++i) {
80103211:	41                   	inc    %ecx
80103212:	eb e0                	jmp    801031f4 <mycpu+0x1b>
    panic("mycpu called with interrupts enabled\n");
80103214:	83 ec 0c             	sub    $0xc,%esp
80103217:	68 c4 70 10 80       	push   $0x801070c4
8010321c:	e8 34 d1 ff ff       	call   80100355 <panic>
      return &cpus[i];
80103221:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
80103224:	01 c0                	add    %eax,%eax
80103226:	01 c8                	add    %ecx,%eax
80103228:	c1 e0 04             	shl    $0x4,%eax
8010322b:	8d 80 80 27 11 80    	lea    -0x7feed880(%eax),%eax
}
80103231:	c9                   	leave  
80103232:	c3                   	ret    
  panic("unknown apicid\n");
80103233:	83 ec 0c             	sub    $0xc,%esp
80103236:	68 e7 6f 10 80       	push   $0x80106fe7
8010323b:	e8 15 d1 ff ff       	call   80100355 <panic>

80103240 <cpuid>:
cpuid() {
80103240:	f3 0f 1e fb          	endbr32 
80103244:	55                   	push   %ebp
80103245:	89 e5                	mov    %esp,%ebp
80103247:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010324a:	e8 8a ff ff ff       	call   801031d9 <mycpu>
8010324f:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103254:	c1 f8 04             	sar    $0x4,%eax
80103257:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
8010325a:	89 ca                	mov    %ecx,%edx
8010325c:	c1 e2 05             	shl    $0x5,%edx
8010325f:	29 ca                	sub    %ecx,%edx
80103261:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103264:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
80103267:	89 ca                	mov    %ecx,%edx
80103269:	c1 e2 0f             	shl    $0xf,%edx
8010326c:	29 ca                	sub    %ecx,%edx
8010326e:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103271:	f7 d8                	neg    %eax
}
80103273:	c9                   	leave  
80103274:	c3                   	ret    

80103275 <myproc>:
myproc(void) {
80103275:	f3 0f 1e fb          	endbr32 
80103279:	55                   	push   %ebp
8010327a:	89 e5                	mov    %esp,%ebp
8010327c:	53                   	push   %ebx
8010327d:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103280:	e8 a2 0a 00 00       	call   80103d27 <pushcli>
  c = mycpu();
80103285:	e8 4f ff ff ff       	call   801031d9 <mycpu>
  p = c->proc;
8010328a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103290:	e8 d2 0a 00 00       	call   80103d67 <popcli>
}
80103295:	89 d8                	mov    %ebx,%eax
80103297:	83 c4 04             	add    $0x4,%esp
8010329a:	5b                   	pop    %ebx
8010329b:	5d                   	pop    %ebp
8010329c:	c3                   	ret    

8010329d <userinit>:
{
8010329d:	f3 0f 1e fb          	endbr32 
801032a1:	55                   	push   %ebp
801032a2:	89 e5                	mov    %esp,%ebp
801032a4:	53                   	push   %ebx
801032a5:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801032a8:	e8 f8 fd ff ff       	call   801030a5 <allocproc>
801032ad:	89 c3                	mov    %eax,%ebx
  initproc = p;
801032af:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801032b4:	e8 80 35 00 00       	call   80106839 <setupkvm>
801032b9:	89 43 04             	mov    %eax,0x4(%ebx)
801032bc:	85 c0                	test   %eax,%eax
801032be:	0f 84 b6 00 00 00    	je     8010337a <userinit+0xdd>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801032c4:	83 ec 04             	sub    $0x4,%esp
801032c7:	68 2c 00 00 00       	push   $0x2c
801032cc:	68 60 a4 10 80       	push   $0x8010a460
801032d1:	50                   	push   %eax
801032d2:	e8 5a 32 00 00       	call   80106531 <inituvm>
  p->sz = PGSIZE;
801032d7:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801032dd:	8b 43 18             	mov    0x18(%ebx),%eax
801032e0:	83 c4 0c             	add    $0xc,%esp
801032e3:	6a 4c                	push   $0x4c
801032e5:	6a 00                	push   $0x0
801032e7:	50                   	push   %eax
801032e8:	e8 d6 0b 00 00       	call   80103ec3 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801032ed:	8b 43 18             	mov    0x18(%ebx),%eax
801032f0:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801032f6:	8b 43 18             	mov    0x18(%ebx),%eax
801032f9:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801032ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103302:	8b 50 2c             	mov    0x2c(%eax),%edx
80103305:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103309:	8b 43 18             	mov    0x18(%ebx),%eax
8010330c:	8b 50 2c             	mov    0x2c(%eax),%edx
8010330f:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103313:	8b 43 18             	mov    0x18(%ebx),%eax
80103316:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010331d:	8b 43 18             	mov    0x18(%ebx),%eax
80103320:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103327:	8b 43 18             	mov    0x18(%ebx),%eax
8010332a:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103331:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103334:	83 c4 0c             	add    $0xc,%esp
80103337:	6a 10                	push   $0x10
80103339:	68 10 70 10 80       	push   $0x80107010
8010333e:	50                   	push   %eax
8010333f:	e8 eb 0c 00 00       	call   8010402f <safestrcpy>
  p->cwd = namei("/");
80103344:	c7 04 24 19 70 10 80 	movl   $0x80107019,(%esp)
8010334b:	e8 d2 e8 ff ff       	call   80101c22 <namei>
80103350:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103353:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010335a:	e8 b0 0a 00 00       	call   80103e0f <acquire>
  p->state = RUNNABLE;
8010335f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103366:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010336d:	e8 06 0b 00 00       	call   80103e78 <release>
}
80103372:	83 c4 10             	add    $0x10,%esp
80103375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103378:	c9                   	leave  
80103379:	c3                   	ret    
    panic("userinit: out of memory?");
8010337a:	83 ec 0c             	sub    $0xc,%esp
8010337d:	68 f7 6f 10 80       	push   $0x80106ff7
80103382:	e8 ce cf ff ff       	call   80100355 <panic>

80103387 <growproc>:
{
80103387:	f3 0f 1e fb          	endbr32 
8010338b:	55                   	push   %ebp
8010338c:	89 e5                	mov    %esp,%ebp
8010338e:	56                   	push   %esi
8010338f:	53                   	push   %ebx
80103390:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
80103393:	e8 dd fe ff ff       	call   80103275 <myproc>
80103398:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
8010339a:	8b 00                	mov    (%eax),%eax
  if(n > 0){
8010339c:	85 f6                	test   %esi,%esi
8010339e:	7f 1b                	jg     801033bb <growproc+0x34>
  } else if(n < 0){
801033a0:	78 36                	js     801033d8 <growproc+0x51>
  curproc->sz = sz;
801033a2:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(curproc->pgdir));  // Invalidate TLB.
801033a4:	8b 43 04             	mov    0x4(%ebx),%eax
801033a7:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801033ac:	0f 22 d8             	mov    %eax,%cr3
  return 0;
801033af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801033b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033b7:	5b                   	pop    %ebx
801033b8:	5e                   	pop    %esi
801033b9:	5d                   	pop    %ebp
801033ba:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801033bb:	83 ec 04             	sub    $0x4,%esp
801033be:	01 c6                	add    %eax,%esi
801033c0:	56                   	push   %esi
801033c1:	50                   	push   %eax
801033c2:	ff 73 04             	pushl  0x4(%ebx)
801033c5:	e8 05 33 00 00       	call   801066cf <allocuvm>
801033ca:	83 c4 10             	add    $0x10,%esp
801033cd:	85 c0                	test   %eax,%eax
801033cf:	75 d1                	jne    801033a2 <growproc+0x1b>
      return -1;
801033d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d6:	eb dc                	jmp    801033b4 <growproc+0x2d>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801033d8:	83 ec 04             	sub    $0x4,%esp
801033db:	01 c6                	add    %eax,%esi
801033dd:	56                   	push   %esi
801033de:	50                   	push   %eax
801033df:	ff 73 04             	pushl  0x4(%ebx)
801033e2:	e8 54 32 00 00       	call   8010663b <deallocuvm>
801033e7:	83 c4 10             	add    $0x10,%esp
801033ea:	85 c0                	test   %eax,%eax
801033ec:	75 b4                	jne    801033a2 <growproc+0x1b>
      return -1;
801033ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033f3:	eb bf                	jmp    801033b4 <growproc+0x2d>

801033f5 <fork>:
{
801033f5:	f3 0f 1e fb          	endbr32 
801033f9:	55                   	push   %ebp
801033fa:	89 e5                	mov    %esp,%ebp
801033fc:	57                   	push   %edi
801033fd:	56                   	push   %esi
801033fe:	53                   	push   %ebx
801033ff:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103402:	e8 6e fe ff ff       	call   80103275 <myproc>
80103407:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103409:	e8 97 fc ff ff       	call   801030a5 <allocproc>
8010340e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103411:	85 c0                	test   %eax,%eax
80103413:	0f 84 e8 00 00 00    	je     80103501 <fork+0x10c>
80103419:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010341b:	83 ec 08             	sub    $0x8,%esp
8010341e:	ff 33                	pushl  (%ebx)
80103420:	ff 73 04             	pushl  0x4(%ebx)
80103423:	e8 d0 34 00 00       	call   801068f8 <copyuvm>
80103428:	89 47 04             	mov    %eax,0x4(%edi)
8010342b:	83 c4 10             	add    $0x10,%esp
8010342e:	85 c0                	test   %eax,%eax
80103430:	74 34                	je     80103466 <fork+0x71>
  np->sz = curproc->sz;
80103432:	8b 03                	mov    (%ebx),%eax
80103434:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103437:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103439:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
8010343c:	8b 73 18             	mov    0x18(%ebx),%esi
8010343f:	8b 7a 18             	mov    0x18(%edx),%edi
80103442:	b9 13 00 00 00       	mov    $0x13,%ecx
80103447:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->prio = curproc->prio;
80103449:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
8010344f:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  np->tf->eax = 0;
80103455:	8b 42 18             	mov    0x18(%edx),%eax
80103458:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010345f:	be 00 00 00 00       	mov    $0x0,%esi
80103464:	eb 3a                	jmp    801034a0 <fork+0xab>
    kfree(np->kstack);
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010346c:	ff 73 08             	pushl  0x8(%ebx)
8010346f:	e8 71 eb ff ff       	call   80101fe5 <kfree>
    np->kstack = 0;
80103474:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010347b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103482:	83 c4 10             	add    $0x10,%esp
80103485:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010348a:	eb 6b                	jmp    801034f7 <fork+0x102>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010348c:	83 ec 0c             	sub    $0xc,%esp
8010348f:	50                   	push   %eax
80103490:	e8 01 d8 ff ff       	call   80100c96 <filedup>
80103495:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103498:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
8010349c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
8010349f:	46                   	inc    %esi
801034a0:	83 fe 0f             	cmp    $0xf,%esi
801034a3:	7f 0a                	jg     801034af <fork+0xba>
    if(curproc->ofile[i])
801034a5:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801034a9:	85 c0                	test   %eax,%eax
801034ab:	75 df                	jne    8010348c <fork+0x97>
801034ad:	eb f0                	jmp    8010349f <fork+0xaa>
  np->cwd = idup(curproc->cwd);
801034af:	83 ec 0c             	sub    $0xc,%esp
801034b2:	ff 73 68             	pushl  0x68(%ebx)
801034b5:	e8 aa e0 ff ff       	call   80101564 <idup>
801034ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801034bd:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801034c0:	83 c3 6c             	add    $0x6c,%ebx
801034c3:	8d 47 6c             	lea    0x6c(%edi),%eax
801034c6:	83 c4 0c             	add    $0xc,%esp
801034c9:	6a 10                	push   $0x10
801034cb:	53                   	push   %ebx
801034cc:	50                   	push   %eax
801034cd:	e8 5d 0b 00 00       	call   8010402f <safestrcpy>
  pid = np->pid;
801034d2:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801034d5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034dc:	e8 2e 09 00 00       	call   80103e0f <acquire>
  np->state = RUNNABLE;
801034e1:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801034e8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034ef:	e8 84 09 00 00       	call   80103e78 <release>
  return pid;
801034f4:	83 c4 10             	add    $0x10,%esp
}
801034f7:	89 d8                	mov    %ebx,%eax
801034f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034fc:	5b                   	pop    %ebx
801034fd:	5e                   	pop    %esi
801034fe:	5f                   	pop    %edi
801034ff:	5d                   	pop    %ebp
80103500:	c3                   	ret    
    return -1;
80103501:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103506:	eb ef                	jmp    801034f7 <fork+0x102>

80103508 <scheduler>:
{
80103508:	f3 0f 1e fb          	endbr32 
8010350c:	55                   	push   %ebp
8010350d:	89 e5                	mov    %esp,%ebp
8010350f:	57                   	push   %edi
80103510:	56                   	push   %esi
80103511:	53                   	push   %ebx
80103512:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103515:	e8 bf fc ff ff       	call   801031d9 <mycpu>
8010351a:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010351c:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103523:	00 00 00 
  struct proc* ultimo_proceso_ejecutado_norm = 0; // Variable para guardar el ultimo proceso de prioridad normal ejecutado
80103526:	bf 00 00 00 00       	mov    $0x0,%edi
8010352b:	e9 eb 00 00 00       	jmp    8010361b <scheduler+0x113>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103530:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103536:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
8010353c:	73 4d                	jae    8010358b <scheduler+0x83>
      if(p->prio != HI_PRIO || p->state != RUNNABLE)
8010353e:	83 bb 84 00 00 00 01 	cmpl   $0x1,0x84(%ebx)
80103545:	75 e9                	jne    80103530 <scheduler+0x28>
80103547:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010354b:	75 e3                	jne    80103530 <scheduler+0x28>
      c->proc = p;
8010354d:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103553:	83 ec 0c             	sub    $0xc,%esp
80103556:	53                   	push   %ebx
80103557:	e8 bc 2e 00 00       	call   80106418 <switchuvm>
      p->state = RUNNING;
8010355c:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103563:	83 c4 08             	add    $0x8,%esp
80103566:	ff 73 1c             	pushl  0x1c(%ebx)
80103569:	8d 46 04             	lea    0x4(%esi),%eax
8010356c:	50                   	push   %eax
8010356d:	e8 13 0b 00 00       	call   80104085 <swtch>
      switchkvm();
80103572:	e8 8f 2e 00 00       	call   80106406 <switchkvm>
      c->proc = 0;
80103577:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010357e:	00 00 00 
80103581:	83 c4 10             	add    $0x10,%esp
      flagHI = 1;
80103584:	b8 01 00 00 00       	mov    $0x1,%eax
80103589:	eb a5                	jmp    80103530 <scheduler+0x28>
    if(!flagHI){
8010358b:	85 c0                	test   %eax,%eax
8010358d:	75 7c                	jne    8010360b <scheduler+0x103>
      p = ultimo_proceso_ejecutado_norm ? (ultimo_proceso_ejecutado_norm + 1) : ptable.proc; 
8010358f:	85 ff                	test   %edi,%edi
80103591:	74 08                	je     8010359b <scheduler+0x93>
80103593:	8d 9f 88 00 00 00    	lea    0x88(%edi),%ebx
80103599:	eb 0d                	jmp    801035a8 <scheduler+0xa0>
8010359b:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801035a0:	eb 06                	jmp    801035a8 <scheduler+0xa0>
      for(;p < &ptable.proc[NPROC]; p++){
801035a2:	81 c3 88 00 00 00    	add    $0x88,%ebx
801035a8:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801035ae:	73 48                	jae    801035f8 <scheduler+0xf0>
        if(p->prio != NORM_PRIO || p->state != RUNNABLE)
801035b0:	83 bb 84 00 00 00 00 	cmpl   $0x0,0x84(%ebx)
801035b7:	75 e9                	jne    801035a2 <scheduler+0x9a>
801035b9:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801035bd:	75 e3                	jne    801035a2 <scheduler+0x9a>
        c->proc = p;
801035bf:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
801035c5:	83 ec 0c             	sub    $0xc,%esp
801035c8:	53                   	push   %ebx
801035c9:	e8 4a 2e 00 00       	call   80106418 <switchuvm>
        p->state = RUNNING;
801035ce:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler), p->context);
801035d5:	83 c4 08             	add    $0x8,%esp
801035d8:	ff 73 1c             	pushl  0x1c(%ebx)
801035db:	8d 46 04             	lea    0x4(%esi),%eax
801035de:	50                   	push   %eax
801035df:	e8 a1 0a 00 00       	call   80104085 <swtch>
        switchkvm();
801035e4:	e8 1d 2e 00 00       	call   80106406 <switchkvm>
        c->proc = 0;
801035e9:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801035f0:	00 00 00 
        break;
801035f3:	83 c4 10             	add    $0x10,%esp
        ultimo_proceso_ejecutado_norm = p; 
801035f6:	89 df                	mov    %ebx,%edi
      if(p+1 >= &ptable.proc[NPROC]){
801035f8:	81 c3 88 00 00 00    	add    $0x88,%ebx
801035fe:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103604:	72 05                	jb     8010360b <scheduler+0x103>
        ultimo_proceso_ejecutado_norm = 0;
80103606:	bf 00 00 00 00       	mov    $0x0,%edi
    release(&ptable.lock);
8010360b:	83 ec 0c             	sub    $0xc,%esp
8010360e:	68 20 2d 11 80       	push   $0x80112d20
80103613:	e8 60 08 00 00       	call   80103e78 <release>
    sti();
80103618:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
8010361b:	fb                   	sti    
    acquire(&ptable.lock);
8010361c:	83 ec 0c             	sub    $0xc,%esp
8010361f:	68 20 2d 11 80       	push   $0x80112d20
80103624:	e8 e6 07 00 00       	call   80103e0f <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103629:	83 c4 10             	add    $0x10,%esp
    flagHI = 0;
8010362c:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103631:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103636:	e9 fb fe ff ff       	jmp    80103536 <scheduler+0x2e>

8010363b <sched>:
{
8010363b:	f3 0f 1e fb          	endbr32 
8010363f:	55                   	push   %ebp
80103640:	89 e5                	mov    %esp,%ebp
80103642:	56                   	push   %esi
80103643:	53                   	push   %ebx
  struct proc *p = myproc();
80103644:	e8 2c fc ff ff       	call   80103275 <myproc>
80103649:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
8010364b:	83 ec 0c             	sub    $0xc,%esp
8010364e:	68 20 2d 11 80       	push   $0x80112d20
80103653:	e8 73 07 00 00       	call   80103dcb <holding>
80103658:	83 c4 10             	add    $0x10,%esp
8010365b:	85 c0                	test   %eax,%eax
8010365d:	74 4f                	je     801036ae <sched+0x73>
  if(mycpu()->ncli != 1)
8010365f:	e8 75 fb ff ff       	call   801031d9 <mycpu>
80103664:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010366b:	75 4e                	jne    801036bb <sched+0x80>
  if(p->state == RUNNING)
8010366d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103671:	74 55                	je     801036c8 <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103673:	9c                   	pushf  
80103674:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103675:	f6 c4 02             	test   $0x2,%ah
80103678:	75 5b                	jne    801036d5 <sched+0x9a>
  intena = mycpu()->intena;
8010367a:	e8 5a fb ff ff       	call   801031d9 <mycpu>
8010367f:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103685:	e8 4f fb ff ff       	call   801031d9 <mycpu>
8010368a:	83 ec 08             	sub    $0x8,%esp
8010368d:	ff 70 04             	pushl  0x4(%eax)
80103690:	83 c3 1c             	add    $0x1c,%ebx
80103693:	53                   	push   %ebx
80103694:	e8 ec 09 00 00       	call   80104085 <swtch>
  mycpu()->intena = intena;
80103699:	e8 3b fb ff ff       	call   801031d9 <mycpu>
8010369e:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801036a4:	83 c4 10             	add    $0x10,%esp
801036a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036aa:	5b                   	pop    %ebx
801036ab:	5e                   	pop    %esi
801036ac:	5d                   	pop    %ebp
801036ad:	c3                   	ret    
    panic("sched ptable.lock");
801036ae:	83 ec 0c             	sub    $0xc,%esp
801036b1:	68 1b 70 10 80       	push   $0x8010701b
801036b6:	e8 9a cc ff ff       	call   80100355 <panic>
    panic("sched locks");
801036bb:	83 ec 0c             	sub    $0xc,%esp
801036be:	68 2d 70 10 80       	push   $0x8010702d
801036c3:	e8 8d cc ff ff       	call   80100355 <panic>
    panic("sched running");
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	68 39 70 10 80       	push   $0x80107039
801036d0:	e8 80 cc ff ff       	call   80100355 <panic>
    panic("sched interruptible");
801036d5:	83 ec 0c             	sub    $0xc,%esp
801036d8:	68 47 70 10 80       	push   $0x80107047
801036dd:	e8 73 cc ff ff       	call   80100355 <panic>

801036e2 <exit>:
{
801036e2:	f3 0f 1e fb          	endbr32 
801036e6:	55                   	push   %ebp
801036e7:	89 e5                	mov    %esp,%ebp
801036e9:	56                   	push   %esi
801036ea:	53                   	push   %ebx
  struct proc *curproc = myproc();
801036eb:	e8 85 fb ff ff       	call   80103275 <myproc>
801036f0:	89 c6                	mov    %eax,%esi
  curproc->exit_status = status; // Guardamos el estado de salida en la estructura del proceso
801036f2:	8b 45 08             	mov    0x8(%ebp),%eax
801036f5:	89 46 7c             	mov    %eax,0x7c(%esi)
  if(curproc == initproc)
801036f8:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
801036fe:	74 07                	je     80103707 <exit+0x25>
  for(fd = 0; fd < NOFILE; fd++){
80103700:	bb 00 00 00 00       	mov    $0x0,%ebx
80103705:	eb 22                	jmp    80103729 <exit+0x47>
    panic("init exiting");
80103707:	83 ec 0c             	sub    $0xc,%esp
8010370a:	68 5b 70 10 80       	push   $0x8010705b
8010370f:	e8 41 cc ff ff       	call   80100355 <panic>
      fileclose(curproc->ofile[fd]);
80103714:	83 ec 0c             	sub    $0xc,%esp
80103717:	50                   	push   %eax
80103718:	e8 c0 d5 ff ff       	call   80100cdd <fileclose>
      curproc->ofile[fd] = 0;
8010371d:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
80103724:	00 
80103725:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103728:	43                   	inc    %ebx
80103729:	83 fb 0f             	cmp    $0xf,%ebx
8010372c:	7f 0a                	jg     80103738 <exit+0x56>
    if(curproc->ofile[fd]){
8010372e:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
80103732:	85 c0                	test   %eax,%eax
80103734:	75 de                	jne    80103714 <exit+0x32>
80103736:	eb f0                	jmp    80103728 <exit+0x46>
  begin_op();
80103738:	e8 a6 f0 ff ff       	call   801027e3 <begin_op>
  iput(curproc->cwd);
8010373d:	83 ec 0c             	sub    $0xc,%esp
80103740:	ff 76 68             	pushl  0x68(%esi)
80103743:	e8 5b df ff ff       	call   801016a3 <iput>
  end_op();
80103748:	e8 16 f1 ff ff       	call   80102863 <end_op>
  curproc->cwd = 0;
8010374d:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103754:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010375b:	e8 af 06 00 00       	call   80103e0f <acquire>
  wakeup1(curproc->parent);
80103760:	8b 46 14             	mov    0x14(%esi),%eax
80103763:	e8 13 f9 ff ff       	call   8010307b <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103768:	83 c4 10             	add    $0x10,%esp
8010376b:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103770:	eb 06                	jmp    80103778 <exit+0x96>
80103772:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103778:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
8010377e:	73 1a                	jae    8010379a <exit+0xb8>
    if(p->parent == curproc){
80103780:	39 73 14             	cmp    %esi,0x14(%ebx)
80103783:	75 ed                	jne    80103772 <exit+0x90>
      p->parent = initproc;
80103785:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
8010378a:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010378d:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103791:	75 df                	jne    80103772 <exit+0x90>
        wakeup1(initproc);
80103793:	e8 e3 f8 ff ff       	call   8010307b <wakeup1>
80103798:	eb d8                	jmp    80103772 <exit+0x90>
  deallocuvm(curproc->pgdir, KERNBASE, 0);
8010379a:	83 ec 04             	sub    $0x4,%esp
8010379d:	6a 00                	push   $0x0
8010379f:	68 00 00 00 80       	push   $0x80000000
801037a4:	ff 76 04             	pushl  0x4(%esi)
801037a7:	e8 8f 2e 00 00       	call   8010663b <deallocuvm>
  curproc->state = ZOMBIE;
801037ac:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801037b3:	e8 83 fe ff ff       	call   8010363b <sched>
  panic("zombie exit");
801037b8:	c7 04 24 68 70 10 80 	movl   $0x80107068,(%esp)
801037bf:	e8 91 cb ff ff       	call   80100355 <panic>

801037c4 <yield>:
{
801037c4:	f3 0f 1e fb          	endbr32 
801037c8:	55                   	push   %ebp
801037c9:	89 e5                	mov    %esp,%ebp
801037cb:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801037ce:	68 20 2d 11 80       	push   $0x80112d20
801037d3:	e8 37 06 00 00       	call   80103e0f <acquire>
  myproc()->state = RUNNABLE;
801037d8:	e8 98 fa ff ff       	call   80103275 <myproc>
801037dd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801037e4:	e8 52 fe ff ff       	call   8010363b <sched>
  release(&ptable.lock);
801037e9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037f0:	e8 83 06 00 00       	call   80103e78 <release>
}
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	c9                   	leave  
801037f9:	c3                   	ret    

801037fa <sleep>:
{
801037fa:	f3 0f 1e fb          	endbr32 
801037fe:	55                   	push   %ebp
801037ff:	89 e5                	mov    %esp,%ebp
80103801:	56                   	push   %esi
80103802:	53                   	push   %ebx
80103803:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103806:	e8 6a fa ff ff       	call   80103275 <myproc>
  if(p == 0)
8010380b:	85 c0                	test   %eax,%eax
8010380d:	74 66                	je     80103875 <sleep+0x7b>
8010380f:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
80103811:	85 f6                	test   %esi,%esi
80103813:	74 6d                	je     80103882 <sleep+0x88>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103815:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010381b:	74 18                	je     80103835 <sleep+0x3b>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010381d:	83 ec 0c             	sub    $0xc,%esp
80103820:	68 20 2d 11 80       	push   $0x80112d20
80103825:	e8 e5 05 00 00       	call   80103e0f <acquire>
    release(lk);
8010382a:	89 34 24             	mov    %esi,(%esp)
8010382d:	e8 46 06 00 00       	call   80103e78 <release>
80103832:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80103835:	8b 45 08             	mov    0x8(%ebp),%eax
80103838:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
8010383b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103842:	e8 f4 fd ff ff       	call   8010363b <sched>
  p->chan = 0;
80103847:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010384e:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103854:	74 18                	je     8010386e <sleep+0x74>
    release(&ptable.lock);
80103856:	83 ec 0c             	sub    $0xc,%esp
80103859:	68 20 2d 11 80       	push   $0x80112d20
8010385e:	e8 15 06 00 00       	call   80103e78 <release>
    acquire(lk);
80103863:	89 34 24             	mov    %esi,(%esp)
80103866:	e8 a4 05 00 00       	call   80103e0f <acquire>
8010386b:	83 c4 10             	add    $0x10,%esp
}
8010386e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103871:	5b                   	pop    %ebx
80103872:	5e                   	pop    %esi
80103873:	5d                   	pop    %ebp
80103874:	c3                   	ret    
    panic("sleep");
80103875:	83 ec 0c             	sub    $0xc,%esp
80103878:	68 74 70 10 80       	push   $0x80107074
8010387d:	e8 d3 ca ff ff       	call   80100355 <panic>
    panic("sleep without lk");
80103882:	83 ec 0c             	sub    $0xc,%esp
80103885:	68 7a 70 10 80       	push   $0x8010707a
8010388a:	e8 c6 ca ff ff       	call   80100355 <panic>

8010388f <wait>:
{
8010388f:	f3 0f 1e fb          	endbr32 
80103893:	55                   	push   %ebp
80103894:	89 e5                	mov    %esp,%ebp
80103896:	56                   	push   %esi
80103897:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103898:	e8 d8 f9 ff ff       	call   80103275 <myproc>
8010389d:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
8010389f:	83 ec 0c             	sub    $0xc,%esp
801038a2:	68 20 2d 11 80       	push   $0x80112d20
801038a7:	e8 63 05 00 00       	call   80103e0f <acquire>
801038ac:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801038af:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801038b9:	eb 68                	jmp    80103923 <wait+0x94>
        pid = p->pid;
801038bb:	8b 73 10             	mov    0x10(%ebx),%esi
        *status = p->exit_status; // Guardamos el estado de salida del proceso hijo cuando este termina
801038be:	8b 53 7c             	mov    0x7c(%ebx),%edx
801038c1:	8b 45 08             	mov    0x8(%ebp),%eax
801038c4:	89 10                	mov    %edx,(%eax)
        kfree(p->kstack);
801038c6:	83 ec 0c             	sub    $0xc,%esp
801038c9:	ff 73 08             	pushl  0x8(%ebx)
801038cc:	e8 14 e7 ff ff       	call   80101fe5 <kfree>
        p->kstack = 0;
801038d1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir, 0); // User zone deleted before
801038d8:	83 c4 08             	add    $0x8,%esp
801038db:	6a 00                	push   $0x0
801038dd:	ff 73 04             	pushl  0x4(%ebx)
801038e0:	e8 da 2e 00 00       	call   801067bf <freevm>
        p->pid = 0;
801038e5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801038ec:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801038f3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801038f7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801038fe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103905:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010390c:	e8 67 05 00 00       	call   80103e78 <release>
        return pid;
80103911:	83 c4 10             	add    $0x10,%esp
}
80103914:	89 f0                	mov    %esi,%eax
80103916:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103919:	5b                   	pop    %ebx
8010391a:	5e                   	pop    %esi
8010391b:	5d                   	pop    %ebp
8010391c:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010391d:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103923:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103929:	73 12                	jae    8010393d <wait+0xae>
      if(p->parent != curproc)
8010392b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010392e:	75 ed                	jne    8010391d <wait+0x8e>
      if(p->state == ZOMBIE){
80103930:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103934:	74 85                	je     801038bb <wait+0x2c>
      havekids = 1;
80103936:	b8 01 00 00 00       	mov    $0x1,%eax
8010393b:	eb e0                	jmp    8010391d <wait+0x8e>
    if(!havekids || curproc->killed){
8010393d:	85 c0                	test   %eax,%eax
8010393f:	74 06                	je     80103947 <wait+0xb8>
80103941:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103945:	74 17                	je     8010395e <wait+0xcf>
      release(&ptable.lock);
80103947:	83 ec 0c             	sub    $0xc,%esp
8010394a:	68 20 2d 11 80       	push   $0x80112d20
8010394f:	e8 24 05 00 00       	call   80103e78 <release>
      return -1;
80103954:	83 c4 10             	add    $0x10,%esp
80103957:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010395c:	eb b6                	jmp    80103914 <wait+0x85>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010395e:	83 ec 08             	sub    $0x8,%esp
80103961:	68 20 2d 11 80       	push   $0x80112d20
80103966:	56                   	push   %esi
80103967:	e8 8e fe ff ff       	call   801037fa <sleep>
    havekids = 0;
8010396c:	83 c4 10             	add    $0x10,%esp
8010396f:	e9 3b ff ff ff       	jmp    801038af <wait+0x20>

80103974 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103974:	f3 0f 1e fb          	endbr32 
80103978:	55                   	push   %ebp
80103979:	89 e5                	mov    %esp,%ebp
8010397b:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010397e:	68 20 2d 11 80       	push   $0x80112d20
80103983:	e8 87 04 00 00       	call   80103e0f <acquire>
  wakeup1(chan);
80103988:	8b 45 08             	mov    0x8(%ebp),%eax
8010398b:	e8 eb f6 ff ff       	call   8010307b <wakeup1>
  release(&ptable.lock);
80103990:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103997:	e8 dc 04 00 00       	call   80103e78 <release>
}
8010399c:	83 c4 10             	add    $0x10,%esp
8010399f:	c9                   	leave  
801039a0:	c3                   	ret    

801039a1 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801039a1:	f3 0f 1e fb          	endbr32 
801039a5:	55                   	push   %ebp
801039a6:	89 e5                	mov    %esp,%ebp
801039a8:	53                   	push   %ebx
801039a9:	83 ec 10             	sub    $0x10,%esp
801039ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801039af:	68 20 2d 11 80       	push   $0x80112d20
801039b4:	e8 56 04 00 00       	call   80103e0f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b9:	83 c4 10             	add    $0x10,%esp
801039bc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801039c1:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801039c6:	73 3c                	jae    80103a04 <kill+0x63>
    if(p->pid == pid){
801039c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801039cb:	74 07                	je     801039d4 <kill+0x33>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039cd:	05 88 00 00 00       	add    $0x88,%eax
801039d2:	eb ed                	jmp    801039c1 <kill+0x20>
      p->killed = 1;
801039d4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801039db:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801039df:	74 1a                	je     801039fb <kill+0x5a>
        p->state = RUNNABLE;
      release(&ptable.lock);
801039e1:	83 ec 0c             	sub    $0xc,%esp
801039e4:	68 20 2d 11 80       	push   $0x80112d20
801039e9:	e8 8a 04 00 00       	call   80103e78 <release>
      return 0;
801039ee:	83 c4 10             	add    $0x10,%esp
801039f1:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801039f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039f9:	c9                   	leave  
801039fa:	c3                   	ret    
        p->state = RUNNABLE;
801039fb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103a02:	eb dd                	jmp    801039e1 <kill+0x40>
  release(&ptable.lock);
80103a04:	83 ec 0c             	sub    $0xc,%esp
80103a07:	68 20 2d 11 80       	push   $0x80112d20
80103a0c:	e8 67 04 00 00       	call   80103e78 <release>
  return -1;
80103a11:	83 c4 10             	add    $0x10,%esp
80103a14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a19:	eb db                	jmp    801039f6 <kill+0x55>

80103a1b <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103a1b:	f3 0f 1e fb          	endbr32 
80103a1f:	55                   	push   %ebp
80103a20:	89 e5                	mov    %esp,%ebp
80103a22:	56                   	push   %esi
80103a23:	53                   	push   %ebx
80103a24:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a27:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103a2c:	eb 36                	jmp    80103a64 <procdump+0x49>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103a2e:	b8 8b 70 10 80       	mov    $0x8010708b,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103a33:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103a36:	52                   	push   %edx
80103a37:	50                   	push   %eax
80103a38:	ff 73 10             	pushl  0x10(%ebx)
80103a3b:	68 8f 70 10 80       	push   $0x8010708f
80103a40:	e8 b8 cb ff ff       	call   801005fd <cprintf>
    if(p->state == SLEEPING){
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103a4c:	74 3c                	je     80103a8a <procdump+0x6f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103a4e:	83 ec 0c             	sub    $0xc,%esp
80103a51:	68 93 74 10 80       	push   $0x80107493
80103a56:	e8 a2 cb ff ff       	call   801005fd <cprintf>
80103a5b:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a5e:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103a64:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103a6a:	73 5f                	jae    80103acb <procdump+0xb0>
    if(p->state == UNUSED)
80103a6c:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a6f:	85 c0                	test   %eax,%eax
80103a71:	74 eb                	je     80103a5e <procdump+0x43>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a73:	83 f8 05             	cmp    $0x5,%eax
80103a76:	77 b6                	ja     80103a2e <procdump+0x13>
80103a78:	8b 04 85 ec 70 10 80 	mov    -0x7fef8f14(,%eax,4),%eax
80103a7f:	85 c0                	test   %eax,%eax
80103a81:	75 b0                	jne    80103a33 <procdump+0x18>
      state = "???";
80103a83:	b8 8b 70 10 80       	mov    $0x8010708b,%eax
80103a88:	eb a9                	jmp    80103a33 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103a8a:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a8d:	8b 40 0c             	mov    0xc(%eax),%eax
80103a90:	83 c0 08             	add    $0x8,%eax
80103a93:	83 ec 08             	sub    $0x8,%esp
80103a96:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103a99:	52                   	push   %edx
80103a9a:	50                   	push   %eax
80103a9b:	e8 43 02 00 00       	call   80103ce3 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103aa0:	83 c4 10             	add    $0x10,%esp
80103aa3:	be 00 00 00 00       	mov    $0x0,%esi
80103aa8:	eb 12                	jmp    80103abc <procdump+0xa1>
        cprintf(" %p", pc[i]);
80103aaa:	83 ec 08             	sub    $0x8,%esp
80103aad:	50                   	push   %eax
80103aae:	68 e1 6a 10 80       	push   $0x80106ae1
80103ab3:	e8 45 cb ff ff       	call   801005fd <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103ab8:	46                   	inc    %esi
80103ab9:	83 c4 10             	add    $0x10,%esp
80103abc:	83 fe 09             	cmp    $0x9,%esi
80103abf:	7f 8d                	jg     80103a4e <procdump+0x33>
80103ac1:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103ac5:	85 c0                	test   %eax,%eax
80103ac7:	75 e1                	jne    80103aaa <procdump+0x8f>
80103ac9:	eb 83                	jmp    80103a4e <procdump+0x33>
  }
}
80103acb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ace:	5b                   	pop    %ebx
80103acf:	5e                   	pop    %esi
80103ad0:	5d                   	pop    %ebp
80103ad1:	c3                   	ret    

80103ad2 <getprio>:

enum proc_prio
getprio(int pid)
{
80103ad2:	f3 0f 1e fb          	endbr32 
80103ad6:	55                   	push   %ebp
80103ad7:	89 e5                	mov    %esp,%ebp
80103ad9:	56                   	push   %esi
80103ada:	53                   	push   %ebx
80103adb:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;
  acquire(&ptable.lock);
80103ade:	83 ec 0c             	sub    $0xc,%esp
80103ae1:	68 20 2d 11 80       	push   $0x80112d20
80103ae6:	e8 24 03 00 00       	call   80103e0f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aeb:	83 c4 10             	add    $0x10,%esp
80103aee:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103af3:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103af9:	73 2a                	jae    80103b25 <getprio+0x53>
    if(p->pid == pid){
80103afb:	39 73 10             	cmp    %esi,0x10(%ebx)
80103afe:	74 08                	je     80103b08 <getprio+0x36>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b00:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103b06:	eb eb                	jmp    80103af3 <getprio+0x21>
      release(&ptable.lock);
80103b08:	83 ec 0c             	sub    $0xc,%esp
80103b0b:	68 20 2d 11 80       	push   $0x80112d20
80103b10:	e8 63 03 00 00       	call   80103e78 <release>
      return p->prio;
80103b15:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103b1b:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1; 
}
80103b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b21:	5b                   	pop    %ebx
80103b22:	5e                   	pop    %esi
80103b23:	5d                   	pop    %ebp
80103b24:	c3                   	ret    
  release(&ptable.lock);
80103b25:	83 ec 0c             	sub    $0xc,%esp
80103b28:	68 20 2d 11 80       	push   $0x80112d20
80103b2d:	e8 46 03 00 00       	call   80103e78 <release>
  return -1; 
80103b32:	83 c4 10             	add    $0x10,%esp
80103b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b3a:	eb e2                	jmp    80103b1e <getprio+0x4c>

80103b3c <setprio>:


int
setprio(int pid, enum proc_prio prio)
{
80103b3c:	f3 0f 1e fb          	endbr32 
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	53                   	push   %ebx
80103b44:	83 ec 10             	sub    $0x10,%esp
80103b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  acquire(&ptable.lock);
80103b4a:	68 20 2d 11 80       	push   $0x80112d20
80103b4f:	e8 bb 02 00 00       	call   80103e0f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b54:	83 c4 10             	add    $0x10,%esp
80103b57:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103b5c:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103b61:	73 2f                	jae    80103b92 <setprio+0x56>
    if(p->pid == pid){
80103b63:	39 58 10             	cmp    %ebx,0x10(%eax)
80103b66:	74 07                	je     80103b6f <setprio+0x33>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b68:	05 88 00 00 00       	add    $0x88,%eax
80103b6d:	eb ed                	jmp    80103b5c <setprio+0x20>
      p->prio = prio;
80103b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b72:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
      release(&ptable.lock);
80103b78:	83 ec 0c             	sub    $0xc,%esp
80103b7b:	68 20 2d 11 80       	push   $0x80112d20
80103b80:	e8 f3 02 00 00       	call   80103e78 <release>
      return 0;
80103b85:	83 c4 10             	add    $0x10,%esp
80103b88:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1; 
80103b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b90:	c9                   	leave  
80103b91:	c3                   	ret    
  release(&ptable.lock);
80103b92:	83 ec 0c             	sub    $0xc,%esp
80103b95:	68 20 2d 11 80       	push   $0x80112d20
80103b9a:	e8 d9 02 00 00       	call   80103e78 <release>
  return -1; 
80103b9f:	83 c4 10             	add    $0x10,%esp
80103ba2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ba7:	eb e4                	jmp    80103b8d <setprio+0x51>

80103ba9 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103ba9:	f3 0f 1e fb          	endbr32 
80103bad:	55                   	push   %ebp
80103bae:	89 e5                	mov    %esp,%ebp
80103bb0:	53                   	push   %ebx
80103bb1:	83 ec 0c             	sub    $0xc,%esp
80103bb4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103bb7:	68 04 71 10 80       	push   $0x80107104
80103bbc:	8d 43 04             	lea    0x4(%ebx),%eax
80103bbf:	50                   	push   %eax
80103bc0:	e8 ff 00 00 00       	call   80103cc4 <initlock>
  lk->name = name;
80103bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bc8:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103bcb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103bd1:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103bd8:	83 c4 10             	add    $0x10,%esp
80103bdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bde:	c9                   	leave  
80103bdf:	c3                   	ret    

80103be0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	56                   	push   %esi
80103be8:	53                   	push   %ebx
80103be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103bec:	8d 73 04             	lea    0x4(%ebx),%esi
80103bef:	83 ec 0c             	sub    $0xc,%esp
80103bf2:	56                   	push   %esi
80103bf3:	e8 17 02 00 00       	call   80103e0f <acquire>
  while (lk->locked) {
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	83 3b 00             	cmpl   $0x0,(%ebx)
80103bfe:	74 0f                	je     80103c0f <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80103c00:	83 ec 08             	sub    $0x8,%esp
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
80103c05:	e8 f0 fb ff ff       	call   801037fa <sleep>
80103c0a:	83 c4 10             	add    $0x10,%esp
80103c0d:	eb ec                	jmp    80103bfb <acquiresleep+0x1b>
  }
  lk->locked = 1;
80103c0f:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103c15:	e8 5b f6 ff ff       	call   80103275 <myproc>
80103c1a:	8b 40 10             	mov    0x10(%eax),%eax
80103c1d:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	56                   	push   %esi
80103c24:	e8 4f 02 00 00       	call   80103e78 <release>
}
80103c29:	83 c4 10             	add    $0x10,%esp
80103c2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c2f:	5b                   	pop    %ebx
80103c30:	5e                   	pop    %esi
80103c31:	5d                   	pop    %ebp
80103c32:	c3                   	ret    

80103c33 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103c33:	f3 0f 1e fb          	endbr32 
80103c37:	55                   	push   %ebp
80103c38:	89 e5                	mov    %esp,%ebp
80103c3a:	56                   	push   %esi
80103c3b:	53                   	push   %ebx
80103c3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103c3f:	8d 73 04             	lea    0x4(%ebx),%esi
80103c42:	83 ec 0c             	sub    $0xc,%esp
80103c45:	56                   	push   %esi
80103c46:	e8 c4 01 00 00       	call   80103e0f <acquire>
  lk->locked = 0;
80103c4b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103c51:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103c58:	89 1c 24             	mov    %ebx,(%esp)
80103c5b:	e8 14 fd ff ff       	call   80103974 <wakeup>
  release(&lk->lk);
80103c60:	89 34 24             	mov    %esi,(%esp)
80103c63:	e8 10 02 00 00       	call   80103e78 <release>
}
80103c68:	83 c4 10             	add    $0x10,%esp
80103c6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c6e:	5b                   	pop    %ebx
80103c6f:	5e                   	pop    %esi
80103c70:	5d                   	pop    %ebp
80103c71:	c3                   	ret    

80103c72 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103c72:	f3 0f 1e fb          	endbr32 
80103c76:	55                   	push   %ebp
80103c77:	89 e5                	mov    %esp,%ebp
80103c79:	56                   	push   %esi
80103c7a:	53                   	push   %ebx
80103c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103c7e:	8d 73 04             	lea    0x4(%ebx),%esi
80103c81:	83 ec 0c             	sub    $0xc,%esp
80103c84:	56                   	push   %esi
80103c85:	e8 85 01 00 00       	call   80103e0f <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103c8a:	83 c4 10             	add    $0x10,%esp
80103c8d:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c90:	75 17                	jne    80103ca9 <holdingsleep+0x37>
80103c92:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103c97:	83 ec 0c             	sub    $0xc,%esp
80103c9a:	56                   	push   %esi
80103c9b:	e8 d8 01 00 00       	call   80103e78 <release>
  return r;
}
80103ca0:	89 d8                	mov    %ebx,%eax
80103ca2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ca5:	5b                   	pop    %ebx
80103ca6:	5e                   	pop    %esi
80103ca7:	5d                   	pop    %ebp
80103ca8:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103ca9:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103cac:	e8 c4 f5 ff ff       	call   80103275 <myproc>
80103cb1:	3b 58 10             	cmp    0x10(%eax),%ebx
80103cb4:	74 07                	je     80103cbd <holdingsleep+0x4b>
80103cb6:	bb 00 00 00 00       	mov    $0x0,%ebx
80103cbb:	eb da                	jmp    80103c97 <holdingsleep+0x25>
80103cbd:	bb 01 00 00 00       	mov    $0x1,%ebx
80103cc2:	eb d3                	jmp    80103c97 <holdingsleep+0x25>

80103cc4 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103cc4:	f3 0f 1e fb          	endbr32 
80103cc8:	55                   	push   %ebp
80103cc9:	89 e5                	mov    %esp,%ebp
80103ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103cce:	8b 55 0c             	mov    0xc(%ebp),%edx
80103cd1:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103cd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103cda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103ce1:	5d                   	pop    %ebp
80103ce2:	c3                   	ret    

80103ce3 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103ce3:	f3 0f 1e fb          	endbr32 
80103ce7:	55                   	push   %ebp
80103ce8:	89 e5                	mov    %esp,%ebp
80103cea:	53                   	push   %ebx
80103ceb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103cee:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf1:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103cf4:	b8 00 00 00 00       	mov    $0x0,%eax
80103cf9:	83 f8 09             	cmp    $0x9,%eax
80103cfc:	7f 21                	jg     80103d1f <getcallerpcs+0x3c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103cfe:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103d04:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103d0a:	77 13                	ja     80103d1f <getcallerpcs+0x3c>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103d0c:	8b 5a 04             	mov    0x4(%edx),%ebx
80103d0f:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103d12:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103d14:	40                   	inc    %eax
80103d15:	eb e2                	jmp    80103cf9 <getcallerpcs+0x16>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103d17:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103d1e:	40                   	inc    %eax
80103d1f:	83 f8 09             	cmp    $0x9,%eax
80103d22:	7e f3                	jle    80103d17 <getcallerpcs+0x34>
}
80103d24:	5b                   	pop    %ebx
80103d25:	5d                   	pop    %ebp
80103d26:	c3                   	ret    

80103d27 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103d27:	f3 0f 1e fb          	endbr32 
80103d2b:	55                   	push   %ebp
80103d2c:	89 e5                	mov    %esp,%ebp
80103d2e:	53                   	push   %ebx
80103d2f:	83 ec 04             	sub    $0x4,%esp
80103d32:	9c                   	pushf  
80103d33:	5b                   	pop    %ebx
  asm volatile("cli");
80103d34:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103d35:	e8 9f f4 ff ff       	call   801031d9 <mycpu>
80103d3a:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103d41:	74 11                	je     80103d54 <pushcli+0x2d>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103d43:	e8 91 f4 ff ff       	call   801031d9 <mycpu>
80103d48:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103d4e:	83 c4 04             	add    $0x4,%esp
80103d51:	5b                   	pop    %ebx
80103d52:	5d                   	pop    %ebp
80103d53:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103d54:	e8 80 f4 ff ff       	call   801031d9 <mycpu>
80103d59:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103d5f:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103d65:	eb dc                	jmp    80103d43 <pushcli+0x1c>

80103d67 <popcli>:

void
popcli(void)
{
80103d67:	f3 0f 1e fb          	endbr32 
80103d6b:	55                   	push   %ebp
80103d6c:	89 e5                	mov    %esp,%ebp
80103d6e:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d71:	9c                   	pushf  
80103d72:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d73:	f6 c4 02             	test   $0x2,%ah
80103d76:	75 28                	jne    80103da0 <popcli+0x39>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103d78:	e8 5c f4 ff ff       	call   801031d9 <mycpu>
80103d7d:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103d83:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103d86:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103d8c:	85 d2                	test   %edx,%edx
80103d8e:	78 1d                	js     80103dad <popcli+0x46>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d90:	e8 44 f4 ff ff       	call   801031d9 <mycpu>
80103d95:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103d9c:	74 1c                	je     80103dba <popcli+0x53>
    sti();
}
80103d9e:	c9                   	leave  
80103d9f:	c3                   	ret    
    panic("popcli - interruptible");
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	68 0f 71 10 80       	push   $0x8010710f
80103da8:	e8 a8 c5 ff ff       	call   80100355 <panic>
    panic("popcli");
80103dad:	83 ec 0c             	sub    $0xc,%esp
80103db0:	68 26 71 10 80       	push   $0x80107126
80103db5:	e8 9b c5 ff ff       	call   80100355 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103dba:	e8 1a f4 ff ff       	call   801031d9 <mycpu>
80103dbf:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103dc6:	74 d6                	je     80103d9e <popcli+0x37>
  asm volatile("sti");
80103dc8:	fb                   	sti    
}
80103dc9:	eb d3                	jmp    80103d9e <popcli+0x37>

80103dcb <holding>:
{
80103dcb:	f3 0f 1e fb          	endbr32 
80103dcf:	55                   	push   %ebp
80103dd0:	89 e5                	mov    %esp,%ebp
80103dd2:	53                   	push   %ebx
80103dd3:	83 ec 04             	sub    $0x4,%esp
80103dd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103dd9:	e8 49 ff ff ff       	call   80103d27 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103dde:	83 3b 00             	cmpl   $0x0,(%ebx)
80103de1:	75 12                	jne    80103df5 <holding+0x2a>
80103de3:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103de8:	e8 7a ff ff ff       	call   80103d67 <popcli>
}
80103ded:	89 d8                	mov    %ebx,%eax
80103def:	83 c4 04             	add    $0x4,%esp
80103df2:	5b                   	pop    %ebx
80103df3:	5d                   	pop    %ebp
80103df4:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103df5:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103df8:	e8 dc f3 ff ff       	call   801031d9 <mycpu>
80103dfd:	39 c3                	cmp    %eax,%ebx
80103dff:	74 07                	je     80103e08 <holding+0x3d>
80103e01:	bb 00 00 00 00       	mov    $0x0,%ebx
80103e06:	eb e0                	jmp    80103de8 <holding+0x1d>
80103e08:	bb 01 00 00 00       	mov    $0x1,%ebx
80103e0d:	eb d9                	jmp    80103de8 <holding+0x1d>

80103e0f <acquire>:
{
80103e0f:	f3 0f 1e fb          	endbr32 
80103e13:	55                   	push   %ebp
80103e14:	89 e5                	mov    %esp,%ebp
80103e16:	53                   	push   %ebx
80103e17:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103e1a:	e8 08 ff ff ff       	call   80103d27 <pushcli>
  if(holding(lk))
80103e1f:	83 ec 0c             	sub    $0xc,%esp
80103e22:	ff 75 08             	pushl  0x8(%ebp)
80103e25:	e8 a1 ff ff ff       	call   80103dcb <holding>
80103e2a:	83 c4 10             	add    $0x10,%esp
80103e2d:	85 c0                	test   %eax,%eax
80103e2f:	75 3a                	jne    80103e6b <acquire+0x5c>
  while(xchg(&lk->locked, 1) != 0)
80103e31:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103e34:	b8 01 00 00 00       	mov    $0x1,%eax
80103e39:	f0 87 02             	lock xchg %eax,(%edx)
80103e3c:	85 c0                	test   %eax,%eax
80103e3e:	75 f1                	jne    80103e31 <acquire+0x22>
  __sync_synchronize();
80103e40:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103e45:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103e48:	e8 8c f3 ff ff       	call   801031d9 <mycpu>
80103e4d:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103e50:	8b 45 08             	mov    0x8(%ebp),%eax
80103e53:	83 c0 0c             	add    $0xc,%eax
80103e56:	83 ec 08             	sub    $0x8,%esp
80103e59:	50                   	push   %eax
80103e5a:	8d 45 08             	lea    0x8(%ebp),%eax
80103e5d:	50                   	push   %eax
80103e5e:	e8 80 fe ff ff       	call   80103ce3 <getcallerpcs>
}
80103e63:	83 c4 10             	add    $0x10,%esp
80103e66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e69:	c9                   	leave  
80103e6a:	c3                   	ret    
    panic("acquire");
80103e6b:	83 ec 0c             	sub    $0xc,%esp
80103e6e:	68 2d 71 10 80       	push   $0x8010712d
80103e73:	e8 dd c4 ff ff       	call   80100355 <panic>

80103e78 <release>:
{
80103e78:	f3 0f 1e fb          	endbr32 
80103e7c:	55                   	push   %ebp
80103e7d:	89 e5                	mov    %esp,%ebp
80103e7f:	53                   	push   %ebx
80103e80:	83 ec 10             	sub    $0x10,%esp
80103e83:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103e86:	53                   	push   %ebx
80103e87:	e8 3f ff ff ff       	call   80103dcb <holding>
80103e8c:	83 c4 10             	add    $0x10,%esp
80103e8f:	85 c0                	test   %eax,%eax
80103e91:	74 23                	je     80103eb6 <release+0x3e>
  lk->pcs[0] = 0;
80103e93:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103e9a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103ea1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103ea6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103eac:	e8 b6 fe ff ff       	call   80103d67 <popcli>
}
80103eb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eb4:	c9                   	leave  
80103eb5:	c3                   	ret    
    panic("release");
80103eb6:	83 ec 0c             	sub    $0xc,%esp
80103eb9:	68 35 71 10 80       	push   $0x80107135
80103ebe:	e8 92 c4 ff ff       	call   80100355 <panic>

80103ec3 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103ec3:	f3 0f 1e fb          	endbr32 
80103ec7:	55                   	push   %ebp
80103ec8:	89 e5                	mov    %esp,%ebp
80103eca:	57                   	push   %edi
80103ecb:	53                   	push   %ebx
80103ecc:	8b 55 08             	mov    0x8(%ebp),%edx
80103ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80103ed2:	f6 c2 03             	test   $0x3,%dl
80103ed5:	75 29                	jne    80103f00 <memset+0x3d>
80103ed7:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103edb:	75 23                	jne    80103f00 <memset+0x3d>
    c &= 0xFF;
80103edd:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103ee0:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103ee3:	c1 e9 02             	shr    $0x2,%ecx
80103ee6:	c1 e0 18             	shl    $0x18,%eax
80103ee9:	89 fb                	mov    %edi,%ebx
80103eeb:	c1 e3 10             	shl    $0x10,%ebx
80103eee:	09 d8                	or     %ebx,%eax
80103ef0:	89 fb                	mov    %edi,%ebx
80103ef2:	c1 e3 08             	shl    $0x8,%ebx
80103ef5:	09 d8                	or     %ebx,%eax
80103ef7:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103ef9:	89 d7                	mov    %edx,%edi
80103efb:	fc                   	cld    
80103efc:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103efe:	eb 08                	jmp    80103f08 <memset+0x45>
  asm volatile("cld; rep stosb" :
80103f00:	89 d7                	mov    %edx,%edi
80103f02:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103f05:	fc                   	cld    
80103f06:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103f08:	89 d0                	mov    %edx,%eax
80103f0a:	5b                   	pop    %ebx
80103f0b:	5f                   	pop    %edi
80103f0c:	5d                   	pop    %ebp
80103f0d:	c3                   	ret    

80103f0e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103f0e:	f3 0f 1e fb          	endbr32 
80103f12:	55                   	push   %ebp
80103f13:	89 e5                	mov    %esp,%ebp
80103f15:	56                   	push   %esi
80103f16:	53                   	push   %ebx
80103f17:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103f1a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103f20:	8d 70 ff             	lea    -0x1(%eax),%esi
80103f23:	85 c0                	test   %eax,%eax
80103f25:	74 16                	je     80103f3d <memcmp+0x2f>
    if(*s1 != *s2)
80103f27:	8a 01                	mov    (%ecx),%al
80103f29:	8a 1a                	mov    (%edx),%bl
80103f2b:	38 d8                	cmp    %bl,%al
80103f2d:	75 06                	jne    80103f35 <memcmp+0x27>
      return *s1 - *s2;
    s1++, s2++;
80103f2f:	41                   	inc    %ecx
80103f30:	42                   	inc    %edx
  while(n-- > 0){
80103f31:	89 f0                	mov    %esi,%eax
80103f33:	eb eb                	jmp    80103f20 <memcmp+0x12>
      return *s1 - *s2;
80103f35:	0f b6 c0             	movzbl %al,%eax
80103f38:	0f b6 db             	movzbl %bl,%ebx
80103f3b:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103f3d:	5b                   	pop    %ebx
80103f3e:	5e                   	pop    %esi
80103f3f:	5d                   	pop    %ebp
80103f40:	c3                   	ret    

80103f41 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103f41:	f3 0f 1e fb          	endbr32 
80103f45:	55                   	push   %ebp
80103f46:	89 e5                	mov    %esp,%ebp
80103f48:	56                   	push   %esi
80103f49:	53                   	push   %ebx
80103f4a:	8b 75 08             	mov    0x8(%ebp),%esi
80103f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f50:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103f53:	39 f2                	cmp    %esi,%edx
80103f55:	73 34                	jae    80103f8b <memmove+0x4a>
80103f57:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103f5a:	39 f1                	cmp    %esi,%ecx
80103f5c:	76 31                	jbe    80103f8f <memmove+0x4e>
    s += n;
    d += n;
80103f5e:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103f61:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103f64:	85 c0                	test   %eax,%eax
80103f66:	74 1d                	je     80103f85 <memmove+0x44>
      *--d = *--s;
80103f68:	49                   	dec    %ecx
80103f69:	4a                   	dec    %edx
80103f6a:	8a 01                	mov    (%ecx),%al
80103f6c:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103f6e:	89 d8                	mov    %ebx,%eax
80103f70:	eb ef                	jmp    80103f61 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103f72:	8a 02                	mov    (%edx),%al
80103f74:	88 01                	mov    %al,(%ecx)
80103f76:	8d 49 01             	lea    0x1(%ecx),%ecx
80103f79:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103f7c:	89 d8                	mov    %ebx,%eax
80103f7e:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103f81:	85 c0                	test   %eax,%eax
80103f83:	75 ed                	jne    80103f72 <memmove+0x31>

  return dst;
}
80103f85:	89 f0                	mov    %esi,%eax
80103f87:	5b                   	pop    %ebx
80103f88:	5e                   	pop    %esi
80103f89:	5d                   	pop    %ebp
80103f8a:	c3                   	ret    
80103f8b:	89 f1                	mov    %esi,%ecx
80103f8d:	eb ef                	jmp    80103f7e <memmove+0x3d>
80103f8f:	89 f1                	mov    %esi,%ecx
80103f91:	eb eb                	jmp    80103f7e <memmove+0x3d>

80103f93 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103f93:	f3 0f 1e fb          	endbr32 
80103f97:	55                   	push   %ebp
80103f98:	89 e5                	mov    %esp,%ebp
80103f9a:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103f9d:	ff 75 10             	pushl  0x10(%ebp)
80103fa0:	ff 75 0c             	pushl  0xc(%ebp)
80103fa3:	ff 75 08             	pushl  0x8(%ebp)
80103fa6:	e8 96 ff ff ff       	call   80103f41 <memmove>
}
80103fab:	c9                   	leave  
80103fac:	c3                   	ret    

80103fad <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103fad:	f3 0f 1e fb          	endbr32 
80103fb1:	55                   	push   %ebp
80103fb2:	89 e5                	mov    %esp,%ebp
80103fb4:	53                   	push   %ebx
80103fb5:	8b 55 08             	mov    0x8(%ebp),%edx
80103fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103fbe:	eb 03                	jmp    80103fc3 <strncmp+0x16>
    n--, p++, q++;
80103fc0:	48                   	dec    %eax
80103fc1:	42                   	inc    %edx
80103fc2:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
80103fc3:	85 c0                	test   %eax,%eax
80103fc5:	74 0a                	je     80103fd1 <strncmp+0x24>
80103fc7:	8a 1a                	mov    (%edx),%bl
80103fc9:	84 db                	test   %bl,%bl
80103fcb:	74 04                	je     80103fd1 <strncmp+0x24>
80103fcd:	3a 19                	cmp    (%ecx),%bl
80103fcf:	74 ef                	je     80103fc0 <strncmp+0x13>
  if(n == 0)
80103fd1:	85 c0                	test   %eax,%eax
80103fd3:	74 0b                	je     80103fe0 <strncmp+0x33>
    return 0;
  return (uchar)*p - (uchar)*q;
80103fd5:	0f b6 02             	movzbl (%edx),%eax
80103fd8:	0f b6 11             	movzbl (%ecx),%edx
80103fdb:	29 d0                	sub    %edx,%eax
}
80103fdd:	5b                   	pop    %ebx
80103fde:	5d                   	pop    %ebp
80103fdf:	c3                   	ret    
    return 0;
80103fe0:	b8 00 00 00 00       	mov    $0x0,%eax
80103fe5:	eb f6                	jmp    80103fdd <strncmp+0x30>

80103fe7 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103fe7:	f3 0f 1e fb          	endbr32 
80103feb:	55                   	push   %ebp
80103fec:	89 e5                	mov    %esp,%ebp
80103fee:	57                   	push   %edi
80103fef:	56                   	push   %esi
80103ff0:	53                   	push   %ebx
80103ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103ff7:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103ffa:	89 c1                	mov    %eax,%ecx
80103ffc:	eb 04                	jmp    80104002 <strncpy+0x1b>
80103ffe:	89 fb                	mov    %edi,%ebx
80104000:	89 f1                	mov    %esi,%ecx
80104002:	89 d6                	mov    %edx,%esi
80104004:	4a                   	dec    %edx
80104005:	85 f6                	test   %esi,%esi
80104007:	7e 1a                	jle    80104023 <strncpy+0x3c>
80104009:	8d 7b 01             	lea    0x1(%ebx),%edi
8010400c:	8d 71 01             	lea    0x1(%ecx),%esi
8010400f:	8a 1b                	mov    (%ebx),%bl
80104011:	88 19                	mov    %bl,(%ecx)
80104013:	84 db                	test   %bl,%bl
80104015:	75 e7                	jne    80103ffe <strncpy+0x17>
80104017:	89 f1                	mov    %esi,%ecx
80104019:	eb 08                	jmp    80104023 <strncpy+0x3c>
    ;
  while(n-- > 0)
    *s++ = 0;
8010401b:	c6 01 00             	movb   $0x0,(%ecx)
  while(n-- > 0)
8010401e:	89 da                	mov    %ebx,%edx
    *s++ = 0;
80104020:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
80104023:	8d 5a ff             	lea    -0x1(%edx),%ebx
80104026:	85 d2                	test   %edx,%edx
80104028:	7f f1                	jg     8010401b <strncpy+0x34>
  return os;
}
8010402a:	5b                   	pop    %ebx
8010402b:	5e                   	pop    %esi
8010402c:	5f                   	pop    %edi
8010402d:	5d                   	pop    %ebp
8010402e:	c3                   	ret    

8010402f <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010402f:	f3 0f 1e fb          	endbr32 
80104033:	55                   	push   %ebp
80104034:	89 e5                	mov    %esp,%ebp
80104036:	57                   	push   %edi
80104037:	56                   	push   %esi
80104038:	53                   	push   %ebx
80104039:	8b 45 08             	mov    0x8(%ebp),%eax
8010403c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010403f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104042:	85 d2                	test   %edx,%edx
80104044:	7e 20                	jle    80104066 <safestrcpy+0x37>
80104046:	89 c1                	mov    %eax,%ecx
80104048:	eb 04                	jmp    8010404e <safestrcpy+0x1f>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
8010404a:	89 fb                	mov    %edi,%ebx
8010404c:	89 f1                	mov    %esi,%ecx
8010404e:	4a                   	dec    %edx
8010404f:	85 d2                	test   %edx,%edx
80104051:	7e 10                	jle    80104063 <safestrcpy+0x34>
80104053:	8d 7b 01             	lea    0x1(%ebx),%edi
80104056:	8d 71 01             	lea    0x1(%ecx),%esi
80104059:	8a 1b                	mov    (%ebx),%bl
8010405b:	88 19                	mov    %bl,(%ecx)
8010405d:	84 db                	test   %bl,%bl
8010405f:	75 e9                	jne    8010404a <safestrcpy+0x1b>
80104061:	89 f1                	mov    %esi,%ecx
    ;
  *s = 0;
80104063:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104066:	5b                   	pop    %ebx
80104067:	5e                   	pop    %esi
80104068:	5f                   	pop    %edi
80104069:	5d                   	pop    %ebp
8010406a:	c3                   	ret    

8010406b <strlen>:

int
strlen(const char *s)
{
8010406b:	f3 0f 1e fb          	endbr32 
8010406f:	55                   	push   %ebp
80104070:	89 e5                	mov    %esp,%ebp
80104072:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104075:	b8 00 00 00 00       	mov    $0x0,%eax
8010407a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010407e:	74 03                	je     80104083 <strlen+0x18>
80104080:	40                   	inc    %eax
80104081:	eb f7                	jmp    8010407a <strlen+0xf>
    ;
  return n;
}
80104083:	5d                   	pop    %ebp
80104084:	c3                   	ret    

80104085 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104085:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104089:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010408d:	55                   	push   %ebp
  pushl %ebx
8010408e:	53                   	push   %ebx
  pushl %esi
8010408f:	56                   	push   %esi
  pushl %edi
80104090:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104091:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104093:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104095:	5f                   	pop    %edi
  popl %esi
80104096:	5e                   	pop    %esi
  popl %ebx
80104097:	5b                   	pop    %ebx
  popl %ebp
80104098:	5d                   	pop    %ebp
  ret
80104099:	c3                   	ret    

8010409a <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010409a:	f3 0f 1e fb          	endbr32 
8010409e:	55                   	push   %ebp
8010409f:	89 e5                	mov    %esp,%ebp
801040a1:	53                   	push   %ebx
801040a2:	83 ec 04             	sub    $0x4,%esp
801040a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801040a8:	e8 c8 f1 ff ff       	call   80103275 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801040ad:	8b 00                	mov    (%eax),%eax
801040af:	39 d8                	cmp    %ebx,%eax
801040b1:	76 19                	jbe    801040cc <fetchint+0x32>
801040b3:	8d 53 04             	lea    0x4(%ebx),%edx
801040b6:	39 d0                	cmp    %edx,%eax
801040b8:	72 19                	jb     801040d3 <fetchint+0x39>
    return -1;
  *ip = *(int*)(addr);
801040ba:	8b 13                	mov    (%ebx),%edx
801040bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801040bf:	89 10                	mov    %edx,(%eax)
  return 0;
801040c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801040c6:	83 c4 04             	add    $0x4,%esp
801040c9:	5b                   	pop    %ebx
801040ca:	5d                   	pop    %ebp
801040cb:	c3                   	ret    
    return -1;
801040cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040d1:	eb f3                	jmp    801040c6 <fetchint+0x2c>
801040d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040d8:	eb ec                	jmp    801040c6 <fetchint+0x2c>

801040da <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801040da:	f3 0f 1e fb          	endbr32 
801040de:	55                   	push   %ebp
801040df:	89 e5                	mov    %esp,%ebp
801040e1:	53                   	push   %ebx
801040e2:	83 ec 04             	sub    $0x4,%esp
801040e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801040e8:	e8 88 f1 ff ff       	call   80103275 <myproc>

  if(addr >= curproc->sz)
801040ed:	39 18                	cmp    %ebx,(%eax)
801040ef:	76 24                	jbe    80104115 <fetchstr+0x3b>
    return -1;
  *pp = (char*)addr;
801040f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801040f4:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801040f6:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801040f8:	89 d8                	mov    %ebx,%eax
801040fa:	39 d0                	cmp    %edx,%eax
801040fc:	73 0c                	jae    8010410a <fetchstr+0x30>
    if(*s == 0)
801040fe:	80 38 00             	cmpb   $0x0,(%eax)
80104101:	74 03                	je     80104106 <fetchstr+0x2c>
  for(s = *pp; s < ep; s++){
80104103:	40                   	inc    %eax
80104104:	eb f4                	jmp    801040fa <fetchstr+0x20>
      return s - *pp;
80104106:	29 d8                	sub    %ebx,%eax
80104108:	eb 05                	jmp    8010410f <fetchstr+0x35>
  }
  return -1;
8010410a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010410f:	83 c4 04             	add    $0x4,%esp
80104112:	5b                   	pop    %ebx
80104113:	5d                   	pop    %ebp
80104114:	c3                   	ret    
    return -1;
80104115:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010411a:	eb f3                	jmp    8010410f <fetchstr+0x35>

8010411c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010411c:	f3 0f 1e fb          	endbr32 
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104126:	e8 4a f1 ff ff       	call   80103275 <myproc>
8010412b:	8b 50 18             	mov    0x18(%eax),%edx
8010412e:	8b 45 08             	mov    0x8(%ebp),%eax
80104131:	c1 e0 02             	shl    $0x2,%eax
80104134:	03 42 44             	add    0x44(%edx),%eax
80104137:	83 ec 08             	sub    $0x8,%esp
8010413a:	ff 75 0c             	pushl  0xc(%ebp)
8010413d:	83 c0 04             	add    $0x4,%eax
80104140:	50                   	push   %eax
80104141:	e8 54 ff ff ff       	call   8010409a <fetchint>
}
80104146:	c9                   	leave  
80104147:	c3                   	ret    

80104148 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, void **pp, int size)
{
80104148:	f3 0f 1e fb          	endbr32 
8010414c:	55                   	push   %ebp
8010414d:	89 e5                	mov    %esp,%ebp
8010414f:	56                   	push   %esi
80104150:	53                   	push   %ebx
80104151:	83 ec 10             	sub    $0x10,%esp
80104154:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104157:	e8 19 f1 ff ff       	call   80103275 <myproc>
8010415c:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
8010415e:	83 ec 08             	sub    $0x8,%esp
80104161:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104164:	50                   	push   %eax
80104165:	ff 75 08             	pushl  0x8(%ebp)
80104168:	e8 af ff ff ff       	call   8010411c <argint>
8010416d:	83 c4 10             	add    $0x10,%esp
80104170:	85 c0                	test   %eax,%eax
80104172:	78 24                	js     80104198 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104174:	85 db                	test   %ebx,%ebx
80104176:	78 27                	js     8010419f <argptr+0x57>
80104178:	8b 16                	mov    (%esi),%edx
8010417a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010417d:	39 c2                	cmp    %eax,%edx
8010417f:	76 25                	jbe    801041a6 <argptr+0x5e>
80104181:	01 c3                	add    %eax,%ebx
80104183:	39 da                	cmp    %ebx,%edx
80104185:	72 26                	jb     801041ad <argptr+0x65>
    return -1;
  *pp = (void*)i;
80104187:	8b 55 0c             	mov    0xc(%ebp),%edx
8010418a:	89 02                	mov    %eax,(%edx)
  return 0;
8010418c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104191:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104194:	5b                   	pop    %ebx
80104195:	5e                   	pop    %esi
80104196:	5d                   	pop    %ebp
80104197:	c3                   	ret    
    return -1;
80104198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010419d:	eb f2                	jmp    80104191 <argptr+0x49>
    return -1;
8010419f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041a4:	eb eb                	jmp    80104191 <argptr+0x49>
801041a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041ab:	eb e4                	jmp    80104191 <argptr+0x49>
801041ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041b2:	eb dd                	jmp    80104191 <argptr+0x49>

801041b4 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801041b4:	f3 0f 1e fb          	endbr32 
801041b8:	55                   	push   %ebp
801041b9:	89 e5                	mov    %esp,%ebp
801041bb:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801041be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801041c1:	50                   	push   %eax
801041c2:	ff 75 08             	pushl  0x8(%ebp)
801041c5:	e8 52 ff ff ff       	call   8010411c <argint>
801041ca:	83 c4 10             	add    $0x10,%esp
801041cd:	85 c0                	test   %eax,%eax
801041cf:	78 13                	js     801041e4 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801041d1:	83 ec 08             	sub    $0x8,%esp
801041d4:	ff 75 0c             	pushl  0xc(%ebp)
801041d7:	ff 75 f4             	pushl  -0xc(%ebp)
801041da:	e8 fb fe ff ff       	call   801040da <fetchstr>
801041df:	83 c4 10             	add    $0x10,%esp
}
801041e2:	c9                   	leave  
801041e3:	c3                   	ret    
    return -1;
801041e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041e9:	eb f7                	jmp    801041e2 <argstr+0x2e>

801041eb <syscall>:
[SYS_setprio] sys_setprio
};

void
syscall(void)
{
801041eb:	f3 0f 1e fb          	endbr32 
801041ef:	55                   	push   %ebp
801041f0:	89 e5                	mov    %esp,%ebp
801041f2:	53                   	push   %ebx
801041f3:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801041f6:	e8 7a f0 ff ff       	call   80103275 <myproc>
801041fb:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801041fd:	8b 40 18             	mov    0x18(%eax),%eax
80104200:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104203:	8d 50 ff             	lea    -0x1(%eax),%edx
80104206:	83 fa 18             	cmp    $0x18,%edx
80104209:	77 17                	ja     80104222 <syscall+0x37>
8010420b:	8b 14 85 60 71 10 80 	mov    -0x7fef8ea0(,%eax,4),%edx
80104212:	85 d2                	test   %edx,%edx
80104214:	74 0c                	je     80104222 <syscall+0x37>
    curproc->tf->eax = syscalls[num]();
80104216:	ff d2                	call   *%edx
80104218:	89 c2                	mov    %eax,%edx
8010421a:	8b 43 18             	mov    0x18(%ebx),%eax
8010421d:	89 50 1c             	mov    %edx,0x1c(%eax)
80104220:	eb 1f                	jmp    80104241 <syscall+0x56>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104222:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104225:	50                   	push   %eax
80104226:	52                   	push   %edx
80104227:	ff 73 10             	pushl  0x10(%ebx)
8010422a:	68 3d 71 10 80       	push   $0x8010713d
8010422f:	e8 c9 c3 ff ff       	call   801005fd <cprintf>
    curproc->tf->eax = -1;
80104234:	8b 43 18             	mov    0x18(%ebx),%eax
80104237:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010423e:	83 c4 10             	add    $0x10,%esp
  }
}
80104241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104244:	c9                   	leave  
80104245:	c3                   	ret    

80104246 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104246:	55                   	push   %ebp
80104247:	89 e5                	mov    %esp,%ebp
80104249:	56                   	push   %esi
8010424a:	53                   	push   %ebx
8010424b:	83 ec 18             	sub    $0x18,%esp
8010424e:	89 d6                	mov    %edx,%esi
80104250:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104252:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104255:	52                   	push   %edx
80104256:	50                   	push   %eax
80104257:	e8 c0 fe ff ff       	call   8010411c <argint>
8010425c:	83 c4 10             	add    $0x10,%esp
8010425f:	85 c0                	test   %eax,%eax
80104261:	78 35                	js     80104298 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104263:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104267:	77 28                	ja     80104291 <argfd+0x4b>
80104269:	e8 07 f0 ff ff       	call   80103275 <myproc>
8010426e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104271:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104275:	85 c0                	test   %eax,%eax
80104277:	74 18                	je     80104291 <argfd+0x4b>
    return -1;
  if(pfd)
80104279:	85 f6                	test   %esi,%esi
8010427b:	74 02                	je     8010427f <argfd+0x39>
    *pfd = fd;
8010427d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010427f:	85 db                	test   %ebx,%ebx
80104281:	74 1c                	je     8010429f <argfd+0x59>
    *pf = f;
80104283:	89 03                	mov    %eax,(%ebx)
  return 0;
80104285:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010428a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010428d:	5b                   	pop    %ebx
8010428e:	5e                   	pop    %esi
8010428f:	5d                   	pop    %ebp
80104290:	c3                   	ret    
    return -1;
80104291:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104296:	eb f2                	jmp    8010428a <argfd+0x44>
    return -1;
80104298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010429d:	eb eb                	jmp    8010428a <argfd+0x44>
  return 0;
8010429f:	b8 00 00 00 00       	mov    $0x0,%eax
801042a4:	eb e4                	jmp    8010428a <argfd+0x44>

801042a6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801042a6:	55                   	push   %ebp
801042a7:	89 e5                	mov    %esp,%ebp
801042a9:	53                   	push   %ebx
801042aa:	83 ec 04             	sub    $0x4,%esp
801042ad:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
801042af:	e8 c1 ef ff ff       	call   80103275 <myproc>
801042b4:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
801042b6:	b8 00 00 00 00       	mov    $0x0,%eax
801042bb:	83 f8 0f             	cmp    $0xf,%eax
801042be:	7f 10                	jg     801042d0 <fdalloc+0x2a>
    if(curproc->ofile[fd] == 0){
801042c0:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
801042c5:	74 03                	je     801042ca <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
801042c7:	40                   	inc    %eax
801042c8:	eb f1                	jmp    801042bb <fdalloc+0x15>
      curproc->ofile[fd] = f;
801042ca:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
801042ce:	eb 05                	jmp    801042d5 <fdalloc+0x2f>
    }
  }
  return -1;
801042d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042d5:	83 c4 04             	add    $0x4,%esp
801042d8:	5b                   	pop    %ebx
801042d9:	5d                   	pop    %ebp
801042da:	c3                   	ret    

801042db <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801042db:	55                   	push   %ebp
801042dc:	89 e5                	mov    %esp,%ebp
801042de:	56                   	push   %esi
801042df:	53                   	push   %ebx
801042e0:	83 ec 10             	sub    $0x10,%esp
801042e3:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801042e5:	b8 20 00 00 00       	mov    $0x20,%eax
801042ea:	89 c6                	mov    %eax,%esi
801042ec:	39 43 58             	cmp    %eax,0x58(%ebx)
801042ef:	76 2e                	jbe    8010431f <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801042f1:	6a 10                	push   $0x10
801042f3:	50                   	push   %eax
801042f4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801042f7:	50                   	push   %eax
801042f8:	53                   	push   %ebx
801042f9:	e8 99 d4 ff ff       	call   80101797 <readi>
801042fe:	83 c4 10             	add    $0x10,%esp
80104301:	83 f8 10             	cmp    $0x10,%eax
80104304:	75 0c                	jne    80104312 <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104306:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
8010430b:	75 1e                	jne    8010432b <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010430d:	8d 46 10             	lea    0x10(%esi),%eax
80104310:	eb d8                	jmp    801042ea <isdirempty+0xf>
      panic("isdirempty: readi");
80104312:	83 ec 0c             	sub    $0xc,%esp
80104315:	68 c8 71 10 80       	push   $0x801071c8
8010431a:	e8 36 c0 ff ff       	call   80100355 <panic>
      return 0;
  }
  return 1;
8010431f:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104324:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104327:	5b                   	pop    %ebx
80104328:	5e                   	pop    %esi
80104329:	5d                   	pop    %ebp
8010432a:	c3                   	ret    
      return 0;
8010432b:	b8 00 00 00 00       	mov    $0x0,%eax
80104330:	eb f2                	jmp    80104324 <isdirempty+0x49>

80104332 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104332:	55                   	push   %ebp
80104333:	89 e5                	mov    %esp,%ebp
80104335:	57                   	push   %edi
80104336:	56                   	push   %esi
80104337:	53                   	push   %ebx
80104338:	83 ec 44             	sub    $0x44,%esp
8010433b:	89 d7                	mov    %edx,%edi
8010433d:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
80104340:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104343:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104346:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104349:	52                   	push   %edx
8010434a:	50                   	push   %eax
8010434b:	e8 ee d8 ff ff       	call   80101c3e <nameiparent>
80104350:	89 c6                	mov    %eax,%esi
80104352:	83 c4 10             	add    $0x10,%esp
80104355:	85 c0                	test   %eax,%eax
80104357:	0f 84 32 01 00 00    	je     8010448f <create+0x15d>
    return 0;
  ilock(dp);
8010435d:	83 ec 0c             	sub    $0xc,%esp
80104360:	50                   	push   %eax
80104361:	e8 30 d2 ff ff       	call   80101596 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104366:	83 c4 0c             	add    $0xc,%esp
80104369:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010436c:	50                   	push   %eax
8010436d:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104370:	50                   	push   %eax
80104371:	56                   	push   %esi
80104372:	e8 75 d6 ff ff       	call   801019ec <dirlookup>
80104377:	89 c3                	mov    %eax,%ebx
80104379:	83 c4 10             	add    $0x10,%esp
8010437c:	85 c0                	test   %eax,%eax
8010437e:	74 3c                	je     801043bc <create+0x8a>
    iunlockput(dp);
80104380:	83 ec 0c             	sub    $0xc,%esp
80104383:	56                   	push   %esi
80104384:	e8 bc d3 ff ff       	call   80101745 <iunlockput>
    ilock(ip);
80104389:	89 1c 24             	mov    %ebx,(%esp)
8010438c:	e8 05 d2 ff ff       	call   80101596 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104391:	83 c4 10             	add    $0x10,%esp
80104394:	66 83 ff 02          	cmp    $0x2,%di
80104398:	75 07                	jne    801043a1 <create+0x6f>
8010439a:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010439f:	74 11                	je     801043b2 <create+0x80>
      return ip;
    iunlockput(ip);
801043a1:	83 ec 0c             	sub    $0xc,%esp
801043a4:	53                   	push   %ebx
801043a5:	e8 9b d3 ff ff       	call   80101745 <iunlockput>
    return 0;
801043aa:	83 c4 10             	add    $0x10,%esp
801043ad:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801043b2:	89 d8                	mov    %ebx,%eax
801043b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b7:	5b                   	pop    %ebx
801043b8:	5e                   	pop    %esi
801043b9:	5f                   	pop    %edi
801043ba:	5d                   	pop    %ebp
801043bb:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801043bc:	83 ec 08             	sub    $0x8,%esp
801043bf:	0f bf c7             	movswl %di,%eax
801043c2:	50                   	push   %eax
801043c3:	ff 36                	pushl  (%esi)
801043c5:	e8 c8 cf ff ff       	call   80101392 <ialloc>
801043ca:	89 c3                	mov    %eax,%ebx
801043cc:	83 c4 10             	add    $0x10,%esp
801043cf:	85 c0                	test   %eax,%eax
801043d1:	74 53                	je     80104426 <create+0xf4>
  ilock(ip);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	50                   	push   %eax
801043d7:	e8 ba d1 ff ff       	call   80101596 <ilock>
  ip->major = major;
801043dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801043df:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801043e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801043e6:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801043ea:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
801043f0:	89 1c 24             	mov    %ebx,(%esp)
801043f3:	e8 3d d0 ff ff       	call   80101435 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801043f8:	83 c4 10             	add    $0x10,%esp
801043fb:	66 83 ff 01          	cmp    $0x1,%di
801043ff:	74 32                	je     80104433 <create+0x101>
  if(dirlink(dp, name, ip->inum) < 0)
80104401:	83 ec 04             	sub    $0x4,%esp
80104404:	ff 73 04             	pushl  0x4(%ebx)
80104407:	8d 45 d6             	lea    -0x2a(%ebp),%eax
8010440a:	50                   	push   %eax
8010440b:	56                   	push   %esi
8010440c:	e8 5c d7 ff ff       	call   80101b6d <dirlink>
80104411:	83 c4 10             	add    $0x10,%esp
80104414:	85 c0                	test   %eax,%eax
80104416:	78 6a                	js     80104482 <create+0x150>
  iunlockput(dp);
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	56                   	push   %esi
8010441c:	e8 24 d3 ff ff       	call   80101745 <iunlockput>
  return ip;
80104421:	83 c4 10             	add    $0x10,%esp
80104424:	eb 8c                	jmp    801043b2 <create+0x80>
    panic("create: ialloc");
80104426:	83 ec 0c             	sub    $0xc,%esp
80104429:	68 da 71 10 80       	push   $0x801071da
8010442e:	e8 22 bf ff ff       	call   80100355 <panic>
    dp->nlink++;  // for ".."
80104433:	66 8b 46 56          	mov    0x56(%esi),%ax
80104437:	40                   	inc    %eax
80104438:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
8010443c:	83 ec 0c             	sub    $0xc,%esp
8010443f:	56                   	push   %esi
80104440:	e8 f0 cf ff ff       	call   80101435 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104445:	83 c4 0c             	add    $0xc,%esp
80104448:	ff 73 04             	pushl  0x4(%ebx)
8010444b:	68 ea 71 10 80       	push   $0x801071ea
80104450:	53                   	push   %ebx
80104451:	e8 17 d7 ff ff       	call   80101b6d <dirlink>
80104456:	83 c4 10             	add    $0x10,%esp
80104459:	85 c0                	test   %eax,%eax
8010445b:	78 18                	js     80104475 <create+0x143>
8010445d:	83 ec 04             	sub    $0x4,%esp
80104460:	ff 76 04             	pushl  0x4(%esi)
80104463:	68 e9 71 10 80       	push   $0x801071e9
80104468:	53                   	push   %ebx
80104469:	e8 ff d6 ff ff       	call   80101b6d <dirlink>
8010446e:	83 c4 10             	add    $0x10,%esp
80104471:	85 c0                	test   %eax,%eax
80104473:	79 8c                	jns    80104401 <create+0xcf>
      panic("create dots");
80104475:	83 ec 0c             	sub    $0xc,%esp
80104478:	68 ec 71 10 80       	push   $0x801071ec
8010447d:	e8 d3 be ff ff       	call   80100355 <panic>
    panic("create: dirlink");
80104482:	83 ec 0c             	sub    $0xc,%esp
80104485:	68 f8 71 10 80       	push   $0x801071f8
8010448a:	e8 c6 be ff ff       	call   80100355 <panic>
    return 0;
8010448f:	89 c3                	mov    %eax,%ebx
80104491:	e9 1c ff ff ff       	jmp    801043b2 <create+0x80>

80104496 <sys_dup>:
{
80104496:	f3 0f 1e fb          	endbr32 
8010449a:	55                   	push   %ebp
8010449b:	89 e5                	mov    %esp,%ebp
8010449d:	53                   	push   %ebx
8010449e:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
801044a1:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044a4:	ba 00 00 00 00       	mov    $0x0,%edx
801044a9:	b8 00 00 00 00       	mov    $0x0,%eax
801044ae:	e8 93 fd ff ff       	call   80104246 <argfd>
801044b3:	85 c0                	test   %eax,%eax
801044b5:	78 23                	js     801044da <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
801044b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ba:	e8 e7 fd ff ff       	call   801042a6 <fdalloc>
801044bf:	89 c3                	mov    %eax,%ebx
801044c1:	85 c0                	test   %eax,%eax
801044c3:	78 1c                	js     801044e1 <sys_dup+0x4b>
  filedup(f);
801044c5:	83 ec 0c             	sub    $0xc,%esp
801044c8:	ff 75 f4             	pushl  -0xc(%ebp)
801044cb:	e8 c6 c7 ff ff       	call   80100c96 <filedup>
  return fd;
801044d0:	83 c4 10             	add    $0x10,%esp
}
801044d3:	89 d8                	mov    %ebx,%eax
801044d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d8:	c9                   	leave  
801044d9:	c3                   	ret    
    return -1;
801044da:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801044df:	eb f2                	jmp    801044d3 <sys_dup+0x3d>
    return -1;
801044e1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801044e6:	eb eb                	jmp    801044d3 <sys_dup+0x3d>

801044e8 <sys_dup2>:
sys_dup2(void){
801044e8:	f3 0f 1e fb          	endbr32 
801044ec:	55                   	push   %ebp
801044ed:	89 e5                	mov    %esp,%ebp
801044ef:	53                   	push   %ebx
801044f0:	83 ec 14             	sub    $0x14,%esp
  struct proc *curproc = myproc(); 
801044f3:	e8 7d ed ff ff       	call   80103275 <myproc>
801044f8:	89 c3                	mov    %eax,%ebx
  if(argfd(0, &oldfd, &oldf) < 0) // Obtenemos el descriptor de fichero y el fichero (file *) a partir del argumento 0.
801044fa:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044fd:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104500:	b8 00 00 00 00       	mov    $0x0,%eax
80104505:	e8 3c fd ff ff       	call   80104246 <argfd>
8010450a:	85 c0                	test   %eax,%eax
8010450c:	78 5f                	js     8010456d <sys_dup2+0x85>
  if(argint(1, &newfd)<0) // Obtenemos el nuevo descriptor de fichero a partir del argumento 1.
8010450e:	83 ec 08             	sub    $0x8,%esp
80104511:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104514:	50                   	push   %eax
80104515:	6a 01                	push   $0x1
80104517:	e8 00 fc ff ff       	call   8010411c <argint>
8010451c:	83 c4 10             	add    $0x10,%esp
8010451f:	85 c0                	test   %eax,%eax
80104521:	78 51                	js     80104574 <sys_dup2+0x8c>
  if(oldfd == newfd) // Si los descriptores de fichero son iguales, no es necesario duplicar.
80104523:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104526:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104529:	39 c2                	cmp    %eax,%edx
8010452b:	74 3b                	je     80104568 <sys_dup2+0x80>
  if(oldfd < 0 || oldfd >= NOFILE || newfd < 0 || newfd >= NOFILE) // Comprobamos que los descriptores de fichero están dentro de los límites válidos.
8010452d:	83 fa 0f             	cmp    $0xf,%edx
80104530:	77 49                	ja     8010457b <sys_dup2+0x93>
80104532:	85 c0                	test   %eax,%eax
80104534:	78 4c                	js     80104582 <sys_dup2+0x9a>
80104536:	83 f8 0f             	cmp    $0xf,%eax
80104539:	7f 4e                	jg     80104589 <sys_dup2+0xa1>
  newf=curproc->ofile[newfd]; // Obtenemos el fichero (file *) correspondiente al nuevo descriptor.
8010453b:	8b 44 83 28          	mov    0x28(%ebx,%eax,4),%eax
  if(newf!=NULL) //Si el nuevo descriptor de fichero está en uso, cierra el fichero.
8010453f:	85 c0                	test   %eax,%eax
80104541:	74 0c                	je     8010454f <sys_dup2+0x67>
    fileclose(newf);
80104543:	83 ec 0c             	sub    $0xc,%esp
80104546:	50                   	push   %eax
80104547:	e8 91 c7 ff ff       	call   80100cdd <fileclose>
8010454c:	83 c4 10             	add    $0x10,%esp
  curproc->ofile[newfd] = oldf; // Asignamos el fichero del descriptor antiguo al nuevo descriptor.
8010454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104552:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104555:	89 44 93 28          	mov    %eax,0x28(%ebx,%edx,4)
  filedup(oldf); // Incrementa el contador de referencias del fichero.
80104559:	83 ec 0c             	sub    $0xc,%esp
8010455c:	50                   	push   %eax
8010455d:	e8 34 c7 ff ff       	call   80100c96 <filedup>
  return newfd;
80104562:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104565:	83 c4 10             	add    $0x10,%esp
}
80104568:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010456b:	c9                   	leave  
8010456c:	c3                   	ret    
    return -1;
8010456d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104572:	eb f4                	jmp    80104568 <sys_dup2+0x80>
    return -1;
80104574:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104579:	eb ed                	jmp    80104568 <sys_dup2+0x80>
    return -1;
8010457b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104580:	eb e6                	jmp    80104568 <sys_dup2+0x80>
80104582:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104587:	eb df                	jmp    80104568 <sys_dup2+0x80>
80104589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010458e:	eb d8                	jmp    80104568 <sys_dup2+0x80>

80104590 <sys_read>:
{
80104590:	f3 0f 1e fb          	endbr32 
80104594:	55                   	push   %ebp
80104595:	89 e5                	mov    %esp,%ebp
80104597:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
8010459a:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010459d:	ba 00 00 00 00       	mov    $0x0,%edx
801045a2:	b8 00 00 00 00       	mov    $0x0,%eax
801045a7:	e8 9a fc ff ff       	call   80104246 <argfd>
801045ac:	85 c0                	test   %eax,%eax
801045ae:	78 43                	js     801045f3 <sys_read+0x63>
801045b0:	83 ec 08             	sub    $0x8,%esp
801045b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801045b6:	50                   	push   %eax
801045b7:	6a 02                	push   $0x2
801045b9:	e8 5e fb ff ff       	call   8010411c <argint>
801045be:	83 c4 10             	add    $0x10,%esp
801045c1:	85 c0                	test   %eax,%eax
801045c3:	78 2e                	js     801045f3 <sys_read+0x63>
801045c5:	83 ec 04             	sub    $0x4,%esp
801045c8:	ff 75 f0             	pushl  -0x10(%ebp)
801045cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801045ce:	50                   	push   %eax
801045cf:	6a 01                	push   $0x1
801045d1:	e8 72 fb ff ff       	call   80104148 <argptr>
801045d6:	83 c4 10             	add    $0x10,%esp
801045d9:	85 c0                	test   %eax,%eax
801045db:	78 16                	js     801045f3 <sys_read+0x63>
  return fileread(f, p, n);
801045dd:	83 ec 04             	sub    $0x4,%esp
801045e0:	ff 75 f0             	pushl  -0x10(%ebp)
801045e3:	ff 75 ec             	pushl  -0x14(%ebp)
801045e6:	ff 75 f4             	pushl  -0xc(%ebp)
801045e9:	e8 f0 c7 ff ff       	call   80100dde <fileread>
801045ee:	83 c4 10             	add    $0x10,%esp
}
801045f1:	c9                   	leave  
801045f2:	c3                   	ret    
    return -1;
801045f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045f8:	eb f7                	jmp    801045f1 <sys_read+0x61>

801045fa <sys_write>:
{
801045fa:	f3 0f 1e fb          	endbr32 
801045fe:	55                   	push   %ebp
801045ff:	89 e5                	mov    %esp,%ebp
80104601:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
80104604:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104607:	ba 00 00 00 00       	mov    $0x0,%edx
8010460c:	b8 00 00 00 00       	mov    $0x0,%eax
80104611:	e8 30 fc ff ff       	call   80104246 <argfd>
80104616:	85 c0                	test   %eax,%eax
80104618:	78 43                	js     8010465d <sys_write+0x63>
8010461a:	83 ec 08             	sub    $0x8,%esp
8010461d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104620:	50                   	push   %eax
80104621:	6a 02                	push   $0x2
80104623:	e8 f4 fa ff ff       	call   8010411c <argint>
80104628:	83 c4 10             	add    $0x10,%esp
8010462b:	85 c0                	test   %eax,%eax
8010462d:	78 2e                	js     8010465d <sys_write+0x63>
8010462f:	83 ec 04             	sub    $0x4,%esp
80104632:	ff 75 f0             	pushl  -0x10(%ebp)
80104635:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104638:	50                   	push   %eax
80104639:	6a 01                	push   $0x1
8010463b:	e8 08 fb ff ff       	call   80104148 <argptr>
80104640:	83 c4 10             	add    $0x10,%esp
80104643:	85 c0                	test   %eax,%eax
80104645:	78 16                	js     8010465d <sys_write+0x63>
  return filewrite(f, p, n);
80104647:	83 ec 04             	sub    $0x4,%esp
8010464a:	ff 75 f0             	pushl  -0x10(%ebp)
8010464d:	ff 75 ec             	pushl  -0x14(%ebp)
80104650:	ff 75 f4             	pushl  -0xc(%ebp)
80104653:	e8 0f c8 ff ff       	call   80100e67 <filewrite>
80104658:	83 c4 10             	add    $0x10,%esp
}
8010465b:	c9                   	leave  
8010465c:	c3                   	ret    
    return -1;
8010465d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104662:	eb f7                	jmp    8010465b <sys_write+0x61>

80104664 <sys_close>:
{
80104664:	f3 0f 1e fb          	endbr32 
80104668:	55                   	push   %ebp
80104669:	89 e5                	mov    %esp,%ebp
8010466b:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010466e:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104671:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104674:	b8 00 00 00 00       	mov    $0x0,%eax
80104679:	e8 c8 fb ff ff       	call   80104246 <argfd>
8010467e:	85 c0                	test   %eax,%eax
80104680:	78 25                	js     801046a7 <sys_close+0x43>
  myproc()->ofile[fd] = 0;
80104682:	e8 ee eb ff ff       	call   80103275 <myproc>
80104687:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010468a:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104691:	00 
  fileclose(f);
80104692:	83 ec 0c             	sub    $0xc,%esp
80104695:	ff 75 f0             	pushl  -0x10(%ebp)
80104698:	e8 40 c6 ff ff       	call   80100cdd <fileclose>
  return 0;
8010469d:	83 c4 10             	add    $0x10,%esp
801046a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046a5:	c9                   	leave  
801046a6:	c3                   	ret    
    return -1;
801046a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ac:	eb f7                	jmp    801046a5 <sys_close+0x41>

801046ae <sys_fstat>:
{
801046ae:	f3 0f 1e fb          	endbr32 
801046b2:	55                   	push   %ebp
801046b3:	89 e5                	mov    %esp,%ebp
801046b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801046b8:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801046bb:	ba 00 00 00 00       	mov    $0x0,%edx
801046c0:	b8 00 00 00 00       	mov    $0x0,%eax
801046c5:	e8 7c fb ff ff       	call   80104246 <argfd>
801046ca:	85 c0                	test   %eax,%eax
801046cc:	78 2a                	js     801046f8 <sys_fstat+0x4a>
801046ce:	83 ec 04             	sub    $0x4,%esp
801046d1:	6a 14                	push   $0x14
801046d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801046d6:	50                   	push   %eax
801046d7:	6a 01                	push   $0x1
801046d9:	e8 6a fa ff ff       	call   80104148 <argptr>
801046de:	83 c4 10             	add    $0x10,%esp
801046e1:	85 c0                	test   %eax,%eax
801046e3:	78 13                	js     801046f8 <sys_fstat+0x4a>
  return filestat(f, st);
801046e5:	83 ec 08             	sub    $0x8,%esp
801046e8:	ff 75 f0             	pushl  -0x10(%ebp)
801046eb:	ff 75 f4             	pushl  -0xc(%ebp)
801046ee:	e8 a0 c6 ff ff       	call   80100d93 <filestat>
801046f3:	83 c4 10             	add    $0x10,%esp
}
801046f6:	c9                   	leave  
801046f7:	c3                   	ret    
    return -1;
801046f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046fd:	eb f7                	jmp    801046f6 <sys_fstat+0x48>

801046ff <sys_link>:
{
801046ff:	f3 0f 1e fb          	endbr32 
80104703:	55                   	push   %ebp
80104704:	89 e5                	mov    %esp,%ebp
80104706:	56                   	push   %esi
80104707:	53                   	push   %ebx
80104708:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010470b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010470e:	50                   	push   %eax
8010470f:	6a 00                	push   $0x0
80104711:	e8 9e fa ff ff       	call   801041b4 <argstr>
80104716:	83 c4 10             	add    $0x10,%esp
80104719:	85 c0                	test   %eax,%eax
8010471b:	0f 88 d1 00 00 00    	js     801047f2 <sys_link+0xf3>
80104721:	83 ec 08             	sub    $0x8,%esp
80104724:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104727:	50                   	push   %eax
80104728:	6a 01                	push   $0x1
8010472a:	e8 85 fa ff ff       	call   801041b4 <argstr>
8010472f:	83 c4 10             	add    $0x10,%esp
80104732:	85 c0                	test   %eax,%eax
80104734:	0f 88 b8 00 00 00    	js     801047f2 <sys_link+0xf3>
  begin_op();
8010473a:	e8 a4 e0 ff ff       	call   801027e3 <begin_op>
  if((ip = namei(old)) == 0){
8010473f:	83 ec 0c             	sub    $0xc,%esp
80104742:	ff 75 e0             	pushl  -0x20(%ebp)
80104745:	e8 d8 d4 ff ff       	call   80101c22 <namei>
8010474a:	89 c3                	mov    %eax,%ebx
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	85 c0                	test   %eax,%eax
80104751:	0f 84 a2 00 00 00    	je     801047f9 <sys_link+0xfa>
  ilock(ip);
80104757:	83 ec 0c             	sub    $0xc,%esp
8010475a:	50                   	push   %eax
8010475b:	e8 36 ce ff ff       	call   80101596 <ilock>
  if(ip->type == T_DIR){
80104760:	83 c4 10             	add    $0x10,%esp
80104763:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104768:	0f 84 97 00 00 00    	je     80104805 <sys_link+0x106>
  ip->nlink++;
8010476e:	66 8b 43 56          	mov    0x56(%ebx),%ax
80104772:	40                   	inc    %eax
80104773:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104777:	83 ec 0c             	sub    $0xc,%esp
8010477a:	53                   	push   %ebx
8010477b:	e8 b5 cc ff ff       	call   80101435 <iupdate>
  iunlock(ip);
80104780:	89 1c 24             	mov    %ebx,(%esp)
80104783:	e8 d2 ce ff ff       	call   8010165a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104788:	83 c4 08             	add    $0x8,%esp
8010478b:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010478e:	50                   	push   %eax
8010478f:	ff 75 e4             	pushl  -0x1c(%ebp)
80104792:	e8 a7 d4 ff ff       	call   80101c3e <nameiparent>
80104797:	89 c6                	mov    %eax,%esi
80104799:	83 c4 10             	add    $0x10,%esp
8010479c:	85 c0                	test   %eax,%eax
8010479e:	0f 84 85 00 00 00    	je     80104829 <sys_link+0x12a>
  ilock(dp);
801047a4:	83 ec 0c             	sub    $0xc,%esp
801047a7:	50                   	push   %eax
801047a8:	e8 e9 cd ff ff       	call   80101596 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801047ad:	83 c4 10             	add    $0x10,%esp
801047b0:	8b 03                	mov    (%ebx),%eax
801047b2:	39 06                	cmp    %eax,(%esi)
801047b4:	75 67                	jne    8010481d <sys_link+0x11e>
801047b6:	83 ec 04             	sub    $0x4,%esp
801047b9:	ff 73 04             	pushl  0x4(%ebx)
801047bc:	8d 45 ea             	lea    -0x16(%ebp),%eax
801047bf:	50                   	push   %eax
801047c0:	56                   	push   %esi
801047c1:	e8 a7 d3 ff ff       	call   80101b6d <dirlink>
801047c6:	83 c4 10             	add    $0x10,%esp
801047c9:	85 c0                	test   %eax,%eax
801047cb:	78 50                	js     8010481d <sys_link+0x11e>
  iunlockput(dp);
801047cd:	83 ec 0c             	sub    $0xc,%esp
801047d0:	56                   	push   %esi
801047d1:	e8 6f cf ff ff       	call   80101745 <iunlockput>
  iput(ip);
801047d6:	89 1c 24             	mov    %ebx,(%esp)
801047d9:	e8 c5 ce ff ff       	call   801016a3 <iput>
  end_op();
801047de:	e8 80 e0 ff ff       	call   80102863 <end_op>
  return 0;
801047e3:	83 c4 10             	add    $0x10,%esp
801047e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047ee:	5b                   	pop    %ebx
801047ef:	5e                   	pop    %esi
801047f0:	5d                   	pop    %ebp
801047f1:	c3                   	ret    
    return -1;
801047f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047f7:	eb f2                	jmp    801047eb <sys_link+0xec>
    end_op();
801047f9:	e8 65 e0 ff ff       	call   80102863 <end_op>
    return -1;
801047fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104803:	eb e6                	jmp    801047eb <sys_link+0xec>
    iunlockput(ip);
80104805:	83 ec 0c             	sub    $0xc,%esp
80104808:	53                   	push   %ebx
80104809:	e8 37 cf ff ff       	call   80101745 <iunlockput>
    end_op();
8010480e:	e8 50 e0 ff ff       	call   80102863 <end_op>
    return -1;
80104813:	83 c4 10             	add    $0x10,%esp
80104816:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010481b:	eb ce                	jmp    801047eb <sys_link+0xec>
    iunlockput(dp);
8010481d:	83 ec 0c             	sub    $0xc,%esp
80104820:	56                   	push   %esi
80104821:	e8 1f cf ff ff       	call   80101745 <iunlockput>
    goto bad;
80104826:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104829:	83 ec 0c             	sub    $0xc,%esp
8010482c:	53                   	push   %ebx
8010482d:	e8 64 cd ff ff       	call   80101596 <ilock>
  ip->nlink--;
80104832:	66 8b 43 56          	mov    0x56(%ebx),%ax
80104836:	48                   	dec    %eax
80104837:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010483b:	89 1c 24             	mov    %ebx,(%esp)
8010483e:	e8 f2 cb ff ff       	call   80101435 <iupdate>
  iunlockput(ip);
80104843:	89 1c 24             	mov    %ebx,(%esp)
80104846:	e8 fa ce ff ff       	call   80101745 <iunlockput>
  end_op();
8010484b:	e8 13 e0 ff ff       	call   80102863 <end_op>
  return -1;
80104850:	83 c4 10             	add    $0x10,%esp
80104853:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104858:	eb 91                	jmp    801047eb <sys_link+0xec>

8010485a <sys_unlink>:
{
8010485a:	f3 0f 1e fb          	endbr32 
8010485e:	55                   	push   %ebp
8010485f:	89 e5                	mov    %esp,%ebp
80104861:	57                   	push   %edi
80104862:	56                   	push   %esi
80104863:	53                   	push   %ebx
80104864:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104867:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010486a:	50                   	push   %eax
8010486b:	6a 00                	push   $0x0
8010486d:	e8 42 f9 ff ff       	call   801041b4 <argstr>
80104872:	83 c4 10             	add    $0x10,%esp
80104875:	85 c0                	test   %eax,%eax
80104877:	0f 88 7f 01 00 00    	js     801049fc <sys_unlink+0x1a2>
  begin_op();
8010487d:	e8 61 df ff ff       	call   801027e3 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104882:	83 ec 08             	sub    $0x8,%esp
80104885:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104888:	50                   	push   %eax
80104889:	ff 75 c4             	pushl  -0x3c(%ebp)
8010488c:	e8 ad d3 ff ff       	call   80101c3e <nameiparent>
80104891:	89 c6                	mov    %eax,%esi
80104893:	83 c4 10             	add    $0x10,%esp
80104896:	85 c0                	test   %eax,%eax
80104898:	0f 84 eb 00 00 00    	je     80104989 <sys_unlink+0x12f>
  ilock(dp);
8010489e:	83 ec 0c             	sub    $0xc,%esp
801048a1:	50                   	push   %eax
801048a2:	e8 ef cc ff ff       	call   80101596 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801048a7:	83 c4 08             	add    $0x8,%esp
801048aa:	68 ea 71 10 80       	push   $0x801071ea
801048af:	8d 45 ca             	lea    -0x36(%ebp),%eax
801048b2:	50                   	push   %eax
801048b3:	e8 1b d1 ff ff       	call   801019d3 <namecmp>
801048b8:	83 c4 10             	add    $0x10,%esp
801048bb:	85 c0                	test   %eax,%eax
801048bd:	0f 84 fa 00 00 00    	je     801049bd <sys_unlink+0x163>
801048c3:	83 ec 08             	sub    $0x8,%esp
801048c6:	68 e9 71 10 80       	push   $0x801071e9
801048cb:	8d 45 ca             	lea    -0x36(%ebp),%eax
801048ce:	50                   	push   %eax
801048cf:	e8 ff d0 ff ff       	call   801019d3 <namecmp>
801048d4:	83 c4 10             	add    $0x10,%esp
801048d7:	85 c0                	test   %eax,%eax
801048d9:	0f 84 de 00 00 00    	je     801049bd <sys_unlink+0x163>
  if((ip = dirlookup(dp, name, &off)) == 0)
801048df:	83 ec 04             	sub    $0x4,%esp
801048e2:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048e5:	50                   	push   %eax
801048e6:	8d 45 ca             	lea    -0x36(%ebp),%eax
801048e9:	50                   	push   %eax
801048ea:	56                   	push   %esi
801048eb:	e8 fc d0 ff ff       	call   801019ec <dirlookup>
801048f0:	89 c3                	mov    %eax,%ebx
801048f2:	83 c4 10             	add    $0x10,%esp
801048f5:	85 c0                	test   %eax,%eax
801048f7:	0f 84 c0 00 00 00    	je     801049bd <sys_unlink+0x163>
  ilock(ip);
801048fd:	83 ec 0c             	sub    $0xc,%esp
80104900:	50                   	push   %eax
80104901:	e8 90 cc ff ff       	call   80101596 <ilock>
  if(ip->nlink < 1)
80104906:	83 c4 10             	add    $0x10,%esp
80104909:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010490e:	0f 8e 81 00 00 00    	jle    80104995 <sys_unlink+0x13b>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104914:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104919:	0f 84 83 00 00 00    	je     801049a2 <sys_unlink+0x148>
  memset(&de, 0, sizeof(de));
8010491f:	83 ec 04             	sub    $0x4,%esp
80104922:	6a 10                	push   $0x10
80104924:	6a 00                	push   $0x0
80104926:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104929:	57                   	push   %edi
8010492a:	e8 94 f5 ff ff       	call   80103ec3 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010492f:	6a 10                	push   $0x10
80104931:	ff 75 c0             	pushl  -0x40(%ebp)
80104934:	57                   	push   %edi
80104935:	56                   	push   %esi
80104936:	e8 60 cf ff ff       	call   8010189b <writei>
8010493b:	83 c4 20             	add    $0x20,%esp
8010493e:	83 f8 10             	cmp    $0x10,%eax
80104941:	0f 85 8e 00 00 00    	jne    801049d5 <sys_unlink+0x17b>
  if(ip->type == T_DIR){
80104947:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010494c:	0f 84 90 00 00 00    	je     801049e2 <sys_unlink+0x188>
  iunlockput(dp);
80104952:	83 ec 0c             	sub    $0xc,%esp
80104955:	56                   	push   %esi
80104956:	e8 ea cd ff ff       	call   80101745 <iunlockput>
  ip->nlink--;
8010495b:	66 8b 43 56          	mov    0x56(%ebx),%ax
8010495f:	48                   	dec    %eax
80104960:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104964:	89 1c 24             	mov    %ebx,(%esp)
80104967:	e8 c9 ca ff ff       	call   80101435 <iupdate>
  iunlockput(ip);
8010496c:	89 1c 24             	mov    %ebx,(%esp)
8010496f:	e8 d1 cd ff ff       	call   80101745 <iunlockput>
  end_op();
80104974:	e8 ea de ff ff       	call   80102863 <end_op>
  return 0;
80104979:	83 c4 10             	add    $0x10,%esp
8010497c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104981:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104984:	5b                   	pop    %ebx
80104985:	5e                   	pop    %esi
80104986:	5f                   	pop    %edi
80104987:	5d                   	pop    %ebp
80104988:	c3                   	ret    
    end_op();
80104989:	e8 d5 de ff ff       	call   80102863 <end_op>
    return -1;
8010498e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104993:	eb ec                	jmp    80104981 <sys_unlink+0x127>
    panic("unlink: nlink < 1");
80104995:	83 ec 0c             	sub    $0xc,%esp
80104998:	68 08 72 10 80       	push   $0x80107208
8010499d:	e8 b3 b9 ff ff       	call   80100355 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801049a2:	89 d8                	mov    %ebx,%eax
801049a4:	e8 32 f9 ff ff       	call   801042db <isdirempty>
801049a9:	85 c0                	test   %eax,%eax
801049ab:	0f 85 6e ff ff ff    	jne    8010491f <sys_unlink+0xc5>
    iunlockput(ip);
801049b1:	83 ec 0c             	sub    $0xc,%esp
801049b4:	53                   	push   %ebx
801049b5:	e8 8b cd ff ff       	call   80101745 <iunlockput>
    goto bad;
801049ba:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801049bd:	83 ec 0c             	sub    $0xc,%esp
801049c0:	56                   	push   %esi
801049c1:	e8 7f cd ff ff       	call   80101745 <iunlockput>
  end_op();
801049c6:	e8 98 de ff ff       	call   80102863 <end_op>
  return -1;
801049cb:	83 c4 10             	add    $0x10,%esp
801049ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049d3:	eb ac                	jmp    80104981 <sys_unlink+0x127>
    panic("unlink: writei");
801049d5:	83 ec 0c             	sub    $0xc,%esp
801049d8:	68 1a 72 10 80       	push   $0x8010721a
801049dd:	e8 73 b9 ff ff       	call   80100355 <panic>
    dp->nlink--;
801049e2:	66 8b 46 56          	mov    0x56(%esi),%ax
801049e6:	48                   	dec    %eax
801049e7:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801049eb:	83 ec 0c             	sub    $0xc,%esp
801049ee:	56                   	push   %esi
801049ef:	e8 41 ca ff ff       	call   80101435 <iupdate>
801049f4:	83 c4 10             	add    $0x10,%esp
801049f7:	e9 56 ff ff ff       	jmp    80104952 <sys_unlink+0xf8>
    return -1;
801049fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a01:	e9 7b ff ff ff       	jmp    80104981 <sys_unlink+0x127>

80104a06 <sys_open>:

int
sys_open(void)
{
80104a06:	f3 0f 1e fb          	endbr32 
80104a0a:	55                   	push   %ebp
80104a0b:	89 e5                	mov    %esp,%ebp
80104a0d:	57                   	push   %edi
80104a0e:	56                   	push   %esi
80104a0f:	53                   	push   %ebx
80104a10:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104a13:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104a16:	50                   	push   %eax
80104a17:	6a 00                	push   $0x0
80104a19:	e8 96 f7 ff ff       	call   801041b4 <argstr>
80104a1e:	83 c4 10             	add    $0x10,%esp
80104a21:	85 c0                	test   %eax,%eax
80104a23:	0f 88 a0 00 00 00    	js     80104ac9 <sys_open+0xc3>
80104a29:	83 ec 08             	sub    $0x8,%esp
80104a2c:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104a2f:	50                   	push   %eax
80104a30:	6a 01                	push   $0x1
80104a32:	e8 e5 f6 ff ff       	call   8010411c <argint>
80104a37:	83 c4 10             	add    $0x10,%esp
80104a3a:	85 c0                	test   %eax,%eax
80104a3c:	0f 88 87 00 00 00    	js     80104ac9 <sys_open+0xc3>
    return -1;

  begin_op();
80104a42:	e8 9c dd ff ff       	call   801027e3 <begin_op>

  if(omode & O_CREATE){
80104a47:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104a4b:	0f 84 8b 00 00 00    	je     80104adc <sys_open+0xd6>
    ip = create(path, T_FILE, 0, 0);
80104a51:	83 ec 0c             	sub    $0xc,%esp
80104a54:	6a 00                	push   $0x0
80104a56:	b9 00 00 00 00       	mov    $0x0,%ecx
80104a5b:	ba 02 00 00 00       	mov    $0x2,%edx
80104a60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a63:	e8 ca f8 ff ff       	call   80104332 <create>
80104a68:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104a6a:	83 c4 10             	add    $0x10,%esp
80104a6d:	85 c0                	test   %eax,%eax
80104a6f:	74 5f                	je     80104ad0 <sys_open+0xca>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104a71:	e8 bb c1 ff ff       	call   80100c31 <filealloc>
80104a76:	89 c3                	mov    %eax,%ebx
80104a78:	85 c0                	test   %eax,%eax
80104a7a:	0f 84 b5 00 00 00    	je     80104b35 <sys_open+0x12f>
80104a80:	e8 21 f8 ff ff       	call   801042a6 <fdalloc>
80104a85:	89 c7                	mov    %eax,%edi
80104a87:	85 c0                	test   %eax,%eax
80104a89:	0f 88 a6 00 00 00    	js     80104b35 <sys_open+0x12f>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104a8f:	83 ec 0c             	sub    $0xc,%esp
80104a92:	56                   	push   %esi
80104a93:	e8 c2 cb ff ff       	call   8010165a <iunlock>
  end_op();
80104a98:	e8 c6 dd ff ff       	call   80102863 <end_op>

  f->type = FD_INODE;
80104a9d:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104aa3:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104aa6:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ab0:	83 c4 10             	add    $0x10,%esp
80104ab3:	a8 01                	test   $0x1,%al
80104ab5:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104ab9:	a8 03                	test   $0x3,%al
80104abb:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104abf:	89 f8                	mov    %edi,%eax
80104ac1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ac4:	5b                   	pop    %ebx
80104ac5:	5e                   	pop    %esi
80104ac6:	5f                   	pop    %edi
80104ac7:	5d                   	pop    %ebp
80104ac8:	c3                   	ret    
    return -1;
80104ac9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104ace:	eb ef                	jmp    80104abf <sys_open+0xb9>
      end_op();
80104ad0:	e8 8e dd ff ff       	call   80102863 <end_op>
      return -1;
80104ad5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104ada:	eb e3                	jmp    80104abf <sys_open+0xb9>
    if((ip = namei(path)) == 0){
80104adc:	83 ec 0c             	sub    $0xc,%esp
80104adf:	ff 75 e4             	pushl  -0x1c(%ebp)
80104ae2:	e8 3b d1 ff ff       	call   80101c22 <namei>
80104ae7:	89 c6                	mov    %eax,%esi
80104ae9:	83 c4 10             	add    $0x10,%esp
80104aec:	85 c0                	test   %eax,%eax
80104aee:	74 39                	je     80104b29 <sys_open+0x123>
    ilock(ip);
80104af0:	83 ec 0c             	sub    $0xc,%esp
80104af3:	50                   	push   %eax
80104af4:	e8 9d ca ff ff       	call   80101596 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104af9:	83 c4 10             	add    $0x10,%esp
80104afc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104b01:	0f 85 6a ff ff ff    	jne    80104a71 <sys_open+0x6b>
80104b07:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104b0b:	0f 84 60 ff ff ff    	je     80104a71 <sys_open+0x6b>
      iunlockput(ip);
80104b11:	83 ec 0c             	sub    $0xc,%esp
80104b14:	56                   	push   %esi
80104b15:	e8 2b cc ff ff       	call   80101745 <iunlockput>
      end_op();
80104b1a:	e8 44 dd ff ff       	call   80102863 <end_op>
      return -1;
80104b1f:	83 c4 10             	add    $0x10,%esp
80104b22:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b27:	eb 96                	jmp    80104abf <sys_open+0xb9>
      end_op();
80104b29:	e8 35 dd ff ff       	call   80102863 <end_op>
      return -1;
80104b2e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b33:	eb 8a                	jmp    80104abf <sys_open+0xb9>
    if(f)
80104b35:	85 db                	test   %ebx,%ebx
80104b37:	74 0c                	je     80104b45 <sys_open+0x13f>
      fileclose(f);
80104b39:	83 ec 0c             	sub    $0xc,%esp
80104b3c:	53                   	push   %ebx
80104b3d:	e8 9b c1 ff ff       	call   80100cdd <fileclose>
80104b42:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104b45:	83 ec 0c             	sub    $0xc,%esp
80104b48:	56                   	push   %esi
80104b49:	e8 f7 cb ff ff       	call   80101745 <iunlockput>
    end_op();
80104b4e:	e8 10 dd ff ff       	call   80102863 <end_op>
    return -1;
80104b53:	83 c4 10             	add    $0x10,%esp
80104b56:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b5b:	e9 5f ff ff ff       	jmp    80104abf <sys_open+0xb9>

80104b60 <sys_mkdir>:

int
sys_mkdir(void)
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104b6a:	e8 74 dc ff ff       	call   801027e3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104b6f:	83 ec 08             	sub    $0x8,%esp
80104b72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b75:	50                   	push   %eax
80104b76:	6a 00                	push   $0x0
80104b78:	e8 37 f6 ff ff       	call   801041b4 <argstr>
80104b7d:	83 c4 10             	add    $0x10,%esp
80104b80:	85 c0                	test   %eax,%eax
80104b82:	78 36                	js     80104bba <sys_mkdir+0x5a>
80104b84:	83 ec 0c             	sub    $0xc,%esp
80104b87:	6a 00                	push   $0x0
80104b89:	b9 00 00 00 00       	mov    $0x0,%ecx
80104b8e:	ba 01 00 00 00       	mov    $0x1,%edx
80104b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b96:	e8 97 f7 ff ff       	call   80104332 <create>
80104b9b:	83 c4 10             	add    $0x10,%esp
80104b9e:	85 c0                	test   %eax,%eax
80104ba0:	74 18                	je     80104bba <sys_mkdir+0x5a>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104ba2:	83 ec 0c             	sub    $0xc,%esp
80104ba5:	50                   	push   %eax
80104ba6:	e8 9a cb ff ff       	call   80101745 <iunlockput>
  end_op();
80104bab:	e8 b3 dc ff ff       	call   80102863 <end_op>
  return 0;
80104bb0:	83 c4 10             	add    $0x10,%esp
80104bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104bb8:	c9                   	leave  
80104bb9:	c3                   	ret    
    end_op();
80104bba:	e8 a4 dc ff ff       	call   80102863 <end_op>
    return -1;
80104bbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc4:	eb f2                	jmp    80104bb8 <sys_mkdir+0x58>

80104bc6 <sys_mknod>:

int
sys_mknod(void)
{
80104bc6:	f3 0f 1e fb          	endbr32 
80104bca:	55                   	push   %ebp
80104bcb:	89 e5                	mov    %esp,%ebp
80104bcd:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104bd0:	e8 0e dc ff ff       	call   801027e3 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104bd5:	83 ec 08             	sub    $0x8,%esp
80104bd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bdb:	50                   	push   %eax
80104bdc:	6a 00                	push   $0x0
80104bde:	e8 d1 f5 ff ff       	call   801041b4 <argstr>
80104be3:	83 c4 10             	add    $0x10,%esp
80104be6:	85 c0                	test   %eax,%eax
80104be8:	78 62                	js     80104c4c <sys_mknod+0x86>
     argint(1, &major) < 0 ||
80104bea:	83 ec 08             	sub    $0x8,%esp
80104bed:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bf0:	50                   	push   %eax
80104bf1:	6a 01                	push   $0x1
80104bf3:	e8 24 f5 ff ff       	call   8010411c <argint>
  if((argstr(0, &path)) < 0 ||
80104bf8:	83 c4 10             	add    $0x10,%esp
80104bfb:	85 c0                	test   %eax,%eax
80104bfd:	78 4d                	js     80104c4c <sys_mknod+0x86>
     argint(2, &minor) < 0 ||
80104bff:	83 ec 08             	sub    $0x8,%esp
80104c02:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c05:	50                   	push   %eax
80104c06:	6a 02                	push   $0x2
80104c08:	e8 0f f5 ff ff       	call   8010411c <argint>
     argint(1, &major) < 0 ||
80104c0d:	83 c4 10             	add    $0x10,%esp
80104c10:	85 c0                	test   %eax,%eax
80104c12:	78 38                	js     80104c4c <sys_mknod+0x86>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104c14:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104c18:	83 ec 0c             	sub    $0xc,%esp
80104c1b:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104c1f:	50                   	push   %eax
80104c20:	ba 03 00 00 00       	mov    $0x3,%edx
80104c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c28:	e8 05 f7 ff ff       	call   80104332 <create>
     argint(2, &minor) < 0 ||
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	85 c0                	test   %eax,%eax
80104c32:	74 18                	je     80104c4c <sys_mknod+0x86>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104c34:	83 ec 0c             	sub    $0xc,%esp
80104c37:	50                   	push   %eax
80104c38:	e8 08 cb ff ff       	call   80101745 <iunlockput>
  end_op();
80104c3d:	e8 21 dc ff ff       	call   80102863 <end_op>
  return 0;
80104c42:	83 c4 10             	add    $0x10,%esp
80104c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c4a:	c9                   	leave  
80104c4b:	c3                   	ret    
    end_op();
80104c4c:	e8 12 dc ff ff       	call   80102863 <end_op>
    return -1;
80104c51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c56:	eb f2                	jmp    80104c4a <sys_mknod+0x84>

80104c58 <sys_chdir>:

int
sys_chdir(void)
{
80104c58:	f3 0f 1e fb          	endbr32 
80104c5c:	55                   	push   %ebp
80104c5d:	89 e5                	mov    %esp,%ebp
80104c5f:	56                   	push   %esi
80104c60:	53                   	push   %ebx
80104c61:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104c64:	e8 0c e6 ff ff       	call   80103275 <myproc>
80104c69:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104c6b:	e8 73 db ff ff       	call   801027e3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104c70:	83 ec 08             	sub    $0x8,%esp
80104c73:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c76:	50                   	push   %eax
80104c77:	6a 00                	push   $0x0
80104c79:	e8 36 f5 ff ff       	call   801041b4 <argstr>
80104c7e:	83 c4 10             	add    $0x10,%esp
80104c81:	85 c0                	test   %eax,%eax
80104c83:	78 52                	js     80104cd7 <sys_chdir+0x7f>
80104c85:	83 ec 0c             	sub    $0xc,%esp
80104c88:	ff 75 f4             	pushl  -0xc(%ebp)
80104c8b:	e8 92 cf ff ff       	call   80101c22 <namei>
80104c90:	89 c3                	mov    %eax,%ebx
80104c92:	83 c4 10             	add    $0x10,%esp
80104c95:	85 c0                	test   %eax,%eax
80104c97:	74 3e                	je     80104cd7 <sys_chdir+0x7f>
    end_op();
    return -1;
  }
  ilock(ip);
80104c99:	83 ec 0c             	sub    $0xc,%esp
80104c9c:	50                   	push   %eax
80104c9d:	e8 f4 c8 ff ff       	call   80101596 <ilock>
  if(ip->type != T_DIR){
80104ca2:	83 c4 10             	add    $0x10,%esp
80104ca5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104caa:	75 37                	jne    80104ce3 <sys_chdir+0x8b>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104cac:	83 ec 0c             	sub    $0xc,%esp
80104caf:	53                   	push   %ebx
80104cb0:	e8 a5 c9 ff ff       	call   8010165a <iunlock>
  iput(curproc->cwd);
80104cb5:	83 c4 04             	add    $0x4,%esp
80104cb8:	ff 76 68             	pushl  0x68(%esi)
80104cbb:	e8 e3 c9 ff ff       	call   801016a3 <iput>
  end_op();
80104cc0:	e8 9e db ff ff       	call   80102863 <end_op>
  curproc->cwd = ip;
80104cc5:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104cc8:	83 c4 10             	add    $0x10,%esp
80104ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cd3:	5b                   	pop    %ebx
80104cd4:	5e                   	pop    %esi
80104cd5:	5d                   	pop    %ebp
80104cd6:	c3                   	ret    
    end_op();
80104cd7:	e8 87 db ff ff       	call   80102863 <end_op>
    return -1;
80104cdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce1:	eb ed                	jmp    80104cd0 <sys_chdir+0x78>
    iunlockput(ip);
80104ce3:	83 ec 0c             	sub    $0xc,%esp
80104ce6:	53                   	push   %ebx
80104ce7:	e8 59 ca ff ff       	call   80101745 <iunlockput>
    end_op();
80104cec:	e8 72 db ff ff       	call   80102863 <end_op>
    return -1;
80104cf1:	83 c4 10             	add    $0x10,%esp
80104cf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cf9:	eb d5                	jmp    80104cd0 <sys_chdir+0x78>

80104cfb <sys_exec>:

int
sys_exec(void)
{
80104cfb:	f3 0f 1e fb          	endbr32 
80104cff:	55                   	push   %ebp
80104d00:	89 e5                	mov    %esp,%ebp
80104d02:	53                   	push   %ebx
80104d03:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104d09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d0c:	50                   	push   %eax
80104d0d:	6a 00                	push   $0x0
80104d0f:	e8 a0 f4 ff ff       	call   801041b4 <argstr>
80104d14:	83 c4 10             	add    $0x10,%esp
80104d17:	85 c0                	test   %eax,%eax
80104d19:	78 38                	js     80104d53 <sys_exec+0x58>
80104d1b:	83 ec 08             	sub    $0x8,%esp
80104d1e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104d24:	50                   	push   %eax
80104d25:	6a 01                	push   $0x1
80104d27:	e8 f0 f3 ff ff       	call   8010411c <argint>
80104d2c:	83 c4 10             	add    $0x10,%esp
80104d2f:	85 c0                	test   %eax,%eax
80104d31:	78 20                	js     80104d53 <sys_exec+0x58>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104d33:	83 ec 04             	sub    $0x4,%esp
80104d36:	68 80 00 00 00       	push   $0x80
80104d3b:	6a 00                	push   $0x0
80104d3d:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104d43:	50                   	push   %eax
80104d44:	e8 7a f1 ff ff       	call   80103ec3 <memset>
80104d49:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104d4c:	bb 00 00 00 00       	mov    $0x0,%ebx
80104d51:	eb 2a                	jmp    80104d7d <sys_exec+0x82>
    return -1;
80104d53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d58:	eb 76                	jmp    80104dd0 <sys_exec+0xd5>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104d5a:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104d61:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104d65:	83 ec 08             	sub    $0x8,%esp
80104d68:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104d6e:	50                   	push   %eax
80104d6f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d72:	e8 48 bb ff ff       	call   801008bf <exec>
80104d77:	83 c4 10             	add    $0x10,%esp
80104d7a:	eb 54                	jmp    80104dd0 <sys_exec+0xd5>
  for(i=0;; i++){
80104d7c:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80104d7d:	83 fb 1f             	cmp    $0x1f,%ebx
80104d80:	77 49                	ja     80104dcb <sys_exec+0xd0>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104d82:	83 ec 08             	sub    $0x8,%esp
80104d85:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104d8b:	50                   	push   %eax
80104d8c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104d92:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104d95:	50                   	push   %eax
80104d96:	e8 ff f2 ff ff       	call   8010409a <fetchint>
80104d9b:	83 c4 10             	add    $0x10,%esp
80104d9e:	85 c0                	test   %eax,%eax
80104da0:	78 33                	js     80104dd5 <sys_exec+0xda>
    if(uarg == 0){
80104da2:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104da8:	85 c0                	test   %eax,%eax
80104daa:	74 ae                	je     80104d5a <sys_exec+0x5f>
    if(fetchstr(uarg, &argv[i]) < 0)
80104dac:	83 ec 08             	sub    $0x8,%esp
80104daf:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104db6:	52                   	push   %edx
80104db7:	50                   	push   %eax
80104db8:	e8 1d f3 ff ff       	call   801040da <fetchstr>
80104dbd:	83 c4 10             	add    $0x10,%esp
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	79 b8                	jns    80104d7c <sys_exec+0x81>
      return -1;
80104dc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc9:	eb 05                	jmp    80104dd0 <sys_exec+0xd5>
      return -1;
80104dcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dd3:	c9                   	leave  
80104dd4:	c3                   	ret    
      return -1;
80104dd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dda:	eb f4                	jmp    80104dd0 <sys_exec+0xd5>

80104ddc <sys_pipe>:

int
sys_pipe(void)
{
80104ddc:	f3 0f 1e fb          	endbr32 
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104de7:	6a 08                	push   $0x8
80104de9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dec:	50                   	push   %eax
80104ded:	6a 00                	push   $0x0
80104def:	e8 54 f3 ff ff       	call   80104148 <argptr>
80104df4:	83 c4 10             	add    $0x10,%esp
80104df7:	85 c0                	test   %eax,%eax
80104df9:	78 79                	js     80104e74 <sys_pipe+0x98>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104dfb:	83 ec 08             	sub    $0x8,%esp
80104dfe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104e01:	50                   	push   %eax
80104e02:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e05:	50                   	push   %eax
80104e06:	e8 6b df ff ff       	call   80102d76 <pipealloc>
80104e0b:	83 c4 10             	add    $0x10,%esp
80104e0e:	85 c0                	test   %eax,%eax
80104e10:	78 69                	js     80104e7b <sys_pipe+0x9f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e15:	e8 8c f4 ff ff       	call   801042a6 <fdalloc>
80104e1a:	89 c3                	mov    %eax,%ebx
80104e1c:	85 c0                	test   %eax,%eax
80104e1e:	78 21                	js     80104e41 <sys_pipe+0x65>
80104e20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e23:	e8 7e f4 ff ff       	call   801042a6 <fdalloc>
80104e28:	85 c0                	test   %eax,%eax
80104e2a:	78 15                	js     80104e41 <sys_pipe+0x65>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104e2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e2f:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e34:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104e37:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e3f:	c9                   	leave  
80104e40:	c3                   	ret    
    if(fd0 >= 0)
80104e41:	85 db                	test   %ebx,%ebx
80104e43:	79 20                	jns    80104e65 <sys_pipe+0x89>
    fileclose(rf);
80104e45:	83 ec 0c             	sub    $0xc,%esp
80104e48:	ff 75 f0             	pushl  -0x10(%ebp)
80104e4b:	e8 8d be ff ff       	call   80100cdd <fileclose>
    fileclose(wf);
80104e50:	83 c4 04             	add    $0x4,%esp
80104e53:	ff 75 ec             	pushl  -0x14(%ebp)
80104e56:	e8 82 be ff ff       	call   80100cdd <fileclose>
    return -1;
80104e5b:	83 c4 10             	add    $0x10,%esp
80104e5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e63:	eb d7                	jmp    80104e3c <sys_pipe+0x60>
      myproc()->ofile[fd0] = 0;
80104e65:	e8 0b e4 ff ff       	call   80103275 <myproc>
80104e6a:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104e71:	00 
80104e72:	eb d1                	jmp    80104e45 <sys_pipe+0x69>
    return -1;
80104e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e79:	eb c1                	jmp    80104e3c <sys_pipe+0x60>
    return -1;
80104e7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e80:	eb ba                	jmp    80104e3c <sys_pipe+0x60>

80104e82 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104e82:	f3 0f 1e fb          	endbr32 
80104e86:	55                   	push   %ebp
80104e87:	89 e5                	mov    %esp,%ebp
80104e89:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104e8c:	e8 64 e5 ff ff       	call   801033f5 <fork>
}
80104e91:	c9                   	leave  
80104e92:	c3                   	ret    

80104e93 <sys_exit>:

int
sys_exit(void)
{
80104e93:	f3 0f 1e fb          	endbr32 
80104e97:	55                   	push   %ebp
80104e98:	89 e5                	mov    %esp,%ebp
80104e9a:	83 ec 20             	sub    $0x20,%esp
  int status;
  if(argint(0, &status)<0)
80104e9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ea0:	50                   	push   %eax
80104ea1:	6a 00                	push   $0x0
80104ea3:	e8 74 f2 ff ff       	call   8010411c <argint>
80104ea8:	83 c4 10             	add    $0x10,%esp
80104eab:	85 c0                	test   %eax,%eax
80104ead:	78 19                	js     80104ec8 <sys_exit+0x35>
    return -1;
  exit(status<<8);
80104eaf:	83 ec 0c             	sub    $0xc,%esp
80104eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb5:	c1 e0 08             	shl    $0x8,%eax
80104eb8:	50                   	push   %eax
80104eb9:	e8 24 e8 ff ff       	call   801036e2 <exit>
  return 0;  // not reached
80104ebe:	83 c4 10             	add    $0x10,%esp
80104ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ec6:	c9                   	leave  
80104ec7:	c3                   	ret    
    return -1;
80104ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ecd:	eb f7                	jmp    80104ec6 <sys_exit+0x33>

80104ecf <sys_wait>:

int
sys_wait(void)
{
80104ecf:	f3 0f 1e fb          	endbr32 
80104ed3:	55                   	push   %ebp
80104ed4:	89 e5                	mov    %esp,%ebp
80104ed6:	83 ec 1c             	sub    $0x1c,%esp
  int * status;
  if (argptr(0, (void **)&status, sizeof(int)) < 0)
80104ed9:	6a 04                	push   $0x4
80104edb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ede:	50                   	push   %eax
80104edf:	6a 00                	push   $0x0
80104ee1:	e8 62 f2 ff ff       	call   80104148 <argptr>
80104ee6:	83 c4 10             	add    $0x10,%esp
80104ee9:	85 c0                	test   %eax,%eax
80104eeb:	78 10                	js     80104efd <sys_wait+0x2e>
    return -1;
  return wait(status);
80104eed:	83 ec 0c             	sub    $0xc,%esp
80104ef0:	ff 75 f4             	pushl  -0xc(%ebp)
80104ef3:	e8 97 e9 ff ff       	call   8010388f <wait>
80104ef8:	83 c4 10             	add    $0x10,%esp
}
80104efb:	c9                   	leave  
80104efc:	c3                   	ret    
    return -1;
80104efd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f02:	eb f7                	jmp    80104efb <sys_wait+0x2c>

80104f04 <sys_kill>:

int
sys_kill(void)
{
80104f04:	f3 0f 1e fb          	endbr32 
80104f08:	55                   	push   %ebp
80104f09:	89 e5                	mov    %esp,%ebp
80104f0b:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104f0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f11:	50                   	push   %eax
80104f12:	6a 00                	push   $0x0
80104f14:	e8 03 f2 ff ff       	call   8010411c <argint>
80104f19:	83 c4 10             	add    $0x10,%esp
80104f1c:	85 c0                	test   %eax,%eax
80104f1e:	78 10                	js     80104f30 <sys_kill+0x2c>
    return -1;
  return kill(pid);
80104f20:	83 ec 0c             	sub    $0xc,%esp
80104f23:	ff 75 f4             	pushl  -0xc(%ebp)
80104f26:	e8 76 ea ff ff       	call   801039a1 <kill>
80104f2b:	83 c4 10             	add    $0x10,%esp
}
80104f2e:	c9                   	leave  
80104f2f:	c3                   	ret    
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f35:	eb f7                	jmp    80104f2e <sys_kill+0x2a>

80104f37 <sys_getpid>:

int
sys_getpid(void)
{
80104f37:	f3 0f 1e fb          	endbr32 
80104f3b:	55                   	push   %ebp
80104f3c:	89 e5                	mov    %esp,%ebp
80104f3e:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104f41:	e8 2f e3 ff ff       	call   80103275 <myproc>
80104f46:	8b 40 10             	mov    0x10(%eax),%eax
}
80104f49:	c9                   	leave  
80104f4a:	c3                   	ret    

80104f4b <sys_sbrk>:

int
sys_sbrk(void)
{
80104f4b:	f3 0f 1e fb          	endbr32 
80104f4f:	55                   	push   %ebp
80104f50:	89 e5                	mov    %esp,%ebp
80104f52:	53                   	push   %ebx
80104f53:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104f56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f59:	50                   	push   %eax
80104f5a:	6a 00                	push   $0x0
80104f5c:	e8 bb f1 ff ff       	call   8010411c <argint>
80104f61:	83 c4 10             	add    $0x10,%esp
80104f64:	85 c0                	test   %eax,%eax
80104f66:	78 3a                	js     80104fa2 <sys_sbrk+0x57>
    return -1;
  addr = myproc()->sz;
80104f68:	e8 08 e3 ff ff       	call   80103275 <myproc>
80104f6d:	8b 18                	mov    (%eax),%ebx

  if(n > 0){
80104f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f72:	85 c0                	test   %eax,%eax
80104f74:	7f 09                	jg     80104f7f <sys_sbrk+0x34>
    myproc()->sz += n; // Si es mayor que 0 se aumenta el tamaño del proceso pero no se llama a growproc (allocuvm)
  }else if(n<0){
80104f76:	78 13                	js     80104f8b <sys_sbrk+0x40>
    if(growproc(n) < 0) // Se hace un deallocuvm
      return -1; 
  }

  return addr;
}
80104f78:	89 d8                	mov    %ebx,%eax
80104f7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f7d:	c9                   	leave  
80104f7e:	c3                   	ret    
    myproc()->sz += n; // Si es mayor que 0 se aumenta el tamaño del proceso pero no se llama a growproc (allocuvm)
80104f7f:	e8 f1 e2 ff ff       	call   80103275 <myproc>
80104f84:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f87:	01 10                	add    %edx,(%eax)
80104f89:	eb ed                	jmp    80104f78 <sys_sbrk+0x2d>
    if(growproc(n) < 0) // Se hace un deallocuvm
80104f8b:	83 ec 0c             	sub    $0xc,%esp
80104f8e:	50                   	push   %eax
80104f8f:	e8 f3 e3 ff ff       	call   80103387 <growproc>
80104f94:	83 c4 10             	add    $0x10,%esp
80104f97:	85 c0                	test   %eax,%eax
80104f99:	79 dd                	jns    80104f78 <sys_sbrk+0x2d>
      return -1; 
80104f9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104fa0:	eb d6                	jmp    80104f78 <sys_sbrk+0x2d>
    return -1;
80104fa2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104fa7:	eb cf                	jmp    80104f78 <sys_sbrk+0x2d>

80104fa9 <sys_sleep>:

int
sys_sleep(void)
{
80104fa9:	f3 0f 1e fb          	endbr32 
80104fad:	55                   	push   %ebp
80104fae:	89 e5                	mov    %esp,%ebp
80104fb0:	53                   	push   %ebx
80104fb1:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fb7:	50                   	push   %eax
80104fb8:	6a 00                	push   $0x0
80104fba:	e8 5d f1 ff ff       	call   8010411c <argint>
80104fbf:	83 c4 10             	add    $0x10,%esp
80104fc2:	85 c0                	test   %eax,%eax
80104fc4:	78 75                	js     8010503b <sys_sleep+0x92>
    return -1;
  acquire(&tickslock);
80104fc6:	83 ec 0c             	sub    $0xc,%esp
80104fc9:	68 60 4f 11 80       	push   $0x80114f60
80104fce:	e8 3c ee ff ff       	call   80103e0f <acquire>
  ticks0 = ticks;
80104fd3:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  while(ticks - ticks0 < n){
80104fd9:	83 c4 10             	add    $0x10,%esp
80104fdc:	a1 a0 57 11 80       	mov    0x801157a0,%eax
80104fe1:	29 d8                	sub    %ebx,%eax
80104fe3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104fe6:	73 39                	jae    80105021 <sys_sleep+0x78>
    if(myproc()->killed){
80104fe8:	e8 88 e2 ff ff       	call   80103275 <myproc>
80104fed:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104ff1:	75 17                	jne    8010500a <sys_sleep+0x61>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104ff3:	83 ec 08             	sub    $0x8,%esp
80104ff6:	68 60 4f 11 80       	push   $0x80114f60
80104ffb:	68 a0 57 11 80       	push   $0x801157a0
80105000:	e8 f5 e7 ff ff       	call   801037fa <sleep>
80105005:	83 c4 10             	add    $0x10,%esp
80105008:	eb d2                	jmp    80104fdc <sys_sleep+0x33>
      release(&tickslock);
8010500a:	83 ec 0c             	sub    $0xc,%esp
8010500d:	68 60 4f 11 80       	push   $0x80114f60
80105012:	e8 61 ee ff ff       	call   80103e78 <release>
      return -1;
80105017:	83 c4 10             	add    $0x10,%esp
8010501a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501f:	eb 15                	jmp    80105036 <sys_sleep+0x8d>
  }
  release(&tickslock);
80105021:	83 ec 0c             	sub    $0xc,%esp
80105024:	68 60 4f 11 80       	push   $0x80114f60
80105029:	e8 4a ee ff ff       	call   80103e78 <release>
  return 0;
8010502e:	83 c4 10             	add    $0x10,%esp
80105031:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105036:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105039:	c9                   	leave  
8010503a:	c3                   	ret    
    return -1;
8010503b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105040:	eb f4                	jmp    80105036 <sys_sleep+0x8d>

80105042 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105042:	f3 0f 1e fb          	endbr32 
80105046:	55                   	push   %ebp
80105047:	89 e5                	mov    %esp,%ebp
80105049:	53                   	push   %ebx
8010504a:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010504d:	68 60 4f 11 80       	push   $0x80114f60
80105052:	e8 b8 ed ff ff       	call   80103e0f <acquire>
  xticks = ticks;
80105057:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  release(&tickslock);
8010505d:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105064:	e8 0f ee ff ff       	call   80103e78 <release>
  return xticks;
}
80105069:	89 d8                	mov    %ebx,%eax
8010506b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010506e:	c9                   	leave  
8010506f:	c3                   	ret    

80105070 <sys_date>:

int
sys_date(void){
80105070:	f3 0f 1e fb          	endbr32 
80105074:	55                   	push   %ebp
80105075:	89 e5                	mov    %esp,%ebp
80105077:	83 ec 1c             	sub    $0x1c,%esp

  struct rtcdate *d;
  
  if(argptr(0,(void **)&d,sizeof(struct rtcdate))<0)
8010507a:	6a 18                	push   $0x18
8010507c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010507f:	50                   	push   %eax
80105080:	6a 00                	push   $0x0
80105082:	e8 c1 f0 ff ff       	call   80104148 <argptr>
80105087:	83 c4 10             	add    $0x10,%esp
8010508a:	85 c0                	test   %eax,%eax
8010508c:	78 15                	js     801050a3 <sys_date+0x33>
    return -1;
  cmostime(d);
8010508e:	83 ec 0c             	sub    $0xc,%esp
80105091:	ff 75 f4             	pushl  -0xc(%ebp)
80105094:	e8 14 d4 ff ff       	call   801024ad <cmostime>
  return 0;
80105099:	83 c4 10             	add    $0x10,%esp
8010509c:	b8 00 00 00 00       	mov    $0x0,%eax

}
801050a1:	c9                   	leave  
801050a2:	c3                   	ret    
    return -1;
801050a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a8:	eb f7                	jmp    801050a1 <sys_date+0x31>

801050aa <sys_getprio>:

int
sys_getprio(void)
{
801050aa:	f3 0f 1e fb          	endbr32 
801050ae:	55                   	push   %ebp
801050af:	89 e5                	mov    %esp,%ebp
801050b1:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0)
801050b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050b7:	50                   	push   %eax
801050b8:	6a 00                	push   $0x0
801050ba:	e8 5d f0 ff ff       	call   8010411c <argint>
801050bf:	83 c4 10             	add    $0x10,%esp
801050c2:	85 c0                	test   %eax,%eax
801050c4:	78 10                	js     801050d6 <sys_getprio+0x2c>
    return -1;
  
  return getprio(pid);
801050c6:	83 ec 0c             	sub    $0xc,%esp
801050c9:	ff 75 f4             	pushl  -0xc(%ebp)
801050cc:	e8 01 ea ff ff       	call   80103ad2 <getprio>
801050d1:	83 c4 10             	add    $0x10,%esp
}
801050d4:	c9                   	leave  
801050d5:	c3                   	ret    
    return -1;
801050d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050db:	eb f7                	jmp    801050d4 <sys_getprio+0x2a>

801050dd <sys_setprio>:

int
sys_setprio(void)
{
801050dd:	f3 0f 1e fb          	endbr32 
801050e1:	55                   	push   %ebp
801050e2:	89 e5                	mov    %esp,%ebp
801050e4:	83 ec 20             	sub    $0x20,%esp
  int pid;
  enum proc_prio prio;
  if(argint(0, &pid) < 0 || argptr(1, (void **)&prio, sizeof(enum proc_prio)) < 0)
801050e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ea:	50                   	push   %eax
801050eb:	6a 00                	push   $0x0
801050ed:	e8 2a f0 ff ff       	call   8010411c <argint>
801050f2:	83 c4 10             	add    $0x10,%esp
801050f5:	85 c0                	test   %eax,%eax
801050f7:	78 2a                	js     80105123 <sys_setprio+0x46>
801050f9:	83 ec 04             	sub    $0x4,%esp
801050fc:	6a 04                	push   $0x4
801050fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105101:	50                   	push   %eax
80105102:	6a 01                	push   $0x1
80105104:	e8 3f f0 ff ff       	call   80104148 <argptr>
80105109:	83 c4 10             	add    $0x10,%esp
8010510c:	85 c0                	test   %eax,%eax
8010510e:	78 13                	js     80105123 <sys_setprio+0x46>
    return -1;
  return setprio(pid, prio);
80105110:	83 ec 08             	sub    $0x8,%esp
80105113:	ff 75 f0             	pushl  -0x10(%ebp)
80105116:	ff 75 f4             	pushl  -0xc(%ebp)
80105119:	e8 1e ea ff ff       	call   80103b3c <setprio>
8010511e:	83 c4 10             	add    $0x10,%esp
}
80105121:	c9                   	leave  
80105122:	c3                   	ret    
    return -1;
80105123:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105128:	eb f7                	jmp    80105121 <sys_setprio+0x44>

8010512a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010512a:	1e                   	push   %ds
  pushl %es
8010512b:	06                   	push   %es
  pushl %fs
8010512c:	0f a0                	push   %fs
  pushl %gs
8010512e:	0f a8                	push   %gs
  pushal
80105130:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105131:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105135:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105137:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105139:	54                   	push   %esp
  call trap
8010513a:	e8 e6 00 00 00       	call   80105225 <trap>
  addl $4, %esp
8010513f:	83 c4 04             	add    $0x4,%esp

80105142 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105142:	61                   	popa   
  popl %gs
80105143:	0f a9                	pop    %gs
  popl %fs
80105145:	0f a1                	pop    %fs
  popl %es
80105147:	07                   	pop    %es
  popl %ds
80105148:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105149:	83 c4 08             	add    $0x8,%esp
  iret
8010514c:	cf                   	iret   

8010514d <tvinit>:
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);

void
tvinit(void)
{
8010514d:	f3 0f 1e fb          	endbr32 
80105151:	55                   	push   %ebp
80105152:	89 e5                	mov    %esp,%ebp
80105154:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
80105157:	b8 00 00 00 00       	mov    $0x0,%eax
8010515c:	3d ff 00 00 00       	cmp    $0xff,%eax
80105161:	7f 49                	jg     801051ac <tvinit+0x5f>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105163:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
8010516a:	66 89 0c c5 a0 4f 11 	mov    %cx,-0x7feeb060(,%eax,8)
80105171:	80 
80105172:	66 c7 04 c5 a2 4f 11 	movw   $0x8,-0x7feeb05e(,%eax,8)
80105179:	80 08 00 
8010517c:	c6 04 c5 a4 4f 11 80 	movb   $0x0,-0x7feeb05c(,%eax,8)
80105183:	00 
80105184:	8a 14 c5 a5 4f 11 80 	mov    -0x7feeb05b(,%eax,8),%dl
8010518b:	83 e2 f0             	and    $0xfffffff0,%edx
8010518e:	83 ca 0e             	or     $0xe,%edx
80105191:	83 e2 8f             	and    $0xffffff8f,%edx
80105194:	83 ca 80             	or     $0xffffff80,%edx
80105197:	88 14 c5 a5 4f 11 80 	mov    %dl,-0x7feeb05b(,%eax,8)
8010519e:	c1 e9 10             	shr    $0x10,%ecx
801051a1:	66 89 0c c5 a6 4f 11 	mov    %cx,-0x7feeb05a(,%eax,8)
801051a8:	80 
  for(i = 0; i < 256; i++)
801051a9:	40                   	inc    %eax
801051aa:	eb b0                	jmp    8010515c <tvinit+0xf>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801051ac:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
801051b2:	66 89 15 a0 51 11 80 	mov    %dx,0x801151a0
801051b9:	66 c7 05 a2 51 11 80 	movw   $0x8,0x801151a2
801051c0:	08 00 
801051c2:	c6 05 a4 51 11 80 00 	movb   $0x0,0x801151a4
801051c9:	a0 a5 51 11 80       	mov    0x801151a5,%al
801051ce:	83 c8 0f             	or     $0xf,%eax
801051d1:	83 e0 ef             	and    $0xffffffef,%eax
801051d4:	83 c8 e0             	or     $0xffffffe0,%eax
801051d7:	a2 a5 51 11 80       	mov    %al,0x801151a5
801051dc:	c1 ea 10             	shr    $0x10,%edx
801051df:	66 89 15 a6 51 11 80 	mov    %dx,0x801151a6

  initlock(&tickslock, "time");
801051e6:	83 ec 08             	sub    $0x8,%esp
801051e9:	68 29 72 10 80       	push   $0x80107229
801051ee:	68 60 4f 11 80       	push   $0x80114f60
801051f3:	e8 cc ea ff ff       	call   80103cc4 <initlock>
}
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	c9                   	leave  
801051fc:	c3                   	ret    

801051fd <idtinit>:

void
idtinit(void)
{
801051fd:	f3 0f 1e fb          	endbr32 
80105201:	55                   	push   %ebp
80105202:	89 e5                	mov    %esp,%ebp
80105204:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105207:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
8010520d:	b8 a0 4f 11 80       	mov    $0x80114fa0,%eax
80105212:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105216:	c1 e8 10             	shr    $0x10,%eax
80105219:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010521d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105220:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105223:	c9                   	leave  
80105224:	c3                   	ret    

80105225 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105225:	f3 0f 1e fb          	endbr32 
80105229:	55                   	push   %ebp
8010522a:	89 e5                	mov    %esp,%ebp
8010522c:	57                   	push   %edi
8010522d:	56                   	push   %esi
8010522e:	53                   	push   %ebx
8010522f:	83 ec 1c             	sub    $0x1c,%esp
80105232:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105235:	8b 43 30             	mov    0x30(%ebx),%eax
80105238:	83 f8 40             	cmp    $0x40,%eax
8010523b:	74 14                	je     80105251 <trap+0x2c>
      exit(0);
    return;
  }
  uint dirPageErr;
  char *mem;
  switch(tf->trapno){
8010523d:	83 e8 0e             	sub    $0xe,%eax
80105240:	83 f8 31             	cmp    $0x31,%eax
80105243:	0f 87 f5 02 00 00    	ja     8010553e <trap+0x319>
80105249:	3e ff 24 85 14 73 10 	notrack jmp *-0x7fef8cec(,%eax,4)
80105250:	80 
    if(myproc()->killed)
80105251:	e8 1f e0 ff ff       	call   80103275 <myproc>
80105256:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010525a:	75 2b                	jne    80105287 <trap+0x62>
    myproc()->tf = tf;
8010525c:	e8 14 e0 ff ff       	call   80103275 <myproc>
80105261:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105264:	e8 82 ef ff ff       	call   801041eb <syscall>
    if(myproc()->killed)
80105269:	e8 07 e0 ff ff       	call   80103275 <myproc>
8010526e:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105272:	0f 84 8c 00 00 00    	je     80105304 <trap+0xdf>
      exit(0);
80105278:	83 ec 0c             	sub    $0xc,%esp
8010527b:	6a 00                	push   $0x0
8010527d:	e8 60 e4 ff ff       	call   801036e2 <exit>
80105282:	83 c4 10             	add    $0x10,%esp
    return;
80105285:	eb 7d                	jmp    80105304 <trap+0xdf>
      exit(0);
80105287:	83 ec 0c             	sub    $0xc,%esp
8010528a:	6a 00                	push   $0x0
8010528c:	e8 51 e4 ff ff       	call   801036e2 <exit>
80105291:	83 c4 10             	add    $0x10,%esp
80105294:	eb c6                	jmp    8010525c <trap+0x37>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105296:	e8 a5 df ff ff       	call   80103240 <cpuid>
8010529b:	85 c0                	test   %eax,%eax
8010529d:	74 6d                	je     8010530c <trap+0xe7>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
8010529f:	e8 48 d1 ff ff       	call   801023ec <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801052a4:	e8 cc df ff ff       	call   80103275 <myproc>
801052a9:	85 c0                	test   %eax,%eax
801052ab:	74 1b                	je     801052c8 <trap+0xa3>
801052ad:	e8 c3 df ff ff       	call   80103275 <myproc>
801052b2:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801052b6:	74 10                	je     801052c8 <trap+0xa3>
801052b8:	8b 43 3c             	mov    0x3c(%ebx),%eax
801052bb:	83 e0 03             	and    $0x3,%eax
801052be:	66 83 f8 03          	cmp    $0x3,%ax
801052c2:	0f 84 09 03 00 00    	je     801055d1 <trap+0x3ac>
    exit(tf->trapno+1);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801052c8:	e8 a8 df ff ff       	call   80103275 <myproc>
801052cd:	85 c0                	test   %eax,%eax
801052cf:	74 0f                	je     801052e0 <trap+0xbb>
801052d1:	e8 9f df ff ff       	call   80103275 <myproc>
801052d6:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801052da:	0f 84 06 03 00 00    	je     801055e6 <trap+0x3c1>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801052e0:	e8 90 df ff ff       	call   80103275 <myproc>
801052e5:	85 c0                	test   %eax,%eax
801052e7:	74 1b                	je     80105304 <trap+0xdf>
801052e9:	e8 87 df ff ff       	call   80103275 <myproc>
801052ee:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801052f2:	74 10                	je     80105304 <trap+0xdf>
801052f4:	8b 43 3c             	mov    0x3c(%ebx),%eax
801052f7:	83 e0 03             	and    $0x3,%eax
801052fa:	66 83 f8 03          	cmp    $0x3,%ax
801052fe:	0f 84 f6 02 00 00    	je     801055fa <trap+0x3d5>
    exit(tf->trapno+1);
}
80105304:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105307:	5b                   	pop    %ebx
80105308:	5e                   	pop    %esi
80105309:	5f                   	pop    %edi
8010530a:	5d                   	pop    %ebp
8010530b:	c3                   	ret    
      acquire(&tickslock);
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	68 60 4f 11 80       	push   $0x80114f60
80105314:	e8 f6 ea ff ff       	call   80103e0f <acquire>
      ticks++;
80105319:	ff 05 a0 57 11 80    	incl   0x801157a0
      wakeup(&ticks);
8010531f:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
80105326:	e8 49 e6 ff ff       	call   80103974 <wakeup>
      release(&tickslock);
8010532b:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105332:	e8 41 eb ff ff       	call   80103e78 <release>
80105337:	83 c4 10             	add    $0x10,%esp
8010533a:	e9 60 ff ff ff       	jmp    8010529f <trap+0x7a>
    ideintr();
8010533f:	e8 64 ca ff ff       	call   80101da8 <ideintr>
    lapiceoi();
80105344:	e8 a3 d0 ff ff       	call   801023ec <lapiceoi>
    break;
80105349:	e9 56 ff ff ff       	jmp    801052a4 <trap+0x7f>
    kbdintr();
8010534e:	e8 d6 ce ff ff       	call   80102229 <kbdintr>
    lapiceoi();
80105353:	e8 94 d0 ff ff       	call   801023ec <lapiceoi>
    break;
80105358:	e9 47 ff ff ff       	jmp    801052a4 <trap+0x7f>
    uartintr();
8010535d:	e8 b5 03 00 00       	call   80105717 <uartintr>
    lapiceoi();
80105362:	e8 85 d0 ff ff       	call   801023ec <lapiceoi>
    break;
80105367:	e9 38 ff ff ff       	jmp    801052a4 <trap+0x7f>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010536c:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
8010536f:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105372:	e8 c9 de ff ff       	call   80103240 <cpuid>
80105377:	57                   	push   %edi
80105378:	0f b7 f6             	movzwl %si,%esi
8010537b:	56                   	push   %esi
8010537c:	50                   	push   %eax
8010537d:	68 34 72 10 80       	push   $0x80107234
80105382:	e8 76 b2 ff ff       	call   801005fd <cprintf>
    lapiceoi();
80105387:	e8 60 d0 ff ff       	call   801023ec <lapiceoi>
    break;
8010538c:	83 c4 10             	add    $0x10,%esp
8010538f:	e9 10 ff ff ff       	jmp    801052a4 <trap+0x7f>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105394:	0f 20 d6             	mov    %cr2,%esi
    dirPageErr = PGROUNDDOWN(rcr2());
80105397:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
8010539d:	0f 20 d7             	mov    %cr2,%edi
    if(rcr2() >= myproc()->sz){ 
801053a0:	e8 d0 de ff ff       	call   80103275 <myproc>
801053a5:	39 38                	cmp    %edi,(%eax)
801053a7:	77 59                	ja     80105402 <trap+0x1dd>
801053a9:	0f 20 d7             	mov    %cr2,%edi
      cprintf("pid %d %s: trap %d err %d on cpu %d "
801053ac:	8b 43 38             	mov    0x38(%ebx),%eax
801053af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801053b2:	e8 89 de ff ff       	call   80103240 <cpuid>
801053b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801053ba:	8b 4b 34             	mov    0x34(%ebx),%ecx
801053bd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801053c0:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801053c3:	e8 ad de ff ff       	call   80103275 <myproc>
801053c8:	8d 50 6c             	lea    0x6c(%eax),%edx
801053cb:	89 55 d8             	mov    %edx,-0x28(%ebp)
801053ce:	e8 a2 de ff ff       	call   80103275 <myproc>
      cprintf("pid %d %s: trap %d err %d on cpu %d "
801053d3:	57                   	push   %edi
801053d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801053d7:	ff 75 e0             	pushl  -0x20(%ebp)
801053da:	ff 75 dc             	pushl  -0x24(%ebp)
801053dd:	56                   	push   %esi
801053de:	ff 75 d8             	pushl  -0x28(%ebp)
801053e1:	ff 70 10             	pushl  0x10(%eax)
801053e4:	68 58 72 10 80       	push   $0x80107258
801053e9:	e8 0f b2 ff ff       	call   801005fd <cprintf>
      myproc()->killed = 1;
801053ee:	83 c4 20             	add    $0x20,%esp
801053f1:	e8 7f de ff ff       	call   80103275 <myproc>
801053f6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
801053fd:	e9 a2 fe ff ff       	jmp    801052a4 <trap+0x7f>
    if (dirPageErr == myproc()->guard_page)
80105402:	e8 6e de ff ff       	call   80103275 <myproc>
80105407:	39 b0 80 00 00 00    	cmp    %esi,0x80(%eax)
8010540d:	0f 84 a5 00 00 00    	je     801054b8 <trap+0x293>
    if(myproc() == 0){
80105413:	e8 5d de ff ff       	call   80103275 <myproc>
80105418:	85 c0                	test   %eax,%eax
8010541a:	0f 84 a9 00 00 00    	je     801054c9 <trap+0x2a4>
    mem = kalloc();
80105420:	e8 e7 cc ff ff       	call   8010210c <kalloc>
80105425:	89 c7                	mov    %eax,%edi
    if(mem == 0){
80105427:	85 c0                	test   %eax,%eax
80105429:	0f 84 c5 00 00 00    	je     801054f4 <trap+0x2cf>
      memset(mem, 0, PGSIZE); //Inicializamos la página 0s para que no haya información residual
8010542f:	83 ec 04             	sub    $0x4,%esp
80105432:	68 00 10 00 00       	push   $0x1000
80105437:	6a 00                	push   $0x0
80105439:	50                   	push   %eax
8010543a:	e8 84 ea ff ff       	call   80103ec3 <memset>
      if(mappages(myproc()->pgdir, (char*)dirPageErr, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010543f:	e8 31 de ff ff       	call   80103275 <myproc>
80105444:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010544b:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80105451:	52                   	push   %edx
80105452:	68 00 10 00 00       	push   $0x1000
80105457:	56                   	push   %esi
80105458:	ff 70 04             	pushl  0x4(%eax)
8010545b:	e8 2c 0f 00 00       	call   8010638c <mappages>
80105460:	83 c4 20             	add    $0x20,%esp
80105463:	85 c0                	test   %eax,%eax
80105465:	0f 88 aa 00 00 00    	js     80105515 <trap+0x2f0>
8010546b:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010546e:	8b 43 38             	mov    0x38(%ebx),%eax
80105471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105474:	e8 c7 dd ff ff       	call   80103240 <cpuid>
80105479:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010547c:	8b 4b 34             	mov    0x34(%ebx),%ecx
8010547f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80105482:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105485:	e8 eb dd ff ff       	call   80103275 <myproc>
8010548a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010548d:	89 55 d8             	mov    %edx,-0x28(%ebp)
80105490:	e8 e0 dd ff ff       	call   80103275 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105495:	57                   	push   %edi
80105496:	ff 75 e4             	pushl  -0x1c(%ebp)
80105499:	ff 75 e0             	pushl  -0x20(%ebp)
8010549c:	ff 75 dc             	pushl  -0x24(%ebp)
8010549f:	56                   	push   %esi
801054a0:	ff 75 d8             	pushl  -0x28(%ebp)
801054a3:	ff 70 10             	pushl  0x10(%eax)
801054a6:	68 58 72 10 80       	push   $0x80107258
801054ab:	e8 4d b1 ff ff       	call   801005fd <cprintf>
    break;
801054b0:	83 c4 20             	add    $0x20,%esp
801054b3:	e9 ec fd ff ff       	jmp    801052a4 <trap+0x7f>
      myproc()->killed = 1;
801054b8:	e8 b8 dd ff ff       	call   80103275 <myproc>
801054bd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
801054c4:	e9 db fd ff ff       	jmp    801052a4 <trap+0x7f>
801054c9:	0f 20 d7             	mov    %cr2,%edi
        cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801054cc:	8b 73 38             	mov    0x38(%ebx),%esi
801054cf:	e8 6c dd ff ff       	call   80103240 <cpuid>
801054d4:	83 ec 0c             	sub    $0xc,%esp
801054d7:	57                   	push   %edi
801054d8:	56                   	push   %esi
801054d9:	50                   	push   %eax
801054da:	ff 73 30             	pushl  0x30(%ebx)
801054dd:	68 9c 72 10 80       	push   $0x8010729c
801054e2:	e8 16 b1 ff ff       	call   801005fd <cprintf>
      panic("trap");
801054e7:	83 c4 14             	add    $0x14,%esp
801054ea:	68 2e 72 10 80       	push   $0x8010722e
801054ef:	e8 61 ae ff ff       	call   80100355 <panic>
      cprintf("Out of memory (T_PGFLT) kalloc\n");
801054f4:	83 ec 0c             	sub    $0xc,%esp
801054f7:	68 d0 72 10 80       	push   $0x801072d0
801054fc:	e8 fc b0 ff ff       	call   801005fd <cprintf>
      myproc()->killed = 1;
80105501:	e8 6f dd ff ff       	call   80103275 <myproc>
80105506:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
8010550d:	83 c4 10             	add    $0x10,%esp
80105510:	e9 8f fd ff ff       	jmp    801052a4 <trap+0x7f>
        cprintf("Out of memory (T_PGFLT) mappages\n");
80105515:	83 ec 0c             	sub    $0xc,%esp
80105518:	68 f0 72 10 80       	push   $0x801072f0
8010551d:	e8 db b0 ff ff       	call   801005fd <cprintf>
        kfree(mem);
80105522:	89 3c 24             	mov    %edi,(%esp)
80105525:	e8 bb ca ff ff       	call   80101fe5 <kfree>
        myproc()->killed = 1;
8010552a:	e8 46 dd ff ff       	call   80103275 <myproc>
8010552f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        break;
80105536:	83 c4 10             	add    $0x10,%esp
80105539:	e9 66 fd ff ff       	jmp    801052a4 <trap+0x7f>
    if(myproc() == 0 || (tf->cs&3) == 0){
8010553e:	e8 32 dd ff ff       	call   80103275 <myproc>
80105543:	85 c0                	test   %eax,%eax
80105545:	74 5f                	je     801055a6 <trap+0x381>
80105547:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010554b:	74 59                	je     801055a6 <trap+0x381>
8010554d:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105550:	8b 43 38             	mov    0x38(%ebx),%eax
80105553:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105556:	e8 e5 dc ff ff       	call   80103240 <cpuid>
8010555b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010555e:	8b 4b 34             	mov    0x34(%ebx),%ecx
80105561:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80105564:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105567:	e8 09 dd ff ff       	call   80103275 <myproc>
8010556c:	8d 50 6c             	lea    0x6c(%eax),%edx
8010556f:	89 55 d8             	mov    %edx,-0x28(%ebp)
80105572:	e8 fe dc ff ff       	call   80103275 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105577:	57                   	push   %edi
80105578:	ff 75 e4             	pushl  -0x1c(%ebp)
8010557b:	ff 75 e0             	pushl  -0x20(%ebp)
8010557e:	ff 75 dc             	pushl  -0x24(%ebp)
80105581:	56                   	push   %esi
80105582:	ff 75 d8             	pushl  -0x28(%ebp)
80105585:	ff 70 10             	pushl  0x10(%eax)
80105588:	68 58 72 10 80       	push   $0x80107258
8010558d:	e8 6b b0 ff ff       	call   801005fd <cprintf>
    myproc()->killed = 1;
80105592:	83 c4 20             	add    $0x20,%esp
80105595:	e8 db dc ff ff       	call   80103275 <myproc>
8010559a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801055a1:	e9 fe fc ff ff       	jmp    801052a4 <trap+0x7f>
801055a6:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801055a9:	8b 73 38             	mov    0x38(%ebx),%esi
801055ac:	e8 8f dc ff ff       	call   80103240 <cpuid>
801055b1:	83 ec 0c             	sub    $0xc,%esp
801055b4:	57                   	push   %edi
801055b5:	56                   	push   %esi
801055b6:	50                   	push   %eax
801055b7:	ff 73 30             	pushl  0x30(%ebx)
801055ba:	68 9c 72 10 80       	push   $0x8010729c
801055bf:	e8 39 b0 ff ff       	call   801005fd <cprintf>
      panic("trap");
801055c4:	83 c4 14             	add    $0x14,%esp
801055c7:	68 2e 72 10 80       	push   $0x8010722e
801055cc:	e8 84 ad ff ff       	call   80100355 <panic>
    exit(tf->trapno+1);
801055d1:	8b 43 30             	mov    0x30(%ebx),%eax
801055d4:	40                   	inc    %eax
801055d5:	83 ec 0c             	sub    $0xc,%esp
801055d8:	50                   	push   %eax
801055d9:	e8 04 e1 ff ff       	call   801036e2 <exit>
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	e9 e2 fc ff ff       	jmp    801052c8 <trap+0xa3>
  if(myproc() && myproc()->state == RUNNING &&
801055e6:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801055ea:	0f 85 f0 fc ff ff    	jne    801052e0 <trap+0xbb>
    yield();
801055f0:	e8 cf e1 ff ff       	call   801037c4 <yield>
801055f5:	e9 e6 fc ff ff       	jmp    801052e0 <trap+0xbb>
    exit(tf->trapno+1);
801055fa:	8b 43 30             	mov    0x30(%ebx),%eax
801055fd:	40                   	inc    %eax
801055fe:	83 ec 0c             	sub    $0xc,%esp
80105601:	50                   	push   %eax
80105602:	e8 db e0 ff ff       	call   801036e2 <exit>
80105607:	83 c4 10             	add    $0x10,%esp
8010560a:	e9 f5 fc ff ff       	jmp    80105304 <trap+0xdf>

8010560f <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
8010560f:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105613:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
8010561a:	74 14                	je     80105630 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010561c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105621:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105622:	a8 01                	test   $0x1,%al
80105624:	74 10                	je     80105636 <uartgetc+0x27>
80105626:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010562b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010562c:	0f b6 c0             	movzbl %al,%eax
8010562f:	c3                   	ret    
    return -1;
80105630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105635:	c3                   	ret    
    return -1;
80105636:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010563b:	c3                   	ret    

8010563c <uartputc>:
{
8010563c:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105640:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
80105647:	74 39                	je     80105682 <uartputc+0x46>
{
80105649:	55                   	push   %ebp
8010564a:	89 e5                	mov    %esp,%ebp
8010564c:	53                   	push   %ebx
8010564d:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105650:	bb 00 00 00 00       	mov    $0x0,%ebx
80105655:	83 fb 7f             	cmp    $0x7f,%ebx
80105658:	7f 1a                	jg     80105674 <uartputc+0x38>
8010565a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010565f:	ec                   	in     (%dx),%al
80105660:	a8 20                	test   $0x20,%al
80105662:	75 10                	jne    80105674 <uartputc+0x38>
    microdelay(10);
80105664:	83 ec 0c             	sub    $0xc,%esp
80105667:	6a 0a                	push   $0xa
80105669:	e8 a3 cd ff ff       	call   80102411 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010566e:	43                   	inc    %ebx
8010566f:	83 c4 10             	add    $0x10,%esp
80105672:	eb e1                	jmp    80105655 <uartputc+0x19>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105674:	8b 45 08             	mov    0x8(%ebp),%eax
80105677:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010567c:	ee                   	out    %al,(%dx)
}
8010567d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105680:	c9                   	leave  
80105681:	c3                   	ret    
80105682:	c3                   	ret    

80105683 <uartinit>:
{
80105683:	f3 0f 1e fb          	endbr32 
80105687:	55                   	push   %ebp
80105688:	89 e5                	mov    %esp,%ebp
8010568a:	56                   	push   %esi
8010568b:	53                   	push   %ebx
8010568c:	b1 00                	mov    $0x0,%cl
8010568e:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105693:	88 c8                	mov    %cl,%al
80105695:	ee                   	out    %al,(%dx)
80105696:	be fb 03 00 00       	mov    $0x3fb,%esi
8010569b:	b0 80                	mov    $0x80,%al
8010569d:	89 f2                	mov    %esi,%edx
8010569f:	ee                   	out    %al,(%dx)
801056a0:	b0 0c                	mov    $0xc,%al
801056a2:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056a7:	ee                   	out    %al,(%dx)
801056a8:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801056ad:	88 c8                	mov    %cl,%al
801056af:	89 da                	mov    %ebx,%edx
801056b1:	ee                   	out    %al,(%dx)
801056b2:	b0 03                	mov    $0x3,%al
801056b4:	89 f2                	mov    %esi,%edx
801056b6:	ee                   	out    %al,(%dx)
801056b7:	ba fc 03 00 00       	mov    $0x3fc,%edx
801056bc:	88 c8                	mov    %cl,%al
801056be:	ee                   	out    %al,(%dx)
801056bf:	b0 01                	mov    $0x1,%al
801056c1:	89 da                	mov    %ebx,%edx
801056c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801056c4:	ba fd 03 00 00       	mov    $0x3fd,%edx
801056c9:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801056ca:	3c ff                	cmp    $0xff,%al
801056cc:	74 42                	je     80105710 <uartinit+0x8d>
  uart = 1;
801056ce:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801056d5:	00 00 00 
801056d8:	ba fa 03 00 00       	mov    $0x3fa,%edx
801056dd:	ec                   	in     (%dx),%al
801056de:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056e3:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	6a 00                	push   $0x0
801056e9:	6a 04                	push   $0x4
801056eb:	e8 c5 c8 ff ff       	call   80101fb5 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801056f0:	83 c4 10             	add    $0x10,%esp
801056f3:	bb dc 73 10 80       	mov    $0x801073dc,%ebx
801056f8:	eb 10                	jmp    8010570a <uartinit+0x87>
    uartputc(*p);
801056fa:	83 ec 0c             	sub    $0xc,%esp
801056fd:	0f be c0             	movsbl %al,%eax
80105700:	50                   	push   %eax
80105701:	e8 36 ff ff ff       	call   8010563c <uartputc>
  for(p="xv6...\n"; *p; p++)
80105706:	43                   	inc    %ebx
80105707:	83 c4 10             	add    $0x10,%esp
8010570a:	8a 03                	mov    (%ebx),%al
8010570c:	84 c0                	test   %al,%al
8010570e:	75 ea                	jne    801056fa <uartinit+0x77>
}
80105710:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105713:	5b                   	pop    %ebx
80105714:	5e                   	pop    %esi
80105715:	5d                   	pop    %ebp
80105716:	c3                   	ret    

80105717 <uartintr>:

void
uartintr(void)
{
80105717:	f3 0f 1e fb          	endbr32 
8010571b:	55                   	push   %ebp
8010571c:	89 e5                	mov    %esp,%ebp
8010571e:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105721:	68 0f 56 10 80       	push   $0x8010560f
80105726:	e8 fb af ff ff       	call   80100726 <consoleintr>
}
8010572b:	83 c4 10             	add    $0x10,%esp
8010572e:	c9                   	leave  
8010572f:	c3                   	ret    

80105730 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105730:	6a 00                	push   $0x0
  pushl $0
80105732:	6a 00                	push   $0x0
  jmp alltraps
80105734:	e9 f1 f9 ff ff       	jmp    8010512a <alltraps>

80105739 <vector1>:
.globl vector1
vector1:
  pushl $0
80105739:	6a 00                	push   $0x0
  pushl $1
8010573b:	6a 01                	push   $0x1
  jmp alltraps
8010573d:	e9 e8 f9 ff ff       	jmp    8010512a <alltraps>

80105742 <vector2>:
.globl vector2
vector2:
  pushl $0
80105742:	6a 00                	push   $0x0
  pushl $2
80105744:	6a 02                	push   $0x2
  jmp alltraps
80105746:	e9 df f9 ff ff       	jmp    8010512a <alltraps>

8010574b <vector3>:
.globl vector3
vector3:
  pushl $0
8010574b:	6a 00                	push   $0x0
  pushl $3
8010574d:	6a 03                	push   $0x3
  jmp alltraps
8010574f:	e9 d6 f9 ff ff       	jmp    8010512a <alltraps>

80105754 <vector4>:
.globl vector4
vector4:
  pushl $0
80105754:	6a 00                	push   $0x0
  pushl $4
80105756:	6a 04                	push   $0x4
  jmp alltraps
80105758:	e9 cd f9 ff ff       	jmp    8010512a <alltraps>

8010575d <vector5>:
.globl vector5
vector5:
  pushl $0
8010575d:	6a 00                	push   $0x0
  pushl $5
8010575f:	6a 05                	push   $0x5
  jmp alltraps
80105761:	e9 c4 f9 ff ff       	jmp    8010512a <alltraps>

80105766 <vector6>:
.globl vector6
vector6:
  pushl $0
80105766:	6a 00                	push   $0x0
  pushl $6
80105768:	6a 06                	push   $0x6
  jmp alltraps
8010576a:	e9 bb f9 ff ff       	jmp    8010512a <alltraps>

8010576f <vector7>:
.globl vector7
vector7:
  pushl $0
8010576f:	6a 00                	push   $0x0
  pushl $7
80105771:	6a 07                	push   $0x7
  jmp alltraps
80105773:	e9 b2 f9 ff ff       	jmp    8010512a <alltraps>

80105778 <vector8>:
.globl vector8
vector8:
  pushl $8
80105778:	6a 08                	push   $0x8
  jmp alltraps
8010577a:	e9 ab f9 ff ff       	jmp    8010512a <alltraps>

8010577f <vector9>:
.globl vector9
vector9:
  pushl $0
8010577f:	6a 00                	push   $0x0
  pushl $9
80105781:	6a 09                	push   $0x9
  jmp alltraps
80105783:	e9 a2 f9 ff ff       	jmp    8010512a <alltraps>

80105788 <vector10>:
.globl vector10
vector10:
  pushl $10
80105788:	6a 0a                	push   $0xa
  jmp alltraps
8010578a:	e9 9b f9 ff ff       	jmp    8010512a <alltraps>

8010578f <vector11>:
.globl vector11
vector11:
  pushl $11
8010578f:	6a 0b                	push   $0xb
  jmp alltraps
80105791:	e9 94 f9 ff ff       	jmp    8010512a <alltraps>

80105796 <vector12>:
.globl vector12
vector12:
  pushl $12
80105796:	6a 0c                	push   $0xc
  jmp alltraps
80105798:	e9 8d f9 ff ff       	jmp    8010512a <alltraps>

8010579d <vector13>:
.globl vector13
vector13:
  pushl $13
8010579d:	6a 0d                	push   $0xd
  jmp alltraps
8010579f:	e9 86 f9 ff ff       	jmp    8010512a <alltraps>

801057a4 <vector14>:
.globl vector14
vector14:
  pushl $14
801057a4:	6a 0e                	push   $0xe
  jmp alltraps
801057a6:	e9 7f f9 ff ff       	jmp    8010512a <alltraps>

801057ab <vector15>:
.globl vector15
vector15:
  pushl $0
801057ab:	6a 00                	push   $0x0
  pushl $15
801057ad:	6a 0f                	push   $0xf
  jmp alltraps
801057af:	e9 76 f9 ff ff       	jmp    8010512a <alltraps>

801057b4 <vector16>:
.globl vector16
vector16:
  pushl $0
801057b4:	6a 00                	push   $0x0
  pushl $16
801057b6:	6a 10                	push   $0x10
  jmp alltraps
801057b8:	e9 6d f9 ff ff       	jmp    8010512a <alltraps>

801057bd <vector17>:
.globl vector17
vector17:
  pushl $17
801057bd:	6a 11                	push   $0x11
  jmp alltraps
801057bf:	e9 66 f9 ff ff       	jmp    8010512a <alltraps>

801057c4 <vector18>:
.globl vector18
vector18:
  pushl $0
801057c4:	6a 00                	push   $0x0
  pushl $18
801057c6:	6a 12                	push   $0x12
  jmp alltraps
801057c8:	e9 5d f9 ff ff       	jmp    8010512a <alltraps>

801057cd <vector19>:
.globl vector19
vector19:
  pushl $0
801057cd:	6a 00                	push   $0x0
  pushl $19
801057cf:	6a 13                	push   $0x13
  jmp alltraps
801057d1:	e9 54 f9 ff ff       	jmp    8010512a <alltraps>

801057d6 <vector20>:
.globl vector20
vector20:
  pushl $0
801057d6:	6a 00                	push   $0x0
  pushl $20
801057d8:	6a 14                	push   $0x14
  jmp alltraps
801057da:	e9 4b f9 ff ff       	jmp    8010512a <alltraps>

801057df <vector21>:
.globl vector21
vector21:
  pushl $0
801057df:	6a 00                	push   $0x0
  pushl $21
801057e1:	6a 15                	push   $0x15
  jmp alltraps
801057e3:	e9 42 f9 ff ff       	jmp    8010512a <alltraps>

801057e8 <vector22>:
.globl vector22
vector22:
  pushl $0
801057e8:	6a 00                	push   $0x0
  pushl $22
801057ea:	6a 16                	push   $0x16
  jmp alltraps
801057ec:	e9 39 f9 ff ff       	jmp    8010512a <alltraps>

801057f1 <vector23>:
.globl vector23
vector23:
  pushl $0
801057f1:	6a 00                	push   $0x0
  pushl $23
801057f3:	6a 17                	push   $0x17
  jmp alltraps
801057f5:	e9 30 f9 ff ff       	jmp    8010512a <alltraps>

801057fa <vector24>:
.globl vector24
vector24:
  pushl $0
801057fa:	6a 00                	push   $0x0
  pushl $24
801057fc:	6a 18                	push   $0x18
  jmp alltraps
801057fe:	e9 27 f9 ff ff       	jmp    8010512a <alltraps>

80105803 <vector25>:
.globl vector25
vector25:
  pushl $0
80105803:	6a 00                	push   $0x0
  pushl $25
80105805:	6a 19                	push   $0x19
  jmp alltraps
80105807:	e9 1e f9 ff ff       	jmp    8010512a <alltraps>

8010580c <vector26>:
.globl vector26
vector26:
  pushl $0
8010580c:	6a 00                	push   $0x0
  pushl $26
8010580e:	6a 1a                	push   $0x1a
  jmp alltraps
80105810:	e9 15 f9 ff ff       	jmp    8010512a <alltraps>

80105815 <vector27>:
.globl vector27
vector27:
  pushl $0
80105815:	6a 00                	push   $0x0
  pushl $27
80105817:	6a 1b                	push   $0x1b
  jmp alltraps
80105819:	e9 0c f9 ff ff       	jmp    8010512a <alltraps>

8010581e <vector28>:
.globl vector28
vector28:
  pushl $0
8010581e:	6a 00                	push   $0x0
  pushl $28
80105820:	6a 1c                	push   $0x1c
  jmp alltraps
80105822:	e9 03 f9 ff ff       	jmp    8010512a <alltraps>

80105827 <vector29>:
.globl vector29
vector29:
  pushl $0
80105827:	6a 00                	push   $0x0
  pushl $29
80105829:	6a 1d                	push   $0x1d
  jmp alltraps
8010582b:	e9 fa f8 ff ff       	jmp    8010512a <alltraps>

80105830 <vector30>:
.globl vector30
vector30:
  pushl $0
80105830:	6a 00                	push   $0x0
  pushl $30
80105832:	6a 1e                	push   $0x1e
  jmp alltraps
80105834:	e9 f1 f8 ff ff       	jmp    8010512a <alltraps>

80105839 <vector31>:
.globl vector31
vector31:
  pushl $0
80105839:	6a 00                	push   $0x0
  pushl $31
8010583b:	6a 1f                	push   $0x1f
  jmp alltraps
8010583d:	e9 e8 f8 ff ff       	jmp    8010512a <alltraps>

80105842 <vector32>:
.globl vector32
vector32:
  pushl $0
80105842:	6a 00                	push   $0x0
  pushl $32
80105844:	6a 20                	push   $0x20
  jmp alltraps
80105846:	e9 df f8 ff ff       	jmp    8010512a <alltraps>

8010584b <vector33>:
.globl vector33
vector33:
  pushl $0
8010584b:	6a 00                	push   $0x0
  pushl $33
8010584d:	6a 21                	push   $0x21
  jmp alltraps
8010584f:	e9 d6 f8 ff ff       	jmp    8010512a <alltraps>

80105854 <vector34>:
.globl vector34
vector34:
  pushl $0
80105854:	6a 00                	push   $0x0
  pushl $34
80105856:	6a 22                	push   $0x22
  jmp alltraps
80105858:	e9 cd f8 ff ff       	jmp    8010512a <alltraps>

8010585d <vector35>:
.globl vector35
vector35:
  pushl $0
8010585d:	6a 00                	push   $0x0
  pushl $35
8010585f:	6a 23                	push   $0x23
  jmp alltraps
80105861:	e9 c4 f8 ff ff       	jmp    8010512a <alltraps>

80105866 <vector36>:
.globl vector36
vector36:
  pushl $0
80105866:	6a 00                	push   $0x0
  pushl $36
80105868:	6a 24                	push   $0x24
  jmp alltraps
8010586a:	e9 bb f8 ff ff       	jmp    8010512a <alltraps>

8010586f <vector37>:
.globl vector37
vector37:
  pushl $0
8010586f:	6a 00                	push   $0x0
  pushl $37
80105871:	6a 25                	push   $0x25
  jmp alltraps
80105873:	e9 b2 f8 ff ff       	jmp    8010512a <alltraps>

80105878 <vector38>:
.globl vector38
vector38:
  pushl $0
80105878:	6a 00                	push   $0x0
  pushl $38
8010587a:	6a 26                	push   $0x26
  jmp alltraps
8010587c:	e9 a9 f8 ff ff       	jmp    8010512a <alltraps>

80105881 <vector39>:
.globl vector39
vector39:
  pushl $0
80105881:	6a 00                	push   $0x0
  pushl $39
80105883:	6a 27                	push   $0x27
  jmp alltraps
80105885:	e9 a0 f8 ff ff       	jmp    8010512a <alltraps>

8010588a <vector40>:
.globl vector40
vector40:
  pushl $0
8010588a:	6a 00                	push   $0x0
  pushl $40
8010588c:	6a 28                	push   $0x28
  jmp alltraps
8010588e:	e9 97 f8 ff ff       	jmp    8010512a <alltraps>

80105893 <vector41>:
.globl vector41
vector41:
  pushl $0
80105893:	6a 00                	push   $0x0
  pushl $41
80105895:	6a 29                	push   $0x29
  jmp alltraps
80105897:	e9 8e f8 ff ff       	jmp    8010512a <alltraps>

8010589c <vector42>:
.globl vector42
vector42:
  pushl $0
8010589c:	6a 00                	push   $0x0
  pushl $42
8010589e:	6a 2a                	push   $0x2a
  jmp alltraps
801058a0:	e9 85 f8 ff ff       	jmp    8010512a <alltraps>

801058a5 <vector43>:
.globl vector43
vector43:
  pushl $0
801058a5:	6a 00                	push   $0x0
  pushl $43
801058a7:	6a 2b                	push   $0x2b
  jmp alltraps
801058a9:	e9 7c f8 ff ff       	jmp    8010512a <alltraps>

801058ae <vector44>:
.globl vector44
vector44:
  pushl $0
801058ae:	6a 00                	push   $0x0
  pushl $44
801058b0:	6a 2c                	push   $0x2c
  jmp alltraps
801058b2:	e9 73 f8 ff ff       	jmp    8010512a <alltraps>

801058b7 <vector45>:
.globl vector45
vector45:
  pushl $0
801058b7:	6a 00                	push   $0x0
  pushl $45
801058b9:	6a 2d                	push   $0x2d
  jmp alltraps
801058bb:	e9 6a f8 ff ff       	jmp    8010512a <alltraps>

801058c0 <vector46>:
.globl vector46
vector46:
  pushl $0
801058c0:	6a 00                	push   $0x0
  pushl $46
801058c2:	6a 2e                	push   $0x2e
  jmp alltraps
801058c4:	e9 61 f8 ff ff       	jmp    8010512a <alltraps>

801058c9 <vector47>:
.globl vector47
vector47:
  pushl $0
801058c9:	6a 00                	push   $0x0
  pushl $47
801058cb:	6a 2f                	push   $0x2f
  jmp alltraps
801058cd:	e9 58 f8 ff ff       	jmp    8010512a <alltraps>

801058d2 <vector48>:
.globl vector48
vector48:
  pushl $0
801058d2:	6a 00                	push   $0x0
  pushl $48
801058d4:	6a 30                	push   $0x30
  jmp alltraps
801058d6:	e9 4f f8 ff ff       	jmp    8010512a <alltraps>

801058db <vector49>:
.globl vector49
vector49:
  pushl $0
801058db:	6a 00                	push   $0x0
  pushl $49
801058dd:	6a 31                	push   $0x31
  jmp alltraps
801058df:	e9 46 f8 ff ff       	jmp    8010512a <alltraps>

801058e4 <vector50>:
.globl vector50
vector50:
  pushl $0
801058e4:	6a 00                	push   $0x0
  pushl $50
801058e6:	6a 32                	push   $0x32
  jmp alltraps
801058e8:	e9 3d f8 ff ff       	jmp    8010512a <alltraps>

801058ed <vector51>:
.globl vector51
vector51:
  pushl $0
801058ed:	6a 00                	push   $0x0
  pushl $51
801058ef:	6a 33                	push   $0x33
  jmp alltraps
801058f1:	e9 34 f8 ff ff       	jmp    8010512a <alltraps>

801058f6 <vector52>:
.globl vector52
vector52:
  pushl $0
801058f6:	6a 00                	push   $0x0
  pushl $52
801058f8:	6a 34                	push   $0x34
  jmp alltraps
801058fa:	e9 2b f8 ff ff       	jmp    8010512a <alltraps>

801058ff <vector53>:
.globl vector53
vector53:
  pushl $0
801058ff:	6a 00                	push   $0x0
  pushl $53
80105901:	6a 35                	push   $0x35
  jmp alltraps
80105903:	e9 22 f8 ff ff       	jmp    8010512a <alltraps>

80105908 <vector54>:
.globl vector54
vector54:
  pushl $0
80105908:	6a 00                	push   $0x0
  pushl $54
8010590a:	6a 36                	push   $0x36
  jmp alltraps
8010590c:	e9 19 f8 ff ff       	jmp    8010512a <alltraps>

80105911 <vector55>:
.globl vector55
vector55:
  pushl $0
80105911:	6a 00                	push   $0x0
  pushl $55
80105913:	6a 37                	push   $0x37
  jmp alltraps
80105915:	e9 10 f8 ff ff       	jmp    8010512a <alltraps>

8010591a <vector56>:
.globl vector56
vector56:
  pushl $0
8010591a:	6a 00                	push   $0x0
  pushl $56
8010591c:	6a 38                	push   $0x38
  jmp alltraps
8010591e:	e9 07 f8 ff ff       	jmp    8010512a <alltraps>

80105923 <vector57>:
.globl vector57
vector57:
  pushl $0
80105923:	6a 00                	push   $0x0
  pushl $57
80105925:	6a 39                	push   $0x39
  jmp alltraps
80105927:	e9 fe f7 ff ff       	jmp    8010512a <alltraps>

8010592c <vector58>:
.globl vector58
vector58:
  pushl $0
8010592c:	6a 00                	push   $0x0
  pushl $58
8010592e:	6a 3a                	push   $0x3a
  jmp alltraps
80105930:	e9 f5 f7 ff ff       	jmp    8010512a <alltraps>

80105935 <vector59>:
.globl vector59
vector59:
  pushl $0
80105935:	6a 00                	push   $0x0
  pushl $59
80105937:	6a 3b                	push   $0x3b
  jmp alltraps
80105939:	e9 ec f7 ff ff       	jmp    8010512a <alltraps>

8010593e <vector60>:
.globl vector60
vector60:
  pushl $0
8010593e:	6a 00                	push   $0x0
  pushl $60
80105940:	6a 3c                	push   $0x3c
  jmp alltraps
80105942:	e9 e3 f7 ff ff       	jmp    8010512a <alltraps>

80105947 <vector61>:
.globl vector61
vector61:
  pushl $0
80105947:	6a 00                	push   $0x0
  pushl $61
80105949:	6a 3d                	push   $0x3d
  jmp alltraps
8010594b:	e9 da f7 ff ff       	jmp    8010512a <alltraps>

80105950 <vector62>:
.globl vector62
vector62:
  pushl $0
80105950:	6a 00                	push   $0x0
  pushl $62
80105952:	6a 3e                	push   $0x3e
  jmp alltraps
80105954:	e9 d1 f7 ff ff       	jmp    8010512a <alltraps>

80105959 <vector63>:
.globl vector63
vector63:
  pushl $0
80105959:	6a 00                	push   $0x0
  pushl $63
8010595b:	6a 3f                	push   $0x3f
  jmp alltraps
8010595d:	e9 c8 f7 ff ff       	jmp    8010512a <alltraps>

80105962 <vector64>:
.globl vector64
vector64:
  pushl $0
80105962:	6a 00                	push   $0x0
  pushl $64
80105964:	6a 40                	push   $0x40
  jmp alltraps
80105966:	e9 bf f7 ff ff       	jmp    8010512a <alltraps>

8010596b <vector65>:
.globl vector65
vector65:
  pushl $0
8010596b:	6a 00                	push   $0x0
  pushl $65
8010596d:	6a 41                	push   $0x41
  jmp alltraps
8010596f:	e9 b6 f7 ff ff       	jmp    8010512a <alltraps>

80105974 <vector66>:
.globl vector66
vector66:
  pushl $0
80105974:	6a 00                	push   $0x0
  pushl $66
80105976:	6a 42                	push   $0x42
  jmp alltraps
80105978:	e9 ad f7 ff ff       	jmp    8010512a <alltraps>

8010597d <vector67>:
.globl vector67
vector67:
  pushl $0
8010597d:	6a 00                	push   $0x0
  pushl $67
8010597f:	6a 43                	push   $0x43
  jmp alltraps
80105981:	e9 a4 f7 ff ff       	jmp    8010512a <alltraps>

80105986 <vector68>:
.globl vector68
vector68:
  pushl $0
80105986:	6a 00                	push   $0x0
  pushl $68
80105988:	6a 44                	push   $0x44
  jmp alltraps
8010598a:	e9 9b f7 ff ff       	jmp    8010512a <alltraps>

8010598f <vector69>:
.globl vector69
vector69:
  pushl $0
8010598f:	6a 00                	push   $0x0
  pushl $69
80105991:	6a 45                	push   $0x45
  jmp alltraps
80105993:	e9 92 f7 ff ff       	jmp    8010512a <alltraps>

80105998 <vector70>:
.globl vector70
vector70:
  pushl $0
80105998:	6a 00                	push   $0x0
  pushl $70
8010599a:	6a 46                	push   $0x46
  jmp alltraps
8010599c:	e9 89 f7 ff ff       	jmp    8010512a <alltraps>

801059a1 <vector71>:
.globl vector71
vector71:
  pushl $0
801059a1:	6a 00                	push   $0x0
  pushl $71
801059a3:	6a 47                	push   $0x47
  jmp alltraps
801059a5:	e9 80 f7 ff ff       	jmp    8010512a <alltraps>

801059aa <vector72>:
.globl vector72
vector72:
  pushl $0
801059aa:	6a 00                	push   $0x0
  pushl $72
801059ac:	6a 48                	push   $0x48
  jmp alltraps
801059ae:	e9 77 f7 ff ff       	jmp    8010512a <alltraps>

801059b3 <vector73>:
.globl vector73
vector73:
  pushl $0
801059b3:	6a 00                	push   $0x0
  pushl $73
801059b5:	6a 49                	push   $0x49
  jmp alltraps
801059b7:	e9 6e f7 ff ff       	jmp    8010512a <alltraps>

801059bc <vector74>:
.globl vector74
vector74:
  pushl $0
801059bc:	6a 00                	push   $0x0
  pushl $74
801059be:	6a 4a                	push   $0x4a
  jmp alltraps
801059c0:	e9 65 f7 ff ff       	jmp    8010512a <alltraps>

801059c5 <vector75>:
.globl vector75
vector75:
  pushl $0
801059c5:	6a 00                	push   $0x0
  pushl $75
801059c7:	6a 4b                	push   $0x4b
  jmp alltraps
801059c9:	e9 5c f7 ff ff       	jmp    8010512a <alltraps>

801059ce <vector76>:
.globl vector76
vector76:
  pushl $0
801059ce:	6a 00                	push   $0x0
  pushl $76
801059d0:	6a 4c                	push   $0x4c
  jmp alltraps
801059d2:	e9 53 f7 ff ff       	jmp    8010512a <alltraps>

801059d7 <vector77>:
.globl vector77
vector77:
  pushl $0
801059d7:	6a 00                	push   $0x0
  pushl $77
801059d9:	6a 4d                	push   $0x4d
  jmp alltraps
801059db:	e9 4a f7 ff ff       	jmp    8010512a <alltraps>

801059e0 <vector78>:
.globl vector78
vector78:
  pushl $0
801059e0:	6a 00                	push   $0x0
  pushl $78
801059e2:	6a 4e                	push   $0x4e
  jmp alltraps
801059e4:	e9 41 f7 ff ff       	jmp    8010512a <alltraps>

801059e9 <vector79>:
.globl vector79
vector79:
  pushl $0
801059e9:	6a 00                	push   $0x0
  pushl $79
801059eb:	6a 4f                	push   $0x4f
  jmp alltraps
801059ed:	e9 38 f7 ff ff       	jmp    8010512a <alltraps>

801059f2 <vector80>:
.globl vector80
vector80:
  pushl $0
801059f2:	6a 00                	push   $0x0
  pushl $80
801059f4:	6a 50                	push   $0x50
  jmp alltraps
801059f6:	e9 2f f7 ff ff       	jmp    8010512a <alltraps>

801059fb <vector81>:
.globl vector81
vector81:
  pushl $0
801059fb:	6a 00                	push   $0x0
  pushl $81
801059fd:	6a 51                	push   $0x51
  jmp alltraps
801059ff:	e9 26 f7 ff ff       	jmp    8010512a <alltraps>

80105a04 <vector82>:
.globl vector82
vector82:
  pushl $0
80105a04:	6a 00                	push   $0x0
  pushl $82
80105a06:	6a 52                	push   $0x52
  jmp alltraps
80105a08:	e9 1d f7 ff ff       	jmp    8010512a <alltraps>

80105a0d <vector83>:
.globl vector83
vector83:
  pushl $0
80105a0d:	6a 00                	push   $0x0
  pushl $83
80105a0f:	6a 53                	push   $0x53
  jmp alltraps
80105a11:	e9 14 f7 ff ff       	jmp    8010512a <alltraps>

80105a16 <vector84>:
.globl vector84
vector84:
  pushl $0
80105a16:	6a 00                	push   $0x0
  pushl $84
80105a18:	6a 54                	push   $0x54
  jmp alltraps
80105a1a:	e9 0b f7 ff ff       	jmp    8010512a <alltraps>

80105a1f <vector85>:
.globl vector85
vector85:
  pushl $0
80105a1f:	6a 00                	push   $0x0
  pushl $85
80105a21:	6a 55                	push   $0x55
  jmp alltraps
80105a23:	e9 02 f7 ff ff       	jmp    8010512a <alltraps>

80105a28 <vector86>:
.globl vector86
vector86:
  pushl $0
80105a28:	6a 00                	push   $0x0
  pushl $86
80105a2a:	6a 56                	push   $0x56
  jmp alltraps
80105a2c:	e9 f9 f6 ff ff       	jmp    8010512a <alltraps>

80105a31 <vector87>:
.globl vector87
vector87:
  pushl $0
80105a31:	6a 00                	push   $0x0
  pushl $87
80105a33:	6a 57                	push   $0x57
  jmp alltraps
80105a35:	e9 f0 f6 ff ff       	jmp    8010512a <alltraps>

80105a3a <vector88>:
.globl vector88
vector88:
  pushl $0
80105a3a:	6a 00                	push   $0x0
  pushl $88
80105a3c:	6a 58                	push   $0x58
  jmp alltraps
80105a3e:	e9 e7 f6 ff ff       	jmp    8010512a <alltraps>

80105a43 <vector89>:
.globl vector89
vector89:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $89
80105a45:	6a 59                	push   $0x59
  jmp alltraps
80105a47:	e9 de f6 ff ff       	jmp    8010512a <alltraps>

80105a4c <vector90>:
.globl vector90
vector90:
  pushl $0
80105a4c:	6a 00                	push   $0x0
  pushl $90
80105a4e:	6a 5a                	push   $0x5a
  jmp alltraps
80105a50:	e9 d5 f6 ff ff       	jmp    8010512a <alltraps>

80105a55 <vector91>:
.globl vector91
vector91:
  pushl $0
80105a55:	6a 00                	push   $0x0
  pushl $91
80105a57:	6a 5b                	push   $0x5b
  jmp alltraps
80105a59:	e9 cc f6 ff ff       	jmp    8010512a <alltraps>

80105a5e <vector92>:
.globl vector92
vector92:
  pushl $0
80105a5e:	6a 00                	push   $0x0
  pushl $92
80105a60:	6a 5c                	push   $0x5c
  jmp alltraps
80105a62:	e9 c3 f6 ff ff       	jmp    8010512a <alltraps>

80105a67 <vector93>:
.globl vector93
vector93:
  pushl $0
80105a67:	6a 00                	push   $0x0
  pushl $93
80105a69:	6a 5d                	push   $0x5d
  jmp alltraps
80105a6b:	e9 ba f6 ff ff       	jmp    8010512a <alltraps>

80105a70 <vector94>:
.globl vector94
vector94:
  pushl $0
80105a70:	6a 00                	push   $0x0
  pushl $94
80105a72:	6a 5e                	push   $0x5e
  jmp alltraps
80105a74:	e9 b1 f6 ff ff       	jmp    8010512a <alltraps>

80105a79 <vector95>:
.globl vector95
vector95:
  pushl $0
80105a79:	6a 00                	push   $0x0
  pushl $95
80105a7b:	6a 5f                	push   $0x5f
  jmp alltraps
80105a7d:	e9 a8 f6 ff ff       	jmp    8010512a <alltraps>

80105a82 <vector96>:
.globl vector96
vector96:
  pushl $0
80105a82:	6a 00                	push   $0x0
  pushl $96
80105a84:	6a 60                	push   $0x60
  jmp alltraps
80105a86:	e9 9f f6 ff ff       	jmp    8010512a <alltraps>

80105a8b <vector97>:
.globl vector97
vector97:
  pushl $0
80105a8b:	6a 00                	push   $0x0
  pushl $97
80105a8d:	6a 61                	push   $0x61
  jmp alltraps
80105a8f:	e9 96 f6 ff ff       	jmp    8010512a <alltraps>

80105a94 <vector98>:
.globl vector98
vector98:
  pushl $0
80105a94:	6a 00                	push   $0x0
  pushl $98
80105a96:	6a 62                	push   $0x62
  jmp alltraps
80105a98:	e9 8d f6 ff ff       	jmp    8010512a <alltraps>

80105a9d <vector99>:
.globl vector99
vector99:
  pushl $0
80105a9d:	6a 00                	push   $0x0
  pushl $99
80105a9f:	6a 63                	push   $0x63
  jmp alltraps
80105aa1:	e9 84 f6 ff ff       	jmp    8010512a <alltraps>

80105aa6 <vector100>:
.globl vector100
vector100:
  pushl $0
80105aa6:	6a 00                	push   $0x0
  pushl $100
80105aa8:	6a 64                	push   $0x64
  jmp alltraps
80105aaa:	e9 7b f6 ff ff       	jmp    8010512a <alltraps>

80105aaf <vector101>:
.globl vector101
vector101:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $101
80105ab1:	6a 65                	push   $0x65
  jmp alltraps
80105ab3:	e9 72 f6 ff ff       	jmp    8010512a <alltraps>

80105ab8 <vector102>:
.globl vector102
vector102:
  pushl $0
80105ab8:	6a 00                	push   $0x0
  pushl $102
80105aba:	6a 66                	push   $0x66
  jmp alltraps
80105abc:	e9 69 f6 ff ff       	jmp    8010512a <alltraps>

80105ac1 <vector103>:
.globl vector103
vector103:
  pushl $0
80105ac1:	6a 00                	push   $0x0
  pushl $103
80105ac3:	6a 67                	push   $0x67
  jmp alltraps
80105ac5:	e9 60 f6 ff ff       	jmp    8010512a <alltraps>

80105aca <vector104>:
.globl vector104
vector104:
  pushl $0
80105aca:	6a 00                	push   $0x0
  pushl $104
80105acc:	6a 68                	push   $0x68
  jmp alltraps
80105ace:	e9 57 f6 ff ff       	jmp    8010512a <alltraps>

80105ad3 <vector105>:
.globl vector105
vector105:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $105
80105ad5:	6a 69                	push   $0x69
  jmp alltraps
80105ad7:	e9 4e f6 ff ff       	jmp    8010512a <alltraps>

80105adc <vector106>:
.globl vector106
vector106:
  pushl $0
80105adc:	6a 00                	push   $0x0
  pushl $106
80105ade:	6a 6a                	push   $0x6a
  jmp alltraps
80105ae0:	e9 45 f6 ff ff       	jmp    8010512a <alltraps>

80105ae5 <vector107>:
.globl vector107
vector107:
  pushl $0
80105ae5:	6a 00                	push   $0x0
  pushl $107
80105ae7:	6a 6b                	push   $0x6b
  jmp alltraps
80105ae9:	e9 3c f6 ff ff       	jmp    8010512a <alltraps>

80105aee <vector108>:
.globl vector108
vector108:
  pushl $0
80105aee:	6a 00                	push   $0x0
  pushl $108
80105af0:	6a 6c                	push   $0x6c
  jmp alltraps
80105af2:	e9 33 f6 ff ff       	jmp    8010512a <alltraps>

80105af7 <vector109>:
.globl vector109
vector109:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $109
80105af9:	6a 6d                	push   $0x6d
  jmp alltraps
80105afb:	e9 2a f6 ff ff       	jmp    8010512a <alltraps>

80105b00 <vector110>:
.globl vector110
vector110:
  pushl $0
80105b00:	6a 00                	push   $0x0
  pushl $110
80105b02:	6a 6e                	push   $0x6e
  jmp alltraps
80105b04:	e9 21 f6 ff ff       	jmp    8010512a <alltraps>

80105b09 <vector111>:
.globl vector111
vector111:
  pushl $0
80105b09:	6a 00                	push   $0x0
  pushl $111
80105b0b:	6a 6f                	push   $0x6f
  jmp alltraps
80105b0d:	e9 18 f6 ff ff       	jmp    8010512a <alltraps>

80105b12 <vector112>:
.globl vector112
vector112:
  pushl $0
80105b12:	6a 00                	push   $0x0
  pushl $112
80105b14:	6a 70                	push   $0x70
  jmp alltraps
80105b16:	e9 0f f6 ff ff       	jmp    8010512a <alltraps>

80105b1b <vector113>:
.globl vector113
vector113:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $113
80105b1d:	6a 71                	push   $0x71
  jmp alltraps
80105b1f:	e9 06 f6 ff ff       	jmp    8010512a <alltraps>

80105b24 <vector114>:
.globl vector114
vector114:
  pushl $0
80105b24:	6a 00                	push   $0x0
  pushl $114
80105b26:	6a 72                	push   $0x72
  jmp alltraps
80105b28:	e9 fd f5 ff ff       	jmp    8010512a <alltraps>

80105b2d <vector115>:
.globl vector115
vector115:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $115
80105b2f:	6a 73                	push   $0x73
  jmp alltraps
80105b31:	e9 f4 f5 ff ff       	jmp    8010512a <alltraps>

80105b36 <vector116>:
.globl vector116
vector116:
  pushl $0
80105b36:	6a 00                	push   $0x0
  pushl $116
80105b38:	6a 74                	push   $0x74
  jmp alltraps
80105b3a:	e9 eb f5 ff ff       	jmp    8010512a <alltraps>

80105b3f <vector117>:
.globl vector117
vector117:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $117
80105b41:	6a 75                	push   $0x75
  jmp alltraps
80105b43:	e9 e2 f5 ff ff       	jmp    8010512a <alltraps>

80105b48 <vector118>:
.globl vector118
vector118:
  pushl $0
80105b48:	6a 00                	push   $0x0
  pushl $118
80105b4a:	6a 76                	push   $0x76
  jmp alltraps
80105b4c:	e9 d9 f5 ff ff       	jmp    8010512a <alltraps>

80105b51 <vector119>:
.globl vector119
vector119:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $119
80105b53:	6a 77                	push   $0x77
  jmp alltraps
80105b55:	e9 d0 f5 ff ff       	jmp    8010512a <alltraps>

80105b5a <vector120>:
.globl vector120
vector120:
  pushl $0
80105b5a:	6a 00                	push   $0x0
  pushl $120
80105b5c:	6a 78                	push   $0x78
  jmp alltraps
80105b5e:	e9 c7 f5 ff ff       	jmp    8010512a <alltraps>

80105b63 <vector121>:
.globl vector121
vector121:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $121
80105b65:	6a 79                	push   $0x79
  jmp alltraps
80105b67:	e9 be f5 ff ff       	jmp    8010512a <alltraps>

80105b6c <vector122>:
.globl vector122
vector122:
  pushl $0
80105b6c:	6a 00                	push   $0x0
  pushl $122
80105b6e:	6a 7a                	push   $0x7a
  jmp alltraps
80105b70:	e9 b5 f5 ff ff       	jmp    8010512a <alltraps>

80105b75 <vector123>:
.globl vector123
vector123:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $123
80105b77:	6a 7b                	push   $0x7b
  jmp alltraps
80105b79:	e9 ac f5 ff ff       	jmp    8010512a <alltraps>

80105b7e <vector124>:
.globl vector124
vector124:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $124
80105b80:	6a 7c                	push   $0x7c
  jmp alltraps
80105b82:	e9 a3 f5 ff ff       	jmp    8010512a <alltraps>

80105b87 <vector125>:
.globl vector125
vector125:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $125
80105b89:	6a 7d                	push   $0x7d
  jmp alltraps
80105b8b:	e9 9a f5 ff ff       	jmp    8010512a <alltraps>

80105b90 <vector126>:
.globl vector126
vector126:
  pushl $0
80105b90:	6a 00                	push   $0x0
  pushl $126
80105b92:	6a 7e                	push   $0x7e
  jmp alltraps
80105b94:	e9 91 f5 ff ff       	jmp    8010512a <alltraps>

80105b99 <vector127>:
.globl vector127
vector127:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $127
80105b9b:	6a 7f                	push   $0x7f
  jmp alltraps
80105b9d:	e9 88 f5 ff ff       	jmp    8010512a <alltraps>

80105ba2 <vector128>:
.globl vector128
vector128:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $128
80105ba4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105ba9:	e9 7c f5 ff ff       	jmp    8010512a <alltraps>

80105bae <vector129>:
.globl vector129
vector129:
  pushl $0
80105bae:	6a 00                	push   $0x0
  pushl $129
80105bb0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105bb5:	e9 70 f5 ff ff       	jmp    8010512a <alltraps>

80105bba <vector130>:
.globl vector130
vector130:
  pushl $0
80105bba:	6a 00                	push   $0x0
  pushl $130
80105bbc:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105bc1:	e9 64 f5 ff ff       	jmp    8010512a <alltraps>

80105bc6 <vector131>:
.globl vector131
vector131:
  pushl $0
80105bc6:	6a 00                	push   $0x0
  pushl $131
80105bc8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105bcd:	e9 58 f5 ff ff       	jmp    8010512a <alltraps>

80105bd2 <vector132>:
.globl vector132
vector132:
  pushl $0
80105bd2:	6a 00                	push   $0x0
  pushl $132
80105bd4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105bd9:	e9 4c f5 ff ff       	jmp    8010512a <alltraps>

80105bde <vector133>:
.globl vector133
vector133:
  pushl $0
80105bde:	6a 00                	push   $0x0
  pushl $133
80105be0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105be5:	e9 40 f5 ff ff       	jmp    8010512a <alltraps>

80105bea <vector134>:
.globl vector134
vector134:
  pushl $0
80105bea:	6a 00                	push   $0x0
  pushl $134
80105bec:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105bf1:	e9 34 f5 ff ff       	jmp    8010512a <alltraps>

80105bf6 <vector135>:
.globl vector135
vector135:
  pushl $0
80105bf6:	6a 00                	push   $0x0
  pushl $135
80105bf8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105bfd:	e9 28 f5 ff ff       	jmp    8010512a <alltraps>

80105c02 <vector136>:
.globl vector136
vector136:
  pushl $0
80105c02:	6a 00                	push   $0x0
  pushl $136
80105c04:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105c09:	e9 1c f5 ff ff       	jmp    8010512a <alltraps>

80105c0e <vector137>:
.globl vector137
vector137:
  pushl $0
80105c0e:	6a 00                	push   $0x0
  pushl $137
80105c10:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105c15:	e9 10 f5 ff ff       	jmp    8010512a <alltraps>

80105c1a <vector138>:
.globl vector138
vector138:
  pushl $0
80105c1a:	6a 00                	push   $0x0
  pushl $138
80105c1c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105c21:	e9 04 f5 ff ff       	jmp    8010512a <alltraps>

80105c26 <vector139>:
.globl vector139
vector139:
  pushl $0
80105c26:	6a 00                	push   $0x0
  pushl $139
80105c28:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105c2d:	e9 f8 f4 ff ff       	jmp    8010512a <alltraps>

80105c32 <vector140>:
.globl vector140
vector140:
  pushl $0
80105c32:	6a 00                	push   $0x0
  pushl $140
80105c34:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105c39:	e9 ec f4 ff ff       	jmp    8010512a <alltraps>

80105c3e <vector141>:
.globl vector141
vector141:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $141
80105c40:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105c45:	e9 e0 f4 ff ff       	jmp    8010512a <alltraps>

80105c4a <vector142>:
.globl vector142
vector142:
  pushl $0
80105c4a:	6a 00                	push   $0x0
  pushl $142
80105c4c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105c51:	e9 d4 f4 ff ff       	jmp    8010512a <alltraps>

80105c56 <vector143>:
.globl vector143
vector143:
  pushl $0
80105c56:	6a 00                	push   $0x0
  pushl $143
80105c58:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105c5d:	e9 c8 f4 ff ff       	jmp    8010512a <alltraps>

80105c62 <vector144>:
.globl vector144
vector144:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $144
80105c64:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105c69:	e9 bc f4 ff ff       	jmp    8010512a <alltraps>

80105c6e <vector145>:
.globl vector145
vector145:
  pushl $0
80105c6e:	6a 00                	push   $0x0
  pushl $145
80105c70:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105c75:	e9 b0 f4 ff ff       	jmp    8010512a <alltraps>

80105c7a <vector146>:
.globl vector146
vector146:
  pushl $0
80105c7a:	6a 00                	push   $0x0
  pushl $146
80105c7c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105c81:	e9 a4 f4 ff ff       	jmp    8010512a <alltraps>

80105c86 <vector147>:
.globl vector147
vector147:
  pushl $0
80105c86:	6a 00                	push   $0x0
  pushl $147
80105c88:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105c8d:	e9 98 f4 ff ff       	jmp    8010512a <alltraps>

80105c92 <vector148>:
.globl vector148
vector148:
  pushl $0
80105c92:	6a 00                	push   $0x0
  pushl $148
80105c94:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105c99:	e9 8c f4 ff ff       	jmp    8010512a <alltraps>

80105c9e <vector149>:
.globl vector149
vector149:
  pushl $0
80105c9e:	6a 00                	push   $0x0
  pushl $149
80105ca0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105ca5:	e9 80 f4 ff ff       	jmp    8010512a <alltraps>

80105caa <vector150>:
.globl vector150
vector150:
  pushl $0
80105caa:	6a 00                	push   $0x0
  pushl $150
80105cac:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105cb1:	e9 74 f4 ff ff       	jmp    8010512a <alltraps>

80105cb6 <vector151>:
.globl vector151
vector151:
  pushl $0
80105cb6:	6a 00                	push   $0x0
  pushl $151
80105cb8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105cbd:	e9 68 f4 ff ff       	jmp    8010512a <alltraps>

80105cc2 <vector152>:
.globl vector152
vector152:
  pushl $0
80105cc2:	6a 00                	push   $0x0
  pushl $152
80105cc4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105cc9:	e9 5c f4 ff ff       	jmp    8010512a <alltraps>

80105cce <vector153>:
.globl vector153
vector153:
  pushl $0
80105cce:	6a 00                	push   $0x0
  pushl $153
80105cd0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105cd5:	e9 50 f4 ff ff       	jmp    8010512a <alltraps>

80105cda <vector154>:
.globl vector154
vector154:
  pushl $0
80105cda:	6a 00                	push   $0x0
  pushl $154
80105cdc:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105ce1:	e9 44 f4 ff ff       	jmp    8010512a <alltraps>

80105ce6 <vector155>:
.globl vector155
vector155:
  pushl $0
80105ce6:	6a 00                	push   $0x0
  pushl $155
80105ce8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105ced:	e9 38 f4 ff ff       	jmp    8010512a <alltraps>

80105cf2 <vector156>:
.globl vector156
vector156:
  pushl $0
80105cf2:	6a 00                	push   $0x0
  pushl $156
80105cf4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105cf9:	e9 2c f4 ff ff       	jmp    8010512a <alltraps>

80105cfe <vector157>:
.globl vector157
vector157:
  pushl $0
80105cfe:	6a 00                	push   $0x0
  pushl $157
80105d00:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105d05:	e9 20 f4 ff ff       	jmp    8010512a <alltraps>

80105d0a <vector158>:
.globl vector158
vector158:
  pushl $0
80105d0a:	6a 00                	push   $0x0
  pushl $158
80105d0c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105d11:	e9 14 f4 ff ff       	jmp    8010512a <alltraps>

80105d16 <vector159>:
.globl vector159
vector159:
  pushl $0
80105d16:	6a 00                	push   $0x0
  pushl $159
80105d18:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105d1d:	e9 08 f4 ff ff       	jmp    8010512a <alltraps>

80105d22 <vector160>:
.globl vector160
vector160:
  pushl $0
80105d22:	6a 00                	push   $0x0
  pushl $160
80105d24:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105d29:	e9 fc f3 ff ff       	jmp    8010512a <alltraps>

80105d2e <vector161>:
.globl vector161
vector161:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $161
80105d30:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105d35:	e9 f0 f3 ff ff       	jmp    8010512a <alltraps>

80105d3a <vector162>:
.globl vector162
vector162:
  pushl $0
80105d3a:	6a 00                	push   $0x0
  pushl $162
80105d3c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105d41:	e9 e4 f3 ff ff       	jmp    8010512a <alltraps>

80105d46 <vector163>:
.globl vector163
vector163:
  pushl $0
80105d46:	6a 00                	push   $0x0
  pushl $163
80105d48:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105d4d:	e9 d8 f3 ff ff       	jmp    8010512a <alltraps>

80105d52 <vector164>:
.globl vector164
vector164:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $164
80105d54:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105d59:	e9 cc f3 ff ff       	jmp    8010512a <alltraps>

80105d5e <vector165>:
.globl vector165
vector165:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $165
80105d60:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105d65:	e9 c0 f3 ff ff       	jmp    8010512a <alltraps>

80105d6a <vector166>:
.globl vector166
vector166:
  pushl $0
80105d6a:	6a 00                	push   $0x0
  pushl $166
80105d6c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105d71:	e9 b4 f3 ff ff       	jmp    8010512a <alltraps>

80105d76 <vector167>:
.globl vector167
vector167:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $167
80105d78:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105d7d:	e9 a8 f3 ff ff       	jmp    8010512a <alltraps>

80105d82 <vector168>:
.globl vector168
vector168:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $168
80105d84:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105d89:	e9 9c f3 ff ff       	jmp    8010512a <alltraps>

80105d8e <vector169>:
.globl vector169
vector169:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $169
80105d90:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105d95:	e9 90 f3 ff ff       	jmp    8010512a <alltraps>

80105d9a <vector170>:
.globl vector170
vector170:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $170
80105d9c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105da1:	e9 84 f3 ff ff       	jmp    8010512a <alltraps>

80105da6 <vector171>:
.globl vector171
vector171:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $171
80105da8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105dad:	e9 78 f3 ff ff       	jmp    8010512a <alltraps>

80105db2 <vector172>:
.globl vector172
vector172:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $172
80105db4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105db9:	e9 6c f3 ff ff       	jmp    8010512a <alltraps>

80105dbe <vector173>:
.globl vector173
vector173:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $173
80105dc0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105dc5:	e9 60 f3 ff ff       	jmp    8010512a <alltraps>

80105dca <vector174>:
.globl vector174
vector174:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $174
80105dcc:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105dd1:	e9 54 f3 ff ff       	jmp    8010512a <alltraps>

80105dd6 <vector175>:
.globl vector175
vector175:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $175
80105dd8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105ddd:	e9 48 f3 ff ff       	jmp    8010512a <alltraps>

80105de2 <vector176>:
.globl vector176
vector176:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $176
80105de4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105de9:	e9 3c f3 ff ff       	jmp    8010512a <alltraps>

80105dee <vector177>:
.globl vector177
vector177:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $177
80105df0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105df5:	e9 30 f3 ff ff       	jmp    8010512a <alltraps>

80105dfa <vector178>:
.globl vector178
vector178:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $178
80105dfc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105e01:	e9 24 f3 ff ff       	jmp    8010512a <alltraps>

80105e06 <vector179>:
.globl vector179
vector179:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $179
80105e08:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105e0d:	e9 18 f3 ff ff       	jmp    8010512a <alltraps>

80105e12 <vector180>:
.globl vector180
vector180:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $180
80105e14:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105e19:	e9 0c f3 ff ff       	jmp    8010512a <alltraps>

80105e1e <vector181>:
.globl vector181
vector181:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $181
80105e20:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105e25:	e9 00 f3 ff ff       	jmp    8010512a <alltraps>

80105e2a <vector182>:
.globl vector182
vector182:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $182
80105e2c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105e31:	e9 f4 f2 ff ff       	jmp    8010512a <alltraps>

80105e36 <vector183>:
.globl vector183
vector183:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $183
80105e38:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105e3d:	e9 e8 f2 ff ff       	jmp    8010512a <alltraps>

80105e42 <vector184>:
.globl vector184
vector184:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $184
80105e44:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105e49:	e9 dc f2 ff ff       	jmp    8010512a <alltraps>

80105e4e <vector185>:
.globl vector185
vector185:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $185
80105e50:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105e55:	e9 d0 f2 ff ff       	jmp    8010512a <alltraps>

80105e5a <vector186>:
.globl vector186
vector186:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $186
80105e5c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105e61:	e9 c4 f2 ff ff       	jmp    8010512a <alltraps>

80105e66 <vector187>:
.globl vector187
vector187:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $187
80105e68:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105e6d:	e9 b8 f2 ff ff       	jmp    8010512a <alltraps>

80105e72 <vector188>:
.globl vector188
vector188:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $188
80105e74:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105e79:	e9 ac f2 ff ff       	jmp    8010512a <alltraps>

80105e7e <vector189>:
.globl vector189
vector189:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $189
80105e80:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105e85:	e9 a0 f2 ff ff       	jmp    8010512a <alltraps>

80105e8a <vector190>:
.globl vector190
vector190:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $190
80105e8c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105e91:	e9 94 f2 ff ff       	jmp    8010512a <alltraps>

80105e96 <vector191>:
.globl vector191
vector191:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $191
80105e98:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105e9d:	e9 88 f2 ff ff       	jmp    8010512a <alltraps>

80105ea2 <vector192>:
.globl vector192
vector192:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $192
80105ea4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105ea9:	e9 7c f2 ff ff       	jmp    8010512a <alltraps>

80105eae <vector193>:
.globl vector193
vector193:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $193
80105eb0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105eb5:	e9 70 f2 ff ff       	jmp    8010512a <alltraps>

80105eba <vector194>:
.globl vector194
vector194:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $194
80105ebc:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105ec1:	e9 64 f2 ff ff       	jmp    8010512a <alltraps>

80105ec6 <vector195>:
.globl vector195
vector195:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $195
80105ec8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105ecd:	e9 58 f2 ff ff       	jmp    8010512a <alltraps>

80105ed2 <vector196>:
.globl vector196
vector196:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $196
80105ed4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105ed9:	e9 4c f2 ff ff       	jmp    8010512a <alltraps>

80105ede <vector197>:
.globl vector197
vector197:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $197
80105ee0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105ee5:	e9 40 f2 ff ff       	jmp    8010512a <alltraps>

80105eea <vector198>:
.globl vector198
vector198:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $198
80105eec:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105ef1:	e9 34 f2 ff ff       	jmp    8010512a <alltraps>

80105ef6 <vector199>:
.globl vector199
vector199:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $199
80105ef8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105efd:	e9 28 f2 ff ff       	jmp    8010512a <alltraps>

80105f02 <vector200>:
.globl vector200
vector200:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $200
80105f04:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105f09:	e9 1c f2 ff ff       	jmp    8010512a <alltraps>

80105f0e <vector201>:
.globl vector201
vector201:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $201
80105f10:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105f15:	e9 10 f2 ff ff       	jmp    8010512a <alltraps>

80105f1a <vector202>:
.globl vector202
vector202:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $202
80105f1c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105f21:	e9 04 f2 ff ff       	jmp    8010512a <alltraps>

80105f26 <vector203>:
.globl vector203
vector203:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $203
80105f28:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105f2d:	e9 f8 f1 ff ff       	jmp    8010512a <alltraps>

80105f32 <vector204>:
.globl vector204
vector204:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $204
80105f34:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105f39:	e9 ec f1 ff ff       	jmp    8010512a <alltraps>

80105f3e <vector205>:
.globl vector205
vector205:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $205
80105f40:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105f45:	e9 e0 f1 ff ff       	jmp    8010512a <alltraps>

80105f4a <vector206>:
.globl vector206
vector206:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $206
80105f4c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105f51:	e9 d4 f1 ff ff       	jmp    8010512a <alltraps>

80105f56 <vector207>:
.globl vector207
vector207:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $207
80105f58:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105f5d:	e9 c8 f1 ff ff       	jmp    8010512a <alltraps>

80105f62 <vector208>:
.globl vector208
vector208:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $208
80105f64:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105f69:	e9 bc f1 ff ff       	jmp    8010512a <alltraps>

80105f6e <vector209>:
.globl vector209
vector209:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $209
80105f70:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105f75:	e9 b0 f1 ff ff       	jmp    8010512a <alltraps>

80105f7a <vector210>:
.globl vector210
vector210:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $210
80105f7c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105f81:	e9 a4 f1 ff ff       	jmp    8010512a <alltraps>

80105f86 <vector211>:
.globl vector211
vector211:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $211
80105f88:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105f8d:	e9 98 f1 ff ff       	jmp    8010512a <alltraps>

80105f92 <vector212>:
.globl vector212
vector212:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $212
80105f94:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105f99:	e9 8c f1 ff ff       	jmp    8010512a <alltraps>

80105f9e <vector213>:
.globl vector213
vector213:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $213
80105fa0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105fa5:	e9 80 f1 ff ff       	jmp    8010512a <alltraps>

80105faa <vector214>:
.globl vector214
vector214:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $214
80105fac:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105fb1:	e9 74 f1 ff ff       	jmp    8010512a <alltraps>

80105fb6 <vector215>:
.globl vector215
vector215:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $215
80105fb8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105fbd:	e9 68 f1 ff ff       	jmp    8010512a <alltraps>

80105fc2 <vector216>:
.globl vector216
vector216:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $216
80105fc4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105fc9:	e9 5c f1 ff ff       	jmp    8010512a <alltraps>

80105fce <vector217>:
.globl vector217
vector217:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $217
80105fd0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105fd5:	e9 50 f1 ff ff       	jmp    8010512a <alltraps>

80105fda <vector218>:
.globl vector218
vector218:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $218
80105fdc:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105fe1:	e9 44 f1 ff ff       	jmp    8010512a <alltraps>

80105fe6 <vector219>:
.globl vector219
vector219:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $219
80105fe8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105fed:	e9 38 f1 ff ff       	jmp    8010512a <alltraps>

80105ff2 <vector220>:
.globl vector220
vector220:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $220
80105ff4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105ff9:	e9 2c f1 ff ff       	jmp    8010512a <alltraps>

80105ffe <vector221>:
.globl vector221
vector221:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $221
80106000:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106005:	e9 20 f1 ff ff       	jmp    8010512a <alltraps>

8010600a <vector222>:
.globl vector222
vector222:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $222
8010600c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106011:	e9 14 f1 ff ff       	jmp    8010512a <alltraps>

80106016 <vector223>:
.globl vector223
vector223:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $223
80106018:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010601d:	e9 08 f1 ff ff       	jmp    8010512a <alltraps>

80106022 <vector224>:
.globl vector224
vector224:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $224
80106024:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106029:	e9 fc f0 ff ff       	jmp    8010512a <alltraps>

8010602e <vector225>:
.globl vector225
vector225:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $225
80106030:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106035:	e9 f0 f0 ff ff       	jmp    8010512a <alltraps>

8010603a <vector226>:
.globl vector226
vector226:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $226
8010603c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106041:	e9 e4 f0 ff ff       	jmp    8010512a <alltraps>

80106046 <vector227>:
.globl vector227
vector227:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $227
80106048:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010604d:	e9 d8 f0 ff ff       	jmp    8010512a <alltraps>

80106052 <vector228>:
.globl vector228
vector228:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $228
80106054:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106059:	e9 cc f0 ff ff       	jmp    8010512a <alltraps>

8010605e <vector229>:
.globl vector229
vector229:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $229
80106060:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106065:	e9 c0 f0 ff ff       	jmp    8010512a <alltraps>

8010606a <vector230>:
.globl vector230
vector230:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $230
8010606c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106071:	e9 b4 f0 ff ff       	jmp    8010512a <alltraps>

80106076 <vector231>:
.globl vector231
vector231:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $231
80106078:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010607d:	e9 a8 f0 ff ff       	jmp    8010512a <alltraps>

80106082 <vector232>:
.globl vector232
vector232:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $232
80106084:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106089:	e9 9c f0 ff ff       	jmp    8010512a <alltraps>

8010608e <vector233>:
.globl vector233
vector233:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $233
80106090:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106095:	e9 90 f0 ff ff       	jmp    8010512a <alltraps>

8010609a <vector234>:
.globl vector234
vector234:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $234
8010609c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801060a1:	e9 84 f0 ff ff       	jmp    8010512a <alltraps>

801060a6 <vector235>:
.globl vector235
vector235:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $235
801060a8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801060ad:	e9 78 f0 ff ff       	jmp    8010512a <alltraps>

801060b2 <vector236>:
.globl vector236
vector236:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $236
801060b4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801060b9:	e9 6c f0 ff ff       	jmp    8010512a <alltraps>

801060be <vector237>:
.globl vector237
vector237:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $237
801060c0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801060c5:	e9 60 f0 ff ff       	jmp    8010512a <alltraps>

801060ca <vector238>:
.globl vector238
vector238:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $238
801060cc:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801060d1:	e9 54 f0 ff ff       	jmp    8010512a <alltraps>

801060d6 <vector239>:
.globl vector239
vector239:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $239
801060d8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801060dd:	e9 48 f0 ff ff       	jmp    8010512a <alltraps>

801060e2 <vector240>:
.globl vector240
vector240:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $240
801060e4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801060e9:	e9 3c f0 ff ff       	jmp    8010512a <alltraps>

801060ee <vector241>:
.globl vector241
vector241:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $241
801060f0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801060f5:	e9 30 f0 ff ff       	jmp    8010512a <alltraps>

801060fa <vector242>:
.globl vector242
vector242:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $242
801060fc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106101:	e9 24 f0 ff ff       	jmp    8010512a <alltraps>

80106106 <vector243>:
.globl vector243
vector243:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $243
80106108:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010610d:	e9 18 f0 ff ff       	jmp    8010512a <alltraps>

80106112 <vector244>:
.globl vector244
vector244:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $244
80106114:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106119:	e9 0c f0 ff ff       	jmp    8010512a <alltraps>

8010611e <vector245>:
.globl vector245
vector245:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $245
80106120:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106125:	e9 00 f0 ff ff       	jmp    8010512a <alltraps>

8010612a <vector246>:
.globl vector246
vector246:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $246
8010612c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106131:	e9 f4 ef ff ff       	jmp    8010512a <alltraps>

80106136 <vector247>:
.globl vector247
vector247:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $247
80106138:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010613d:	e9 e8 ef ff ff       	jmp    8010512a <alltraps>

80106142 <vector248>:
.globl vector248
vector248:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $248
80106144:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106149:	e9 dc ef ff ff       	jmp    8010512a <alltraps>

8010614e <vector249>:
.globl vector249
vector249:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $249
80106150:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106155:	e9 d0 ef ff ff       	jmp    8010512a <alltraps>

8010615a <vector250>:
.globl vector250
vector250:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $250
8010615c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106161:	e9 c4 ef ff ff       	jmp    8010512a <alltraps>

80106166 <vector251>:
.globl vector251
vector251:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $251
80106168:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010616d:	e9 b8 ef ff ff       	jmp    8010512a <alltraps>

80106172 <vector252>:
.globl vector252
vector252:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $252
80106174:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106179:	e9 ac ef ff ff       	jmp    8010512a <alltraps>

8010617e <vector253>:
.globl vector253
vector253:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $253
80106180:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106185:	e9 a0 ef ff ff       	jmp    8010512a <alltraps>

8010618a <vector254>:
.globl vector254
vector254:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $254
8010618c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106191:	e9 94 ef ff ff       	jmp    8010512a <alltraps>

80106196 <vector255>:
.globl vector255
vector255:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $255
80106198:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010619d:	e9 88 ef ff ff       	jmp    8010512a <alltraps>

801061a2 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801061a2:	55                   	push   %ebp
801061a3:	89 e5                	mov    %esp,%ebp
801061a5:	57                   	push   %edi
801061a6:	56                   	push   %esi
801061a7:	53                   	push   %ebx
801061a8:	83 ec 0c             	sub    $0xc,%esp
801061ab:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801061ad:	c1 ea 16             	shr    $0x16,%edx
801061b0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
801061b3:	8b 37                	mov    (%edi),%esi
801061b5:	f7 c6 01 00 00 00    	test   $0x1,%esi
801061bb:	74 20                	je     801061dd <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801061bd:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801061c3:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801061c9:	c1 eb 0c             	shr    $0xc,%ebx
801061cc:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
801061d2:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
801061d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061d8:	5b                   	pop    %ebx
801061d9:	5e                   	pop    %esi
801061da:	5f                   	pop    %edi
801061db:	5d                   	pop    %ebp
801061dc:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801061dd:	85 c9                	test   %ecx,%ecx
801061df:	74 2b                	je     8010620c <walkpgdir+0x6a>
801061e1:	e8 26 bf ff ff       	call   8010210c <kalloc>
801061e6:	89 c6                	mov    %eax,%esi
801061e8:	85 c0                	test   %eax,%eax
801061ea:	74 20                	je     8010620c <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
801061ec:	83 ec 04             	sub    $0x4,%esp
801061ef:	68 00 10 00 00       	push   $0x1000
801061f4:	6a 00                	push   $0x0
801061f6:	50                   	push   %eax
801061f7:	e8 c7 dc ff ff       	call   80103ec3 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801061fc:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106202:	83 c8 07             	or     $0x7,%eax
80106205:	89 07                	mov    %eax,(%edi)
80106207:	83 c4 10             	add    $0x10,%esp
8010620a:	eb bd                	jmp    801061c9 <walkpgdir+0x27>
      return 0;
8010620c:	b8 00 00 00 00       	mov    $0x0,%eax
80106211:	eb c2                	jmp    801061d5 <walkpgdir+0x33>

80106213 <seginit>:
{
80106213:	f3 0f 1e fb          	endbr32 
80106217:	55                   	push   %ebp
80106218:	89 e5                	mov    %esp,%ebp
8010621a:	57                   	push   %edi
8010621b:	56                   	push   %esi
8010621c:	53                   	push   %ebx
8010621d:	83 ec 1c             	sub    $0x1c,%esp
  c = &cpus[cpuid()];
80106220:	e8 1b d0 ff ff       	call   80103240 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106225:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80106228:	8d 3c 09             	lea    (%ecx,%ecx,1),%edi
8010622b:	8d 14 07             	lea    (%edi,%eax,1),%edx
8010622e:	c1 e2 04             	shl    $0x4,%edx
80106231:	66 c7 82 f8 27 11 80 	movw   $0xffff,-0x7feed808(%edx)
80106238:	ff ff 
8010623a:	66 c7 82 fa 27 11 80 	movw   $0x0,-0x7feed806(%edx)
80106241:	00 00 
80106243:	c6 82 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%edx)
8010624a:	8d 34 07             	lea    (%edi,%eax,1),%esi
8010624d:	c1 e6 04             	shl    $0x4,%esi
80106250:	8a 9e fd 27 11 80    	mov    -0x7feed803(%esi),%bl
80106256:	83 e3 f0             	and    $0xfffffff0,%ebx
80106259:	83 cb 1a             	or     $0x1a,%ebx
8010625c:	83 e3 9f             	and    $0xffffff9f,%ebx
8010625f:	83 cb 80             	or     $0xffffff80,%ebx
80106262:	88 9e fd 27 11 80    	mov    %bl,-0x7feed803(%esi)
80106268:	8a 9e fe 27 11 80    	mov    -0x7feed802(%esi),%bl
8010626e:	83 cb 0f             	or     $0xf,%ebx
80106271:	83 e3 cf             	and    $0xffffffcf,%ebx
80106274:	83 cb c0             	or     $0xffffffc0,%ebx
80106277:	88 9e fe 27 11 80    	mov    %bl,-0x7feed802(%esi)
8010627d:	c6 82 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106284:	66 c7 82 00 28 11 80 	movw   $0xffff,-0x7feed800(%edx)
8010628b:	ff ff 
8010628d:	66 c7 82 02 28 11 80 	movw   $0x0,-0x7feed7fe(%edx)
80106294:	00 00 
80106296:	c6 82 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%edx)
8010629d:	8d 34 07             	lea    (%edi,%eax,1),%esi
801062a0:	c1 e6 04             	shl    $0x4,%esi
801062a3:	8a 9e 05 28 11 80    	mov    -0x7feed7fb(%esi),%bl
801062a9:	83 e3 f0             	and    $0xfffffff0,%ebx
801062ac:	83 cb 12             	or     $0x12,%ebx
801062af:	83 e3 9f             	and    $0xffffff9f,%ebx
801062b2:	83 cb 80             	or     $0xffffff80,%ebx
801062b5:	88 9e 05 28 11 80    	mov    %bl,-0x7feed7fb(%esi)
801062bb:	8a 9e 06 28 11 80    	mov    -0x7feed7fa(%esi),%bl
801062c1:	83 cb 0f             	or     $0xf,%ebx
801062c4:	83 e3 cf             	and    $0xffffffcf,%ebx
801062c7:	83 cb c0             	or     $0xffffffc0,%ebx
801062ca:	88 9e 06 28 11 80    	mov    %bl,-0x7feed7fa(%esi)
801062d0:	c6 82 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801062d7:	66 c7 82 08 28 11 80 	movw   $0xffff,-0x7feed7f8(%edx)
801062de:	ff ff 
801062e0:	66 c7 82 0a 28 11 80 	movw   $0x0,-0x7feed7f6(%edx)
801062e7:	00 00 
801062e9:	c6 82 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%edx)
801062f0:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
801062f3:	c1 e3 04             	shl    $0x4,%ebx
801062f6:	c6 83 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%ebx)
801062fd:	0f b6 b3 0e 28 11 80 	movzbl -0x7feed7f2(%ebx),%esi
80106304:	83 ce 0f             	or     $0xf,%esi
80106307:	83 e6 cf             	and    $0xffffffcf,%esi
8010630a:	83 ce c0             	or     $0xffffffc0,%esi
8010630d:	89 f1                	mov    %esi,%ecx
8010630f:	88 8b 0e 28 11 80    	mov    %cl,-0x7feed7f2(%ebx)
80106315:	c6 82 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010631c:	66 c7 82 10 28 11 80 	movw   $0xffff,-0x7feed7f0(%edx)
80106323:	ff ff 
80106325:	66 c7 82 12 28 11 80 	movw   $0x0,-0x7feed7ee(%edx)
8010632c:	00 00 
8010632e:	c6 82 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%edx)
80106335:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80106338:	c1 e3 04             	shl    $0x4,%ebx
8010633b:	c6 83 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%ebx)
80106342:	0f b6 b3 16 28 11 80 	movzbl -0x7feed7ea(%ebx),%esi
80106349:	83 ce 0f             	or     $0xf,%esi
8010634c:	83 e6 cf             	and    $0xffffffcf,%esi
8010634f:	83 ce c0             	or     $0xffffffc0,%esi
80106352:	89 f1                	mov    %esi,%ecx
80106354:	88 8b 16 28 11 80    	mov    %cl,-0x7feed7ea(%ebx)
8010635a:	c6 82 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%edx)
  lgdt(c->gdt, sizeof(c->gdt));
80106361:	8d 0c 07             	lea    (%edi,%eax,1),%ecx
80106364:	c1 e1 04             	shl    $0x4,%ecx
80106367:	81 c1 f0 27 11 80    	add    $0x801127f0,%ecx
  pd[0] = size-1;
8010636d:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
80106373:	66 89 4d e4          	mov    %cx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
80106377:	c1 e9 10             	shr    $0x10,%ecx
8010637a:	66 89 4d e6          	mov    %cx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010637e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106381:	0f 01 10             	lgdtl  (%eax)
}
80106384:	83 c4 1c             	add    $0x1c,%esp
80106387:	5b                   	pop    %ebx
80106388:	5e                   	pop    %esi
80106389:	5f                   	pop    %edi
8010638a:	5d                   	pop    %ebp
8010638b:	c3                   	ret    

8010638c <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010638c:	f3 0f 1e fb          	endbr32 
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	57                   	push   %edi
80106394:	56                   	push   %esi
80106395:	53                   	push   %ebx
80106396:	83 ec 0c             	sub    $0xc,%esp
80106399:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010639c:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010639f:	89 fb                	mov    %edi,%ebx
801063a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801063a7:	03 7d 10             	add    0x10(%ebp),%edi
801063aa:	4f                   	dec    %edi
801063ab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801063b1:	b9 01 00 00 00       	mov    $0x1,%ecx
801063b6:	89 da                	mov    %ebx,%edx
801063b8:	8b 45 08             	mov    0x8(%ebp),%eax
801063bb:	e8 e2 fd ff ff       	call   801061a2 <walkpgdir>
801063c0:	85 c0                	test   %eax,%eax
801063c2:	74 2e                	je     801063f2 <mappages+0x66>
      return -1;
    if(*pte & PTE_P)
801063c4:	f6 00 01             	testb  $0x1,(%eax)
801063c7:	75 1c                	jne    801063e5 <mappages+0x59>
      panic("remap");
    *pte = pa | perm | PTE_P;
801063c9:	89 f2                	mov    %esi,%edx
801063cb:	0b 55 18             	or     0x18(%ebp),%edx
801063ce:	83 ca 01             	or     $0x1,%edx
801063d1:	89 10                	mov    %edx,(%eax)
    if(a == last)
801063d3:	39 fb                	cmp    %edi,%ebx
801063d5:	74 28                	je     801063ff <mappages+0x73>
      break;
    a += PGSIZE;
801063d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
801063dd:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801063e3:	eb cc                	jmp    801063b1 <mappages+0x25>
      panic("remap");
801063e5:	83 ec 0c             	sub    $0xc,%esp
801063e8:	68 e4 73 10 80       	push   $0x801073e4
801063ed:	e8 63 9f ff ff       	call   80100355 <panic>
      return -1;
801063f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801063f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063fa:	5b                   	pop    %ebx
801063fb:	5e                   	pop    %esi
801063fc:	5f                   	pop    %edi
801063fd:	5d                   	pop    %ebp
801063fe:	c3                   	ret    
  return 0;
801063ff:	b8 00 00 00 00       	mov    $0x0,%eax
80106404:	eb f1                	jmp    801063f7 <mappages+0x6b>

80106406 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106406:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010640a:	a1 a4 57 11 80       	mov    0x801157a4,%eax
8010640f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106414:	0f 22 d8             	mov    %eax,%cr3
}
80106417:	c3                   	ret    

80106418 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106418:	f3 0f 1e fb          	endbr32 
8010641c:	55                   	push   %ebp
8010641d:	89 e5                	mov    %esp,%ebp
8010641f:	57                   	push   %edi
80106420:	56                   	push   %esi
80106421:	53                   	push   %ebx
80106422:	83 ec 1c             	sub    $0x1c,%esp
80106425:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106428:	85 f6                	test   %esi,%esi
8010642a:	0f 84 da 00 00 00    	je     8010650a <switchuvm+0xf2>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106430:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80106434:	0f 84 dd 00 00 00    	je     80106517 <switchuvm+0xff>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010643a:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
8010643e:	0f 84 e0 00 00 00    	je     80106524 <switchuvm+0x10c>
    panic("switchuvm: no pgdir");

  pushcli();
80106444:	e8 de d8 ff ff       	call   80103d27 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106449:	e8 8b cd ff ff       	call   801031d9 <mycpu>
8010644e:	89 c3                	mov    %eax,%ebx
80106450:	e8 84 cd ff ff       	call   801031d9 <mycpu>
80106455:	8d 78 08             	lea    0x8(%eax),%edi
80106458:	e8 7c cd ff ff       	call   801031d9 <mycpu>
8010645d:	83 c0 08             	add    $0x8,%eax
80106460:	c1 e8 10             	shr    $0x10,%eax
80106463:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106466:	e8 6e cd ff ff       	call   801031d9 <mycpu>
8010646b:	83 c0 08             	add    $0x8,%eax
8010646e:	c1 e8 18             	shr    $0x18,%eax
80106471:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106478:	67 00 
8010647a:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106481:	8a 4d e4             	mov    -0x1c(%ebp),%cl
80106484:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010648a:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80106490:	83 e2 f0             	and    $0xfffffff0,%edx
80106493:	83 ca 19             	or     $0x19,%edx
80106496:	83 e2 9f             	and    $0xffffff9f,%edx
80106499:	83 ca 80             	or     $0xffffff80,%edx
8010649c:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801064a2:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801064a9:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801064af:	e8 25 cd ff ff       	call   801031d9 <mycpu>
801064b4:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801064ba:	83 e2 ef             	and    $0xffffffef,%edx
801064bd:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801064c3:	e8 11 cd ff ff       	call   801031d9 <mycpu>
801064c8:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801064ce:	8b 5e 08             	mov    0x8(%esi),%ebx
801064d1:	e8 03 cd ff ff       	call   801031d9 <mycpu>
801064d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064dc:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801064df:	e8 f5 cc ff ff       	call   801031d9 <mycpu>
801064e4:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801064ea:	b8 28 00 00 00       	mov    $0x28,%eax
801064ef:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801064f2:	8b 46 04             	mov    0x4(%esi),%eax
801064f5:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801064fa:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801064fd:	e8 65 d8 ff ff       	call   80103d67 <popcli>
}
80106502:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106505:	5b                   	pop    %ebx
80106506:	5e                   	pop    %esi
80106507:	5f                   	pop    %edi
80106508:	5d                   	pop    %ebp
80106509:	c3                   	ret    
    panic("switchuvm: no process");
8010650a:	83 ec 0c             	sub    $0xc,%esp
8010650d:	68 ea 73 10 80       	push   $0x801073ea
80106512:	e8 3e 9e ff ff       	call   80100355 <panic>
    panic("switchuvm: no kstack");
80106517:	83 ec 0c             	sub    $0xc,%esp
8010651a:	68 00 74 10 80       	push   $0x80107400
8010651f:	e8 31 9e ff ff       	call   80100355 <panic>
    panic("switchuvm: no pgdir");
80106524:	83 ec 0c             	sub    $0xc,%esp
80106527:	68 15 74 10 80       	push   $0x80107415
8010652c:	e8 24 9e ff ff       	call   80100355 <panic>

80106531 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106531:	f3 0f 1e fb          	endbr32 
80106535:	55                   	push   %ebp
80106536:	89 e5                	mov    %esp,%ebp
80106538:	56                   	push   %esi
80106539:	53                   	push   %ebx
8010653a:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
8010653d:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106543:	77 4b                	ja     80106590 <inituvm+0x5f>
    panic("inituvm: more than a page");
  mem = kalloc();
80106545:	e8 c2 bb ff ff       	call   8010210c <kalloc>
8010654a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010654c:	83 ec 04             	sub    $0x4,%esp
8010654f:	68 00 10 00 00       	push   $0x1000
80106554:	6a 00                	push   $0x0
80106556:	50                   	push   %eax
80106557:	e8 67 d9 ff ff       	call   80103ec3 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010655c:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106563:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106569:	50                   	push   %eax
8010656a:	68 00 10 00 00       	push   $0x1000
8010656f:	6a 00                	push   $0x0
80106571:	ff 75 08             	pushl  0x8(%ebp)
80106574:	e8 13 fe ff ff       	call   8010638c <mappages>
  memmove(mem, init, sz);
80106579:	83 c4 1c             	add    $0x1c,%esp
8010657c:	56                   	push   %esi
8010657d:	ff 75 0c             	pushl  0xc(%ebp)
80106580:	53                   	push   %ebx
80106581:	e8 bb d9 ff ff       	call   80103f41 <memmove>
}
80106586:	83 c4 10             	add    $0x10,%esp
80106589:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010658c:	5b                   	pop    %ebx
8010658d:	5e                   	pop    %esi
8010658e:	5d                   	pop    %ebp
8010658f:	c3                   	ret    
    panic("inituvm: more than a page");
80106590:	83 ec 0c             	sub    $0xc,%esp
80106593:	68 29 74 10 80       	push   $0x80107429
80106598:	e8 b8 9d ff ff       	call   80100355 <panic>

8010659d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010659d:	f3 0f 1e fb          	endbr32 
801065a1:	55                   	push   %ebp
801065a2:	89 e5                	mov    %esp,%ebp
801065a4:	57                   	push   %edi
801065a5:	56                   	push   %esi
801065a6:	53                   	push   %ebx
801065a7:	83 ec 0c             	sub    $0xc,%esp
801065aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801065ad:	89 fb                	mov    %edi,%ebx
801065af:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801065b5:	74 3c                	je     801065f3 <loaduvm+0x56>
    panic("loaduvm: addr must be page aligned");
801065b7:	83 ec 0c             	sub    $0xc,%esp
801065ba:	68 b0 74 10 80       	push   $0x801074b0
801065bf:	e8 91 9d ff ff       	call   80100355 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801065c4:	83 ec 0c             	sub    $0xc,%esp
801065c7:	68 43 74 10 80       	push   $0x80107443
801065cc:	e8 84 9d ff ff       	call   80100355 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801065d1:	05 00 00 00 80       	add    $0x80000000,%eax
801065d6:	56                   	push   %esi
801065d7:	89 da                	mov    %ebx,%edx
801065d9:	03 55 14             	add    0x14(%ebp),%edx
801065dc:	52                   	push   %edx
801065dd:	50                   	push   %eax
801065de:	ff 75 10             	pushl  0x10(%ebp)
801065e1:	e8 b1 b1 ff ff       	call   80101797 <readi>
801065e6:	83 c4 10             	add    $0x10,%esp
801065e9:	39 f0                	cmp    %esi,%eax
801065eb:	75 47                	jne    80106634 <loaduvm+0x97>
  for(i = 0; i < sz; i += PGSIZE){
801065ed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065f3:	3b 5d 18             	cmp    0x18(%ebp),%ebx
801065f6:	73 2f                	jae    80106627 <loaduvm+0x8a>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801065f8:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
801065fb:	b9 00 00 00 00       	mov    $0x0,%ecx
80106600:	8b 45 08             	mov    0x8(%ebp),%eax
80106603:	e8 9a fb ff ff       	call   801061a2 <walkpgdir>
80106608:	85 c0                	test   %eax,%eax
8010660a:	74 b8                	je     801065c4 <loaduvm+0x27>
    pa = PTE_ADDR(*pte);
8010660c:	8b 00                	mov    (%eax),%eax
8010660e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106613:	8b 75 18             	mov    0x18(%ebp),%esi
80106616:	29 de                	sub    %ebx,%esi
80106618:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010661e:	76 b1                	jbe    801065d1 <loaduvm+0x34>
      n = PGSIZE;
80106620:	be 00 10 00 00       	mov    $0x1000,%esi
80106625:	eb aa                	jmp    801065d1 <loaduvm+0x34>
      return -1;
  }
  return 0;
80106627:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010662c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010662f:	5b                   	pop    %ebx
80106630:	5e                   	pop    %esi
80106631:	5f                   	pop    %edi
80106632:	5d                   	pop    %ebp
80106633:	c3                   	ret    
      return -1;
80106634:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106639:	eb f1                	jmp    8010662c <loaduvm+0x8f>

8010663b <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010663b:	f3 0f 1e fb          	endbr32 
8010663f:	55                   	push   %ebp
80106640:	89 e5                	mov    %esp,%ebp
80106642:	57                   	push   %edi
80106643:	56                   	push   %esi
80106644:	53                   	push   %ebx
80106645:	83 ec 0c             	sub    $0xc,%esp
80106648:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010664b:	39 7d 10             	cmp    %edi,0x10(%ebp)
8010664e:	73 11                	jae    80106661 <deallocuvm+0x26>
    return oldsz;

  a = PGROUNDUP(newsz);
80106650:	8b 45 10             	mov    0x10(%ebp),%eax
80106653:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106659:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010665f:	eb 17                	jmp    80106678 <deallocuvm+0x3d>
    return oldsz;
80106661:	89 f8                	mov    %edi,%eax
80106663:	eb 62                	jmp    801066c7 <deallocuvm+0x8c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106665:	c1 eb 16             	shr    $0x16,%ebx
80106668:	43                   	inc    %ebx
80106669:	c1 e3 16             	shl    $0x16,%ebx
8010666c:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106672:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106678:	39 fb                	cmp    %edi,%ebx
8010667a:	73 48                	jae    801066c4 <deallocuvm+0x89>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010667c:	b9 00 00 00 00       	mov    $0x0,%ecx
80106681:	89 da                	mov    %ebx,%edx
80106683:	8b 45 08             	mov    0x8(%ebp),%eax
80106686:	e8 17 fb ff ff       	call   801061a2 <walkpgdir>
8010668b:	89 c6                	mov    %eax,%esi
    if(!pte)
8010668d:	85 c0                	test   %eax,%eax
8010668f:	74 d4                	je     80106665 <deallocuvm+0x2a>
    else if((*pte & PTE_P) != 0){
80106691:	8b 00                	mov    (%eax),%eax
80106693:	a8 01                	test   $0x1,%al
80106695:	74 db                	je     80106672 <deallocuvm+0x37>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106697:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010669c:	74 19                	je     801066b7 <deallocuvm+0x7c>
        panic("kfree");
      char *v = P2V(pa);
8010669e:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801066a3:	83 ec 0c             	sub    $0xc,%esp
801066a6:	50                   	push   %eax
801066a7:	e8 39 b9 ff ff       	call   80101fe5 <kfree>
      *pte = 0;
801066ac:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801066b2:	83 c4 10             	add    $0x10,%esp
801066b5:	eb bb                	jmp    80106672 <deallocuvm+0x37>
        panic("kfree");
801066b7:	83 ec 0c             	sub    $0xc,%esp
801066ba:	68 06 6d 10 80       	push   $0x80106d06
801066bf:	e8 91 9c ff ff       	call   80100355 <panic>
    }
  }
  return newsz;
801066c4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801066c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066ca:	5b                   	pop    %ebx
801066cb:	5e                   	pop    %esi
801066cc:	5f                   	pop    %edi
801066cd:	5d                   	pop    %ebp
801066ce:	c3                   	ret    

801066cf <allocuvm>:
{
801066cf:	f3 0f 1e fb          	endbr32 
801066d3:	55                   	push   %ebp
801066d4:	89 e5                	mov    %esp,%ebp
801066d6:	57                   	push   %edi
801066d7:	56                   	push   %esi
801066d8:	53                   	push   %ebx
801066d9:	83 ec 1c             	sub    $0x1c,%esp
801066dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801066df:	8b 45 10             	mov    0x10(%ebp),%eax
801066e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066e5:	85 c0                	test   %eax,%eax
801066e7:	0f 88 c0 00 00 00    	js     801067ad <allocuvm+0xde>
  if(newsz < oldsz)
801066ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801066f0:	39 45 10             	cmp    %eax,0x10(%ebp)
801066f3:	72 11                	jb     80106706 <allocuvm+0x37>
  a = PGROUNDUP(oldsz);
801066f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801066f8:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801066fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106704:	eb 36                	jmp    8010673c <allocuvm+0x6d>
    return oldsz;
80106706:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106709:	e9 a6 00 00 00       	jmp    801067b4 <allocuvm+0xe5>
      cprintf("allocuvm out of memory\n");
8010670e:	83 ec 0c             	sub    $0xc,%esp
80106711:	68 61 74 10 80       	push   $0x80107461
80106716:	e8 e2 9e ff ff       	call   801005fd <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010671b:	83 c4 0c             	add    $0xc,%esp
8010671e:	ff 75 0c             	pushl  0xc(%ebp)
80106721:	ff 75 10             	pushl  0x10(%ebp)
80106724:	57                   	push   %edi
80106725:	e8 11 ff ff ff       	call   8010663b <deallocuvm>
      return 0;
8010672a:	83 c4 10             	add    $0x10,%esp
8010672d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106734:	eb 7e                	jmp    801067b4 <allocuvm+0xe5>
  for(; a < newsz; a += PGSIZE){
80106736:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010673c:	3b 75 10             	cmp    0x10(%ebp),%esi
8010673f:	73 73                	jae    801067b4 <allocuvm+0xe5>
    mem = kalloc();
80106741:	e8 c6 b9 ff ff       	call   8010210c <kalloc>
80106746:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106748:	85 c0                	test   %eax,%eax
8010674a:	74 c2                	je     8010670e <allocuvm+0x3f>
    memset(mem, 0, PGSIZE);
8010674c:	83 ec 04             	sub    $0x4,%esp
8010674f:	68 00 10 00 00       	push   $0x1000
80106754:	6a 00                	push   $0x0
80106756:	50                   	push   %eax
80106757:	e8 67 d7 ff ff       	call   80103ec3 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010675c:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106763:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106769:	50                   	push   %eax
8010676a:	68 00 10 00 00       	push   $0x1000
8010676f:	56                   	push   %esi
80106770:	57                   	push   %edi
80106771:	e8 16 fc ff ff       	call   8010638c <mappages>
80106776:	83 c4 20             	add    $0x20,%esp
80106779:	85 c0                	test   %eax,%eax
8010677b:	79 b9                	jns    80106736 <allocuvm+0x67>
      cprintf("allocuvm out of memory (2)\n");
8010677d:	83 ec 0c             	sub    $0xc,%esp
80106780:	68 79 74 10 80       	push   $0x80107479
80106785:	e8 73 9e ff ff       	call   801005fd <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010678a:	83 c4 0c             	add    $0xc,%esp
8010678d:	ff 75 0c             	pushl  0xc(%ebp)
80106790:	ff 75 10             	pushl  0x10(%ebp)
80106793:	57                   	push   %edi
80106794:	e8 a2 fe ff ff       	call   8010663b <deallocuvm>
      kfree(mem);
80106799:	89 1c 24             	mov    %ebx,(%esp)
8010679c:	e8 44 b8 ff ff       	call   80101fe5 <kfree>
      return 0;
801067a1:	83 c4 10             	add    $0x10,%esp
801067a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801067ab:	eb 07                	jmp    801067b4 <allocuvm+0xe5>
    return 0;
801067ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801067b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067ba:	5b                   	pop    %ebx
801067bb:	5e                   	pop    %esi
801067bc:	5f                   	pop    %edi
801067bd:	5d                   	pop    %ebp
801067be:	c3                   	ret    

801067bf <freevm>:

// Free a page table and all the physical memory pages
// in the user part if dodeallocuvm is not zero
void
freevm(pde_t *pgdir, int dodeallocuvm)
{
801067bf:	f3 0f 1e fb          	endbr32 
801067c3:	55                   	push   %ebp
801067c4:	89 e5                	mov    %esp,%ebp
801067c6:	56                   	push   %esi
801067c7:	53                   	push   %ebx
801067c8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801067cb:	85 f6                	test   %esi,%esi
801067cd:	74 0d                	je     801067dc <freevm+0x1d>
    panic("freevm: no pgdir");
  if (dodeallocuvm)
801067cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801067d3:	75 14                	jne    801067e9 <freevm+0x2a>
{
801067d5:	bb 00 00 00 00       	mov    $0x0,%ebx
801067da:	eb 39                	jmp    80106815 <freevm+0x56>
    panic("freevm: no pgdir");
801067dc:	83 ec 0c             	sub    $0xc,%esp
801067df:	68 95 74 10 80       	push   $0x80107495
801067e4:	e8 6c 9b ff ff       	call   80100355 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
801067e9:	83 ec 04             	sub    $0x4,%esp
801067ec:	6a 00                	push   $0x0
801067ee:	68 00 00 00 80       	push   $0x80000000
801067f3:	56                   	push   %esi
801067f4:	e8 42 fe ff ff       	call   8010663b <deallocuvm>
801067f9:	83 c4 10             	add    $0x10,%esp
801067fc:	eb d7                	jmp    801067d5 <freevm+0x16>
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
801067fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106803:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106808:	83 ec 0c             	sub    $0xc,%esp
8010680b:	50                   	push   %eax
8010680c:	e8 d4 b7 ff ff       	call   80101fe5 <kfree>
80106811:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106814:	43                   	inc    %ebx
80106815:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
8010681b:	77 09                	ja     80106826 <freevm+0x67>
    if(pgdir[i] & PTE_P){
8010681d:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
80106820:	a8 01                	test   $0x1,%al
80106822:	74 f0                	je     80106814 <freevm+0x55>
80106824:	eb d8                	jmp    801067fe <freevm+0x3f>
    }
  }
  kfree((char*)pgdir);
80106826:	83 ec 0c             	sub    $0xc,%esp
80106829:	56                   	push   %esi
8010682a:	e8 b6 b7 ff ff       	call   80101fe5 <kfree>
}
8010682f:	83 c4 10             	add    $0x10,%esp
80106832:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106835:	5b                   	pop    %ebx
80106836:	5e                   	pop    %esi
80106837:	5d                   	pop    %ebp
80106838:	c3                   	ret    

80106839 <setupkvm>:
{
80106839:	f3 0f 1e fb          	endbr32 
8010683d:	55                   	push   %ebp
8010683e:	89 e5                	mov    %esp,%ebp
80106840:	56                   	push   %esi
80106841:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106842:	e8 c5 b8 ff ff       	call   8010210c <kalloc>
80106847:	89 c6                	mov    %eax,%esi
80106849:	85 c0                	test   %eax,%eax
8010684b:	74 57                	je     801068a4 <setupkvm+0x6b>
  memset(pgdir, 0, PGSIZE);
8010684d:	83 ec 04             	sub    $0x4,%esp
80106850:	68 00 10 00 00       	push   $0x1000
80106855:	6a 00                	push   $0x0
80106857:	50                   	push   %eax
80106858:	e8 66 d6 ff ff       	call   80103ec3 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010685d:	83 c4 10             	add    $0x10,%esp
80106860:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106865:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
8010686b:	73 37                	jae    801068a4 <setupkvm+0x6b>
                (uint)k->phys_start, k->perm) < 0) {
8010686d:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106870:	83 ec 0c             	sub    $0xc,%esp
80106873:	ff 73 0c             	pushl  0xc(%ebx)
80106876:	50                   	push   %eax
80106877:	8b 53 08             	mov    0x8(%ebx),%edx
8010687a:	29 c2                	sub    %eax,%edx
8010687c:	52                   	push   %edx
8010687d:	ff 33                	pushl  (%ebx)
8010687f:	56                   	push   %esi
80106880:	e8 07 fb ff ff       	call   8010638c <mappages>
80106885:	83 c4 20             	add    $0x20,%esp
80106888:	85 c0                	test   %eax,%eax
8010688a:	78 05                	js     80106891 <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010688c:	83 c3 10             	add    $0x10,%ebx
8010688f:	eb d4                	jmp    80106865 <setupkvm+0x2c>
      freevm(pgdir, 0);
80106891:	83 ec 08             	sub    $0x8,%esp
80106894:	6a 00                	push   $0x0
80106896:	56                   	push   %esi
80106897:	e8 23 ff ff ff       	call   801067bf <freevm>
      return 0;
8010689c:	83 c4 10             	add    $0x10,%esp
8010689f:	be 00 00 00 00       	mov    $0x0,%esi
}
801068a4:	89 f0                	mov    %esi,%eax
801068a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801068a9:	5b                   	pop    %ebx
801068aa:	5e                   	pop    %esi
801068ab:	5d                   	pop    %ebp
801068ac:	c3                   	ret    

801068ad <kvmalloc>:
{
801068ad:	f3 0f 1e fb          	endbr32 
801068b1:	55                   	push   %ebp
801068b2:	89 e5                	mov    %esp,%ebp
801068b4:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801068b7:	e8 7d ff ff ff       	call   80106839 <setupkvm>
801068bc:	a3 a4 57 11 80       	mov    %eax,0x801157a4
  switchkvm();
801068c1:	e8 40 fb ff ff       	call   80106406 <switchkvm>
}
801068c6:	c9                   	leave  
801068c7:	c3                   	ret    

801068c8 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801068c8:	f3 0f 1e fb          	endbr32 
801068cc:	55                   	push   %ebp
801068cd:	89 e5                	mov    %esp,%ebp
801068cf:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801068d2:	b9 00 00 00 00       	mov    $0x0,%ecx
801068d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801068da:	8b 45 08             	mov    0x8(%ebp),%eax
801068dd:	e8 c0 f8 ff ff       	call   801061a2 <walkpgdir>
  if(pte == 0)
801068e2:	85 c0                	test   %eax,%eax
801068e4:	74 05                	je     801068eb <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
801068e6:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801068e9:	c9                   	leave  
801068ea:	c3                   	ret    
    panic("clearpteu");
801068eb:	83 ec 0c             	sub    $0xc,%esp
801068ee:	68 a6 74 10 80       	push   $0x801074a6
801068f3:	e8 5d 9a ff ff       	call   80100355 <panic>

801068f8 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801068f8:	f3 0f 1e fb          	endbr32 
801068fc:	55                   	push   %ebp
801068fd:	89 e5                	mov    %esp,%ebp
801068ff:	57                   	push   %edi
80106900:	56                   	push   %esi
80106901:	53                   	push   %ebx
80106902:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106905:	e8 2f ff ff ff       	call   80106839 <setupkvm>
8010690a:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010690d:	85 c0                	test   %eax,%eax
8010690f:	0f 84 a9 00 00 00    	je     801069be <copyuvm+0xc6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106915:	be 00 00 00 00       	mov    $0x0,%esi
8010691a:	eb 06                	jmp    80106922 <copyuvm+0x2a>
8010691c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106922:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106925:	0f 83 93 00 00 00    	jae    801069be <copyuvm+0xc6>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010692b:	b9 00 00 00 00       	mov    $0x0,%ecx
80106930:	89 f2                	mov    %esi,%edx
80106932:	8b 45 08             	mov    0x8(%ebp),%eax
80106935:	e8 68 f8 ff ff       	call   801061a2 <walkpgdir>
8010693a:	85 c0                	test   %eax,%eax
8010693c:	74 de                	je     8010691c <copyuvm+0x24>
      //panic("copyuvm: pte should exist");
      continue;
    if(!(*pte & PTE_P))
8010693e:	8b 00                	mov    (%eax),%eax
80106940:	a8 01                	test   $0x1,%al
80106942:	74 d8                	je     8010691c <copyuvm+0x24>
      //panic("copyuvm: page not present");
      continue;
    pa = PTE_ADDR(*pte);
80106944:	89 c2                	mov    %eax,%edx
80106946:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010694c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
8010694f:	25 ff 0f 00 00       	and    $0xfff,%eax
80106954:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80106957:	e8 b0 b7 ff ff       	call   8010210c <kalloc>
8010695c:	89 c7                	mov    %eax,%edi
8010695e:	85 c0                	test   %eax,%eax
80106960:	74 45                	je     801069a7 <copyuvm+0xaf>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106965:	05 00 00 00 80       	add    $0x80000000,%eax
8010696a:	83 ec 04             	sub    $0x4,%esp
8010696d:	68 00 10 00 00       	push   $0x1000
80106972:	50                   	push   %eax
80106973:	57                   	push   %edi
80106974:	e8 c8 d5 ff ff       	call   80103f41 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106979:	83 c4 04             	add    $0x4,%esp
8010697c:	ff 75 e0             	pushl  -0x20(%ebp)
8010697f:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106985:	50                   	push   %eax
80106986:	68 00 10 00 00       	push   $0x1000
8010698b:	56                   	push   %esi
8010698c:	ff 75 dc             	pushl  -0x24(%ebp)
8010698f:	e8 f8 f9 ff ff       	call   8010638c <mappages>
80106994:	83 c4 20             	add    $0x20,%esp
80106997:	85 c0                	test   %eax,%eax
80106999:	79 81                	jns    8010691c <copyuvm+0x24>
      kfree(mem);
8010699b:	83 ec 0c             	sub    $0xc,%esp
8010699e:	57                   	push   %edi
8010699f:	e8 41 b6 ff ff       	call   80101fe5 <kfree>
      goto bad;
801069a4:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d, 1);
801069a7:	83 ec 08             	sub    $0x8,%esp
801069aa:	6a 01                	push   $0x1
801069ac:	ff 75 dc             	pushl  -0x24(%ebp)
801069af:	e8 0b fe ff ff       	call   801067bf <freevm>
  return 0;
801069b4:	83 c4 10             	add    $0x10,%esp
801069b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
801069be:	8b 45 dc             	mov    -0x24(%ebp),%eax
801069c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069c4:	5b                   	pop    %ebx
801069c5:	5e                   	pop    %esi
801069c6:	5f                   	pop    %edi
801069c7:	5d                   	pop    %ebp
801069c8:	c3                   	ret    

801069c9 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801069c9:	f3 0f 1e fb          	endbr32 
801069cd:	55                   	push   %ebp
801069ce:	89 e5                	mov    %esp,%ebp
801069d0:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801069d3:	b9 00 00 00 00       	mov    $0x0,%ecx
801069d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801069db:	8b 45 08             	mov    0x8(%ebp),%eax
801069de:	e8 bf f7 ff ff       	call   801061a2 <walkpgdir>
  if((*pte & PTE_P) == 0)
801069e3:	8b 00                	mov    (%eax),%eax
801069e5:	a8 01                	test   $0x1,%al
801069e7:	74 10                	je     801069f9 <uva2ka+0x30>
    return 0;
  if((*pte & PTE_U) == 0)
801069e9:	a8 04                	test   $0x4,%al
801069eb:	74 13                	je     80106a00 <uva2ka+0x37>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801069ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069f2:	05 00 00 00 80       	add    $0x80000000,%eax
}
801069f7:	c9                   	leave  
801069f8:	c3                   	ret    
    return 0;
801069f9:	b8 00 00 00 00       	mov    $0x0,%eax
801069fe:	eb f7                	jmp    801069f7 <uva2ka+0x2e>
    return 0;
80106a00:	b8 00 00 00 00       	mov    $0x0,%eax
80106a05:	eb f0                	jmp    801069f7 <uva2ka+0x2e>

80106a07 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106a07:	f3 0f 1e fb          	endbr32 
80106a0b:	55                   	push   %ebp
80106a0c:	89 e5                	mov    %esp,%ebp
80106a0e:	57                   	push   %edi
80106a0f:	56                   	push   %esi
80106a10:	53                   	push   %ebx
80106a11:	83 ec 0c             	sub    $0xc,%esp
80106a14:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106a17:	eb 25                	jmp    80106a3e <copyout+0x37>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106a19:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a1c:	29 f2                	sub    %esi,%edx
80106a1e:	01 d0                	add    %edx,%eax
80106a20:	83 ec 04             	sub    $0x4,%esp
80106a23:	53                   	push   %ebx
80106a24:	ff 75 10             	pushl  0x10(%ebp)
80106a27:	50                   	push   %eax
80106a28:	e8 14 d5 ff ff       	call   80103f41 <memmove>
    len -= n;
80106a2d:	29 df                	sub    %ebx,%edi
    buf += n;
80106a2f:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106a32:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106a38:	89 45 0c             	mov    %eax,0xc(%ebp)
80106a3b:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106a3e:	85 ff                	test   %edi,%edi
80106a40:	74 2f                	je     80106a71 <copyout+0x6a>
    va0 = (uint)PGROUNDDOWN(va);
80106a42:	8b 75 0c             	mov    0xc(%ebp),%esi
80106a45:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106a4b:	83 ec 08             	sub    $0x8,%esp
80106a4e:	56                   	push   %esi
80106a4f:	ff 75 08             	pushl  0x8(%ebp)
80106a52:	e8 72 ff ff ff       	call   801069c9 <uva2ka>
    if(pa0 == 0)
80106a57:	83 c4 10             	add    $0x10,%esp
80106a5a:	85 c0                	test   %eax,%eax
80106a5c:	74 20                	je     80106a7e <copyout+0x77>
    n = PGSIZE - (va - va0);
80106a5e:	89 f3                	mov    %esi,%ebx
80106a60:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106a63:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106a69:	39 df                	cmp    %ebx,%edi
80106a6b:	73 ac                	jae    80106a19 <copyout+0x12>
      n = len;
80106a6d:	89 fb                	mov    %edi,%ebx
80106a6f:	eb a8                	jmp    80106a19 <copyout+0x12>
  }
  return 0;
80106a71:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a79:	5b                   	pop    %ebx
80106a7a:	5e                   	pop    %esi
80106a7b:	5f                   	pop    %edi
80106a7c:	5d                   	pop    %ebp
80106a7d:	c3                   	ret    
      return -1;
80106a7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a83:	eb f1                	jmp    80106a76 <copyout+0x6f>
