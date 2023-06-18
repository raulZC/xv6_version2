
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
8010002d:	b8 99 2a 10 80       	mov    $0x80102a99,%eax
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
80100046:	e8 0f 3c 00 00       	call   80103c5a <acquire>

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
8010007a:	e8 44 3c 00 00       	call   80103cc3 <release>
      acquiresleep(&b->lock);
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 a1 39 00 00       	call   80103a2b <acquiresleep>
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
801000c8:	e8 f6 3b 00 00       	call   80103cc3 <release>
      acquiresleep(&b->lock);
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 53 39 00 00       	call   80103a2b <acquiresleep>
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
801000e8:	68 00 68 10 80       	push   $0x80106800
801000ed:	e8 63 02 00 00       	call   80100355 <panic>

801000f2 <binit>:
{
801000f2:	f3 0f 1e fb          	endbr32 
801000f6:	55                   	push   %ebp
801000f7:	89 e5                	mov    %esp,%ebp
801000f9:	53                   	push   %ebx
801000fa:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000fd:	68 11 68 10 80       	push   $0x80106811
80100102:	68 c0 b5 10 80       	push   $0x8010b5c0
80100107:	e8 03 3a 00 00       	call   80103b0f <initlock>
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
8010013c:	68 18 68 10 80       	push   $0x80106818
80100141:	8d 43 0c             	lea    0xc(%ebx),%eax
80100144:	50                   	push   %eax
80100145:	e8 aa 38 00 00       	call   801039f4 <initsleeplock>
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
80100196:	e8 9a 1c 00 00       	call   80101e35 <iderw>
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
801001b2:	e8 06 39 00 00       	call   80103abd <holdingsleep>
801001b7:	83 c4 10             	add    $0x10,%esp
801001ba:	85 c0                	test   %eax,%eax
801001bc:	74 14                	je     801001d2 <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001be:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001c1:	83 ec 0c             	sub    $0xc,%esp
801001c4:	53                   	push   %ebx
801001c5:	e8 6b 1c 00 00       	call   80101e35 <iderw>
}
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d0:	c9                   	leave  
801001d1:	c3                   	ret    
    panic("bwrite");
801001d2:	83 ec 0c             	sub    $0xc,%esp
801001d5:	68 1f 68 10 80       	push   $0x8010681f
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
801001f2:	e8 c6 38 00 00       	call   80103abd <holdingsleep>
801001f7:	83 c4 10             	add    $0x10,%esp
801001fa:	85 c0                	test   %eax,%eax
801001fc:	74 69                	je     80100267 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
801001fe:	83 ec 0c             	sub    $0xc,%esp
80100201:	56                   	push   %esi
80100202:	e8 77 38 00 00       	call   80103a7e <releasesleep>

  acquire(&bcache.lock);
80100207:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020e:	e8 47 3a 00 00       	call   80103c5a <acquire>
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
80100258:	e8 66 3a 00 00       	call   80103cc3 <release>
}
8010025d:	83 c4 10             	add    $0x10,%esp
80100260:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100263:	5b                   	pop    %ebx
80100264:	5e                   	pop    %esi
80100265:	5d                   	pop    %ebp
80100266:	c3                   	ret    
    panic("brelse");
80100267:	83 ec 0c             	sub    $0xc,%esp
8010026a:	68 26 68 10 80       	push   $0x80106826
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
8010028b:	e8 ba 13 00 00       	call   8010164a <iunlock>
  target = n;
80100290:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100293:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029a:	e8 bb 39 00 00       	call   80103c5a <acquire>
  while(n > 0){
8010029f:	83 c4 10             	add    $0x10,%esp
801002a2:	85 db                	test   %ebx,%ebx
801002a4:	0f 8e 8c 00 00 00    	jle    80100336 <consoleread+0xc2>
    while(input.r == input.w){
801002aa:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002af:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002b5:	75 47                	jne    801002fe <consoleread+0x8a>
      if(myproc()->killed){
801002b7:	e8 95 2f 00 00       	call   80103251 <myproc>
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
801002cf:	e8 50 34 00 00       	call   80103724 <sleep>
801002d4:	83 c4 10             	add    $0x10,%esp
801002d7:	eb d1                	jmp    801002aa <consoleread+0x36>
        release(&cons.lock);
801002d9:	83 ec 0c             	sub    $0xc,%esp
801002dc:	68 20 a5 10 80       	push   $0x8010a520
801002e1:	e8 dd 39 00 00       	call   80103cc3 <release>
        ilock(ip);
801002e6:	89 3c 24             	mov    %edi,(%esp)
801002e9:	e8 98 12 00 00       	call   80101586 <ilock>
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
8010033e:	e8 80 39 00 00       	call   80103cc3 <release>
  ilock(ip);
80100343:	89 3c 24             	mov    %edi,(%esp)
80100346:	e8 3b 12 00 00       	call   80101586 <ilock>
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
8010036b:	e8 52 20 00 00       	call   801023c2 <lapicid>
80100370:	83 ec 08             	sub    $0x8,%esp
80100373:	50                   	push   %eax
80100374:	68 2d 68 10 80       	push   $0x8010682d
80100379:	e8 7f 02 00 00       	call   801005fd <cprintf>
  cprintf(s);
8010037e:	83 c4 04             	add    $0x4,%esp
80100381:	ff 75 08             	pushl  0x8(%ebp)
80100384:	e8 74 02 00 00       	call   801005fd <cprintf>
  cprintf("\n");
80100389:	c7 04 24 eb 71 10 80 	movl   $0x801071eb,(%esp)
80100390:	e8 68 02 00 00       	call   801005fd <cprintf>
  getcallerpcs(&s, pcs);
80100395:	83 c4 08             	add    $0x8,%esp
80100398:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010039b:	50                   	push   %eax
8010039c:	8d 45 08             	lea    0x8(%ebp),%eax
8010039f:	50                   	push   %eax
801003a0:	e8 89 37 00 00       	call   80103b2e <getcallerpcs>
  for(i=0; i<10; i++)
801003a5:	83 c4 10             	add    $0x10,%esp
801003a8:	bb 00 00 00 00       	mov    $0x0,%ebx
801003ad:	eb 15                	jmp    801003c4 <panic+0x6f>
    cprintf(" %p", pcs[i]);
801003af:	83 ec 08             	sub    $0x8,%esp
801003b2:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003b6:	68 41 68 10 80       	push   $0x80106841
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
8010048b:	68 45 68 10 80       	push   $0x80106845
80100490:	e8 c0 fe ff ff       	call   80100355 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100495:	83 ec 04             	sub    $0x4,%esp
80100498:	68 60 0e 00 00       	push   $0xe60
8010049d:	68 a0 80 0b 80       	push   $0x800b80a0
801004a2:	68 00 80 0b 80       	push   $0x800b8000
801004a7:	e8 e0 38 00 00       	call   80103d8c <memmove>
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
801004c6:	e8 43 38 00 00       	call   80103d0e <memset>
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
801004f3:	e8 83 4e 00 00       	call   8010537b <uartputc>
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
8010050c:	e8 6a 4e 00 00       	call   8010537b <uartputc>
80100511:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100518:	e8 5e 4e 00 00       	call   8010537b <uartputc>
8010051d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100524:	e8 52 4e 00 00       	call   8010537b <uartputc>
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
8010055f:	8a 92 70 68 10 80    	mov    -0x7fef9790(%edx),%dl
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
801005b2:	e8 93 10 00 00       	call   8010164a <iunlock>
  acquire(&cons.lock);
801005b7:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005be:	e8 97 36 00 00       	call   80103c5a <acquire>
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
801005e3:	e8 db 36 00 00       	call   80103cc3 <release>
  ilock(ip);
801005e8:	83 c4 04             	add    $0x4,%esp
801005eb:	ff 75 08             	pushl  0x8(%ebp)
801005ee:	e8 93 0f 00 00       	call   80101586 <ilock>

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
8010062e:	e8 27 36 00 00       	call   80103c5a <acquire>
80100633:	83 c4 10             	add    $0x10,%esp
80100636:	eb de                	jmp    80100616 <cprintf+0x19>
    panic("null fmt");
80100638:	83 ec 0c             	sub    $0xc,%esp
8010063b:	68 5f 68 10 80       	push   $0x8010685f
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
801006c3:	bb 58 68 10 80       	mov    $0x80106858,%ebx
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
8010071c:	e8 a2 35 00 00       	call   80103cc3 <release>
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
8010073b:	e8 1a 35 00 00       	call   80103c5a <acquire>
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
801007e3:	e8 b3 30 00 00       	call   8010389b <wakeup>
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
8010085c:	e8 62 34 00 00       	call   80103cc3 <release>
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
80100870:	e8 cb 30 00 00       	call   80103940 <procdump>
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
80100881:	68 68 68 10 80       	push   $0x80106868
80100886:	68 20 a5 10 80       	push   $0x8010a520
8010088b:	e8 7f 32 00 00       	call   80103b0f <initlock>

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
801008b5:	e8 eb 16 00 00       	call   80101fa5 <ioapicenable>
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
801008cf:	e8 7d 29 00 00       	call   80103251 <myproc>
801008d4:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801008da:	e8 f4 1e 00 00       	call   801027d3 <begin_op>

  if((ip = namei(path)) == 0){
801008df:	83 ec 0c             	sub    $0xc,%esp
801008e2:	ff 75 08             	pushl  0x8(%ebp)
801008e5:	e8 28 13 00 00       	call   80101c12 <namei>
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
801008f7:	e8 8a 0c 00 00       	call   80101586 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801008fc:	6a 34                	push   $0x34
801008fe:	6a 00                	push   $0x0
80100900:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100906:	50                   	push   %eax
80100907:	53                   	push   %ebx
80100908:	e8 7a 0e 00 00       	call   80101787 <readi>
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
80100923:	0f 84 d0 02 00 00    	je     80100bf9 <exec+0x33a>
    iunlockput(ip);
80100929:	83 ec 0c             	sub    $0xc,%esp
8010092c:	53                   	push   %ebx
8010092d:	e8 03 0e 00 00       	call   80101735 <iunlockput>
    end_op();
80100932:	e8 1c 1f 00 00       	call   80102853 <end_op>
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
80100947:	e8 07 1f 00 00       	call   80102853 <end_op>
    cprintf("exec: fail\n");
8010094c:	83 ec 0c             	sub    $0xc,%esp
8010094f:	68 81 68 10 80       	push   $0x80106881
80100954:	e8 a4 fc ff ff       	call   801005fd <cprintf>
    return -1;
80100959:	83 c4 10             	add    $0x10,%esp
8010095c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100961:	eb dc                	jmp    8010093f <exec+0x80>
  if((pgdir = setupkvm()) == 0)
80100963:	e8 10 5c 00 00       	call   80106578 <setupkvm>
80100968:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010096e:	85 c0                	test   %eax,%eax
80100970:	0f 84 14 01 00 00    	je     80100a8a <exec+0x1cb>
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
8010099a:	0f 8e a1 00 00 00    	jle    80100a41 <exec+0x182>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009a0:	89 c7                	mov    %eax,%edi
801009a2:	6a 20                	push   $0x20
801009a4:	50                   	push   %eax
801009a5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009ab:	50                   	push   %eax
801009ac:	53                   	push   %ebx
801009ad:	e8 d5 0d 00 00       	call   80101787 <readi>
801009b2:	83 c4 10             	add    $0x10,%esp
801009b5:	83 f8 20             	cmp    $0x20,%eax
801009b8:	0f 85 cc 00 00 00    	jne    80100a8a <exec+0x1cb>
    if(ph.type != ELF_PROG_LOAD || ph.memsz == 0)
801009be:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801009c5:	75 c6                	jne    8010098d <exec+0xce>
801009c7:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801009cd:	85 c0                	test   %eax,%eax
801009cf:	74 bc                	je     8010098d <exec+0xce>
    if(ph.memsz < ph.filesz)
801009d1:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009d7:	0f 82 ad 00 00 00    	jb     80100a8a <exec+0x1cb>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009dd:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009e3:	0f 82 a1 00 00 00    	jb     80100a8a <exec+0x1cb>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009e9:	83 ec 04             	sub    $0x4,%esp
801009ec:	50                   	push   %eax
801009ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801009f3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801009f9:	e8 10 5a 00 00       	call   8010640e <allocuvm>
801009fe:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a04:	83 c4 10             	add    $0x10,%esp
80100a07:	85 c0                	test   %eax,%eax
80100a09:	74 7f                	je     80100a8a <exec+0x1cb>
    if(ph.vaddr % PGSIZE != 0)
80100a0b:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a11:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a16:	75 72                	jne    80100a8a <exec+0x1cb>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a18:	83 ec 0c             	sub    $0xc,%esp
80100a1b:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a21:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a27:	53                   	push   %ebx
80100a28:	50                   	push   %eax
80100a29:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100a2f:	e8 a8 58 00 00       	call   801062dc <loaduvm>
80100a34:	83 c4 20             	add    $0x20,%esp
80100a37:	85 c0                	test   %eax,%eax
80100a39:	0f 89 4e ff ff ff    	jns    8010098d <exec+0xce>
80100a3f:	eb 49                	jmp    80100a8a <exec+0x1cb>
  iunlockput(ip);
80100a41:	83 ec 0c             	sub    $0xc,%esp
80100a44:	53                   	push   %ebx
80100a45:	e8 eb 0c 00 00       	call   80101735 <iunlockput>
  end_op();
80100a4a:	e8 04 1e 00 00       	call   80102853 <end_op>
  sz = PGROUNDUP(sz);
80100a4f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a55:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a5f:	83 c4 0c             	add    $0xc,%esp
80100a62:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a68:	52                   	push   %edx
80100a69:	50                   	push   %eax
80100a6a:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100a70:	56                   	push   %esi
80100a71:	e8 98 59 00 00       	call   8010640e <allocuvm>
80100a76:	89 c7                	mov    %eax,%edi
80100a78:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a7e:	83 c4 10             	add    $0x10,%esp
80100a81:	85 c0                	test   %eax,%eax
80100a83:	75 26                	jne    80100aab <exec+0x1ec>
  ip = 0;
80100a85:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100a8a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a90:	85 c0                	test   %eax,%eax
80100a92:	0f 84 89 fe ff ff    	je     80100921 <exec+0x62>
    freevm(pgdir, 1);
80100a98:	83 ec 08             	sub    $0x8,%esp
80100a9b:	6a 01                	push   $0x1
80100a9d:	50                   	push   %eax
80100a9e:	e8 5b 5a 00 00       	call   801064fe <freevm>
80100aa3:	83 c4 10             	add    $0x10,%esp
80100aa6:	e9 76 fe ff ff       	jmp    80100921 <exec+0x62>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100aab:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ab1:	83 ec 08             	sub    $0x8,%esp
80100ab4:	50                   	push   %eax
80100ab5:	56                   	push   %esi
80100ab6:	e8 4c 5b 00 00       	call   80106607 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100abb:	83 c4 10             	add    $0x10,%esp
80100abe:	be 00 00 00 00       	mov    $0x0,%esi
80100ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ac6:	8d 1c b0             	lea    (%eax,%esi,4),%ebx
80100ac9:	8b 03                	mov    (%ebx),%eax
80100acb:	85 c0                	test   %eax,%eax
80100acd:	74 47                	je     80100b16 <exec+0x257>
    if(argc >= MAXARG)
80100acf:	83 fe 1f             	cmp    $0x1f,%esi
80100ad2:	0f 87 0d 01 00 00    	ja     80100be5 <exec+0x326>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ad8:	83 ec 0c             	sub    $0xc,%esp
80100adb:	50                   	push   %eax
80100adc:	e8 d5 33 00 00       	call   80103eb6 <strlen>
80100ae1:	29 c7                	sub    %eax,%edi
80100ae3:	4f                   	dec    %edi
80100ae4:	83 e7 fc             	and    $0xfffffffc,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ae7:	83 c4 04             	add    $0x4,%esp
80100aea:	ff 33                	pushl  (%ebx)
80100aec:	e8 c5 33 00 00       	call   80103eb6 <strlen>
80100af1:	40                   	inc    %eax
80100af2:	50                   	push   %eax
80100af3:	ff 33                	pushl  (%ebx)
80100af5:	57                   	push   %edi
80100af6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100afc:	e8 62 5c 00 00       	call   80106763 <copyout>
80100b01:	83 c4 20             	add    $0x20,%esp
80100b04:	85 c0                	test   %eax,%eax
80100b06:	0f 88 e3 00 00 00    	js     80100bef <exec+0x330>
    ustack[3+argc] = sp;
80100b0c:	89 bc b5 64 ff ff ff 	mov    %edi,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b13:	46                   	inc    %esi
80100b14:	eb ad                	jmp    80100ac3 <exec+0x204>
80100b16:	89 f9                	mov    %edi,%ecx
80100b18:	89 c3                	mov    %eax,%ebx
  ustack[3+argc] = 0;
80100b1a:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100b21:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b25:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b2c:	ff ff ff 
  ustack[1] = argc;
80100b2f:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b35:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100b3c:	89 fa                	mov    %edi,%edx
80100b3e:	29 c2                	sub    %eax,%edx
80100b40:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b46:	8d 04 b5 10 00 00 00 	lea    0x10(,%esi,4),%eax
80100b4d:	29 c1                	sub    %eax,%ecx
80100b4f:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b51:	50                   	push   %eax
80100b52:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b58:	50                   	push   %eax
80100b59:	51                   	push   %ecx
80100b5a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b60:	e8 fe 5b 00 00       	call   80106763 <copyout>
80100b65:	83 c4 10             	add    $0x10,%esp
80100b68:	85 c0                	test   %eax,%eax
80100b6a:	0f 88 1a ff ff ff    	js     80100a8a <exec+0x1cb>
  for(last=s=path; *s; s++)
80100b70:	8b 55 08             	mov    0x8(%ebp),%edx
80100b73:	89 d0                	mov    %edx,%eax
80100b75:	eb 01                	jmp    80100b78 <exec+0x2b9>
80100b77:	40                   	inc    %eax
80100b78:	8a 08                	mov    (%eax),%cl
80100b7a:	84 c9                	test   %cl,%cl
80100b7c:	74 0a                	je     80100b88 <exec+0x2c9>
    if(*s == '/')
80100b7e:	80 f9 2f             	cmp    $0x2f,%cl
80100b81:	75 f4                	jne    80100b77 <exec+0x2b8>
      last = s+1;
80100b83:	8d 50 01             	lea    0x1(%eax),%edx
80100b86:	eb ef                	jmp    80100b77 <exec+0x2b8>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100b88:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b8e:	89 f8                	mov    %edi,%eax
80100b90:	83 c0 6c             	add    $0x6c,%eax
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	6a 10                	push   $0x10
80100b98:	52                   	push   %edx
80100b99:	50                   	push   %eax
80100b9a:	e8 db 32 00 00       	call   80103e7a <safestrcpy>
  oldpgdir = curproc->pgdir;
80100b9f:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100ba2:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100ba8:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100bab:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100bb1:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100bb3:	8b 47 18             	mov    0x18(%edi),%eax
80100bb6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bbc:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bbf:	8b 47 18             	mov    0x18(%edi),%eax
80100bc2:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100bc5:	89 3c 24             	mov    %edi,(%esp)
80100bc8:	e8 8a 55 00 00       	call   80106157 <switchuvm>
  freevm(oldpgdir, 1);
80100bcd:	83 c4 08             	add    $0x8,%esp
80100bd0:	6a 01                	push   $0x1
80100bd2:	53                   	push   %ebx
80100bd3:	e8 26 59 00 00       	call   801064fe <freevm>
  return 0;
80100bd8:	83 c4 10             	add    $0x10,%esp
80100bdb:	b8 00 00 00 00       	mov    $0x0,%eax
80100be0:	e9 5a fd ff ff       	jmp    8010093f <exec+0x80>
  ip = 0;
80100be5:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bea:	e9 9b fe ff ff       	jmp    80100a8a <exec+0x1cb>
80100bef:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bf4:	e9 91 fe ff ff       	jmp    80100a8a <exec+0x1cb>
  return -1;
80100bf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bfe:	e9 3c fd ff ff       	jmp    8010093f <exec+0x80>

80100c03 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c03:	f3 0f 1e fb          	endbr32 
80100c07:	55                   	push   %ebp
80100c08:	89 e5                	mov    %esp,%ebp
80100c0a:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c0d:	68 8d 68 10 80       	push   $0x8010688d
80100c12:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c17:	e8 f3 2e 00 00       	call   80103b0f <initlock>
}
80100c1c:	83 c4 10             	add    $0x10,%esp
80100c1f:	c9                   	leave  
80100c20:	c3                   	ret    

80100c21 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c21:	f3 0f 1e fb          	endbr32 
80100c25:	55                   	push   %ebp
80100c26:	89 e5                	mov    %esp,%ebp
80100c28:	53                   	push   %ebx
80100c29:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c2c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c31:	e8 24 30 00 00       	call   80103c5a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c36:	83 c4 10             	add    $0x10,%esp
80100c39:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100c3e:	eb 03                	jmp    80100c43 <filealloc+0x22>
80100c40:	83 c3 18             	add    $0x18,%ebx
80100c43:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100c49:	73 24                	jae    80100c6f <filealloc+0x4e>
    if(f->ref == 0){
80100c4b:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c4f:	75 ef                	jne    80100c40 <filealloc+0x1f>
      f->ref = 1;
80100c51:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c58:	83 ec 0c             	sub    $0xc,%esp
80100c5b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c60:	e8 5e 30 00 00       	call   80103cc3 <release>
      return f;
80100c65:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c68:	89 d8                	mov    %ebx,%eax
80100c6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c6d:	c9                   	leave  
80100c6e:	c3                   	ret    
  release(&ftable.lock);
80100c6f:	83 ec 0c             	sub    $0xc,%esp
80100c72:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c77:	e8 47 30 00 00       	call   80103cc3 <release>
  return 0;
80100c7c:	83 c4 10             	add    $0x10,%esp
80100c7f:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c84:	eb e2                	jmp    80100c68 <filealloc+0x47>

80100c86 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100c86:	f3 0f 1e fb          	endbr32 
80100c8a:	55                   	push   %ebp
80100c8b:	89 e5                	mov    %esp,%ebp
80100c8d:	53                   	push   %ebx
80100c8e:	83 ec 10             	sub    $0x10,%esp
80100c91:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100c94:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c99:	e8 bc 2f 00 00       	call   80103c5a <acquire>
  if(f->ref < 1)
80100c9e:	8b 43 04             	mov    0x4(%ebx),%eax
80100ca1:	83 c4 10             	add    $0x10,%esp
80100ca4:	85 c0                	test   %eax,%eax
80100ca6:	7e 18                	jle    80100cc0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
80100ca8:	40                   	inc    %eax
80100ca9:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100cac:	83 ec 0c             	sub    $0xc,%esp
80100caf:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cb4:	e8 0a 30 00 00       	call   80103cc3 <release>
  return f;
}
80100cb9:	89 d8                	mov    %ebx,%eax
80100cbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cbe:	c9                   	leave  
80100cbf:	c3                   	ret    
    panic("filedup");
80100cc0:	83 ec 0c             	sub    $0xc,%esp
80100cc3:	68 94 68 10 80       	push   $0x80106894
80100cc8:	e8 88 f6 ff ff       	call   80100355 <panic>

80100ccd <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ccd:	f3 0f 1e fb          	endbr32 
80100cd1:	55                   	push   %ebp
80100cd2:	89 e5                	mov    %esp,%ebp
80100cd4:	57                   	push   %edi
80100cd5:	56                   	push   %esi
80100cd6:	53                   	push   %ebx
80100cd7:	83 ec 38             	sub    $0x38,%esp
80100cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100cdd:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ce2:	e8 73 2f 00 00       	call   80103c5a <acquire>
  if(f->ref < 1)
80100ce7:	8b 43 04             	mov    0x4(%ebx),%eax
80100cea:	83 c4 10             	add    $0x10,%esp
80100ced:	85 c0                	test   %eax,%eax
80100cef:	7e 58                	jle    80100d49 <fileclose+0x7c>
    panic("fileclose");
  if(--f->ref > 0){
80100cf1:	48                   	dec    %eax
80100cf2:	89 43 04             	mov    %eax,0x4(%ebx)
80100cf5:	85 c0                	test   %eax,%eax
80100cf7:	7f 5d                	jg     80100d56 <fileclose+0x89>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100cf9:	8d 7d d0             	lea    -0x30(%ebp),%edi
80100cfc:	b9 06 00 00 00       	mov    $0x6,%ecx
80100d01:	89 de                	mov    %ebx,%esi
80100d03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80100d05:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d0c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d12:	83 ec 0c             	sub    $0xc,%esp
80100d15:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d1a:	e8 a4 2f 00 00       	call   80103cc3 <release>

  if(ff.type == FD_PIPE)
80100d1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100d22:	83 c4 10             	add    $0x10,%esp
80100d25:	83 f8 01             	cmp    $0x1,%eax
80100d28:	74 44                	je     80100d6e <fileclose+0xa1>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d2a:	83 f8 02             	cmp    $0x2,%eax
80100d2d:	75 37                	jne    80100d66 <fileclose+0x99>
    begin_op();
80100d2f:	e8 9f 1a 00 00       	call   801027d3 <begin_op>
    iput(ff.ip);
80100d34:	83 ec 0c             	sub    $0xc,%esp
80100d37:	ff 75 e0             	pushl  -0x20(%ebp)
80100d3a:	e8 54 09 00 00       	call   80101693 <iput>
    end_op();
80100d3f:	e8 0f 1b 00 00       	call   80102853 <end_op>
80100d44:	83 c4 10             	add    $0x10,%esp
80100d47:	eb 1d                	jmp    80100d66 <fileclose+0x99>
    panic("fileclose");
80100d49:	83 ec 0c             	sub    $0xc,%esp
80100d4c:	68 9c 68 10 80       	push   $0x8010689c
80100d51:	e8 ff f5 ff ff       	call   80100355 <panic>
    release(&ftable.lock);
80100d56:	83 ec 0c             	sub    $0xc,%esp
80100d59:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d5e:	e8 60 2f 00 00       	call   80103cc3 <release>
    return;
80100d63:	83 c4 10             	add    $0x10,%esp
  }
}
80100d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d69:	5b                   	pop    %ebx
80100d6a:	5e                   	pop    %esi
80100d6b:	5f                   	pop    %edi
80100d6c:	5d                   	pop    %ebp
80100d6d:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100d6e:	83 ec 08             	sub    $0x8,%esp
80100d71:	0f be 45 d9          	movsbl -0x27(%ebp),%eax
80100d75:	50                   	push   %eax
80100d76:	ff 75 dc             	pushl  -0x24(%ebp)
80100d79:	e8 d6 20 00 00       	call   80102e54 <pipeclose>
80100d7e:	83 c4 10             	add    $0x10,%esp
80100d81:	eb e3                	jmp    80100d66 <fileclose+0x99>

80100d83 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100d83:	f3 0f 1e fb          	endbr32 
80100d87:	55                   	push   %ebp
80100d88:	89 e5                	mov    %esp,%ebp
80100d8a:	53                   	push   %ebx
80100d8b:	83 ec 04             	sub    $0x4,%esp
80100d8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100d91:	83 3b 02             	cmpl   $0x2,(%ebx)
80100d94:	75 31                	jne    80100dc7 <filestat+0x44>
    ilock(f->ip);
80100d96:	83 ec 0c             	sub    $0xc,%esp
80100d99:	ff 73 10             	pushl  0x10(%ebx)
80100d9c:	e8 e5 07 00 00       	call   80101586 <ilock>
    stati(f->ip, st);
80100da1:	83 c4 08             	add    $0x8,%esp
80100da4:	ff 75 0c             	pushl  0xc(%ebp)
80100da7:	ff 73 10             	pushl  0x10(%ebx)
80100daa:	e8 aa 09 00 00       	call   80101759 <stati>
    iunlock(f->ip);
80100daf:	83 c4 04             	add    $0x4,%esp
80100db2:	ff 73 10             	pushl  0x10(%ebx)
80100db5:	e8 90 08 00 00       	call   8010164a <iunlock>
    return 0;
80100dba:	83 c4 10             	add    $0x10,%esp
80100dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100dc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dc5:	c9                   	leave  
80100dc6:	c3                   	ret    
  return -1;
80100dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dcc:	eb f4                	jmp    80100dc2 <filestat+0x3f>

80100dce <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100dce:	f3 0f 1e fb          	endbr32 
80100dd2:	55                   	push   %ebp
80100dd3:	89 e5                	mov    %esp,%ebp
80100dd5:	56                   	push   %esi
80100dd6:	53                   	push   %ebx
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100dda:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100dde:	74 70                	je     80100e50 <fileread+0x82>
    return -1;
  if(f->type == FD_PIPE)
80100de0:	8b 03                	mov    (%ebx),%eax
80100de2:	83 f8 01             	cmp    $0x1,%eax
80100de5:	74 44                	je     80100e2b <fileread+0x5d>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100de7:	83 f8 02             	cmp    $0x2,%eax
80100dea:	75 57                	jne    80100e43 <fileread+0x75>
    ilock(f->ip);
80100dec:	83 ec 0c             	sub    $0xc,%esp
80100def:	ff 73 10             	pushl  0x10(%ebx)
80100df2:	e8 8f 07 00 00       	call   80101586 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100df7:	ff 75 10             	pushl  0x10(%ebp)
80100dfa:	ff 73 14             	pushl  0x14(%ebx)
80100dfd:	ff 75 0c             	pushl  0xc(%ebp)
80100e00:	ff 73 10             	pushl  0x10(%ebx)
80100e03:	e8 7f 09 00 00       	call   80101787 <readi>
80100e08:	89 c6                	mov    %eax,%esi
80100e0a:	83 c4 20             	add    $0x20,%esp
80100e0d:	85 c0                	test   %eax,%eax
80100e0f:	7e 03                	jle    80100e14 <fileread+0x46>
      f->off += r;
80100e11:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e14:	83 ec 0c             	sub    $0xc,%esp
80100e17:	ff 73 10             	pushl  0x10(%ebx)
80100e1a:	e8 2b 08 00 00       	call   8010164a <iunlock>
    return r;
80100e1f:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e22:	89 f0                	mov    %esi,%eax
80100e24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e27:	5b                   	pop    %ebx
80100e28:	5e                   	pop    %esi
80100e29:	5d                   	pop    %ebp
80100e2a:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e2b:	83 ec 04             	sub    $0x4,%esp
80100e2e:	ff 75 10             	pushl  0x10(%ebp)
80100e31:	ff 75 0c             	pushl  0xc(%ebp)
80100e34:	ff 73 0c             	pushl  0xc(%ebx)
80100e37:	e8 72 21 00 00       	call   80102fae <piperead>
80100e3c:	89 c6                	mov    %eax,%esi
80100e3e:	83 c4 10             	add    $0x10,%esp
80100e41:	eb df                	jmp    80100e22 <fileread+0x54>
  panic("fileread");
80100e43:	83 ec 0c             	sub    $0xc,%esp
80100e46:	68 a6 68 10 80       	push   $0x801068a6
80100e4b:	e8 05 f5 ff ff       	call   80100355 <panic>
    return -1;
80100e50:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e55:	eb cb                	jmp    80100e22 <fileread+0x54>

80100e57 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e57:	f3 0f 1e fb          	endbr32 
80100e5b:	55                   	push   %ebp
80100e5c:	89 e5                	mov    %esp,%ebp
80100e5e:	57                   	push   %edi
80100e5f:	56                   	push   %esi
80100e60:	53                   	push   %ebx
80100e61:	83 ec 1c             	sub    $0x1c,%esp
80100e64:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100e67:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e6b:	0f 84 cc 00 00 00    	je     80100f3d <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100e71:	8b 06                	mov    (%esi),%eax
80100e73:	83 f8 01             	cmp    $0x1,%eax
80100e76:	74 10                	je     80100e88 <filewrite+0x31>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e78:	83 f8 02             	cmp    $0x2,%eax
80100e7b:	0f 85 af 00 00 00    	jne    80100f30 <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100e81:	bf 00 00 00 00       	mov    $0x0,%edi
80100e86:	eb 67                	jmp    80100eef <filewrite+0x98>
    return pipewrite(f->pipe, addr, n);
80100e88:	83 ec 04             	sub    $0x4,%esp
80100e8b:	ff 75 10             	pushl  0x10(%ebp)
80100e8e:	ff 75 0c             	pushl  0xc(%ebp)
80100e91:	ff 76 0c             	pushl  0xc(%esi)
80100e94:	e8 4b 20 00 00       	call   80102ee4 <pipewrite>
80100e99:	83 c4 10             	add    $0x10,%esp
80100e9c:	e9 82 00 00 00       	jmp    80100f23 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100ea1:	e8 2d 19 00 00       	call   801027d3 <begin_op>
      ilock(f->ip);
80100ea6:	83 ec 0c             	sub    $0xc,%esp
80100ea9:	ff 76 10             	pushl  0x10(%esi)
80100eac:	e8 d5 06 00 00       	call   80101586 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100eb1:	ff 75 e4             	pushl  -0x1c(%ebp)
80100eb4:	ff 76 14             	pushl  0x14(%esi)
80100eb7:	89 f8                	mov    %edi,%eax
80100eb9:	03 45 0c             	add    0xc(%ebp),%eax
80100ebc:	50                   	push   %eax
80100ebd:	ff 76 10             	pushl  0x10(%esi)
80100ec0:	e8 c6 09 00 00       	call   8010188b <writei>
80100ec5:	89 c3                	mov    %eax,%ebx
80100ec7:	83 c4 20             	add    $0x20,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	7e 03                	jle    80100ed1 <filewrite+0x7a>
        f->off += r;
80100ece:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100ed1:	83 ec 0c             	sub    $0xc,%esp
80100ed4:	ff 76 10             	pushl  0x10(%esi)
80100ed7:	e8 6e 07 00 00       	call   8010164a <iunlock>
      end_op();
80100edc:	e8 72 19 00 00       	call   80102853 <end_op>

      if(r < 0)
80100ee1:	83 c4 10             	add    $0x10,%esp
80100ee4:	85 db                	test   %ebx,%ebx
80100ee6:	78 31                	js     80100f19 <filewrite+0xc2>
        break;
      if(r != n1)
80100ee8:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100eeb:	75 1f                	jne    80100f0c <filewrite+0xb5>
        panic("short filewrite");
      i += r;
80100eed:	01 df                	add    %ebx,%edi
    while(i < n){
80100eef:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100ef2:	7d 25                	jge    80100f19 <filewrite+0xc2>
      int n1 = n - i;
80100ef4:	8b 45 10             	mov    0x10(%ebp),%eax
80100ef7:	29 f8                	sub    %edi,%eax
80100ef9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100efc:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f01:	7e 9e                	jle    80100ea1 <filewrite+0x4a>
        n1 = max;
80100f03:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100f0a:	eb 95                	jmp    80100ea1 <filewrite+0x4a>
        panic("short filewrite");
80100f0c:	83 ec 0c             	sub    $0xc,%esp
80100f0f:	68 af 68 10 80       	push   $0x801068af
80100f14:	e8 3c f4 ff ff       	call   80100355 <panic>
    }
    return i == n ? n : -1;
80100f19:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f1c:	74 0d                	je     80100f2b <filewrite+0xd4>
80100f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f26:	5b                   	pop    %ebx
80100f27:	5e                   	pop    %esi
80100f28:	5f                   	pop    %edi
80100f29:	5d                   	pop    %ebp
80100f2a:	c3                   	ret    
    return i == n ? n : -1;
80100f2b:	8b 45 10             	mov    0x10(%ebp),%eax
80100f2e:	eb f3                	jmp    80100f23 <filewrite+0xcc>
  panic("filewrite");
80100f30:	83 ec 0c             	sub    $0xc,%esp
80100f33:	68 b5 68 10 80       	push   $0x801068b5
80100f38:	e8 18 f4 ff ff       	call   80100355 <panic>
    return -1;
80100f3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f42:	eb df                	jmp    80100f23 <filewrite+0xcc>

80100f44 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f44:	55                   	push   %ebp
80100f45:	89 e5                	mov    %esp,%ebp
80100f47:	57                   	push   %edi
80100f48:	56                   	push   %esi
80100f49:	53                   	push   %ebx
80100f4a:	83 ec 0c             	sub    $0xc,%esp
80100f4d:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f4f:	8a 10                	mov    (%eax),%dl
80100f51:	80 fa 2f             	cmp    $0x2f,%dl
80100f54:	75 03                	jne    80100f59 <skipelem+0x15>
    path++;
80100f56:	40                   	inc    %eax
80100f57:	eb f6                	jmp    80100f4f <skipelem+0xb>
  if(*path == 0)
80100f59:	84 d2                	test   %dl,%dl
80100f5b:	74 4e                	je     80100fab <skipelem+0x67>
80100f5d:	89 c3                	mov    %eax,%ebx
80100f5f:	eb 01                	jmp    80100f62 <skipelem+0x1e>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f61:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80100f62:	8a 13                	mov    (%ebx),%dl
80100f64:	80 fa 2f             	cmp    $0x2f,%dl
80100f67:	74 04                	je     80100f6d <skipelem+0x29>
80100f69:	84 d2                	test   %dl,%dl
80100f6b:	75 f4                	jne    80100f61 <skipelem+0x1d>
  len = path - s;
80100f6d:	89 df                	mov    %ebx,%edi
80100f6f:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100f71:	83 ff 0d             	cmp    $0xd,%edi
80100f74:	7e 11                	jle    80100f87 <skipelem+0x43>
    memmove(name, s, DIRSIZ);
80100f76:	83 ec 04             	sub    $0x4,%esp
80100f79:	6a 0e                	push   $0xe
80100f7b:	50                   	push   %eax
80100f7c:	56                   	push   %esi
80100f7d:	e8 0a 2e 00 00       	call   80103d8c <memmove>
80100f82:	83 c4 10             	add    $0x10,%esp
80100f85:	eb 15                	jmp    80100f9c <skipelem+0x58>
  else {
    memmove(name, s, len);
80100f87:	83 ec 04             	sub    $0x4,%esp
80100f8a:	57                   	push   %edi
80100f8b:	50                   	push   %eax
80100f8c:	56                   	push   %esi
80100f8d:	e8 fa 2d 00 00       	call   80103d8c <memmove>
    name[len] = 0;
80100f92:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100f96:	83 c4 10             	add    $0x10,%esp
80100f99:	eb 01                	jmp    80100f9c <skipelem+0x58>
  }
  while(*path == '/')
    path++;
80100f9b:	43                   	inc    %ebx
  while(*path == '/')
80100f9c:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100f9f:	74 fa                	je     80100f9b <skipelem+0x57>
  return path;
}
80100fa1:	89 d8                	mov    %ebx,%eax
80100fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa6:	5b                   	pop    %ebx
80100fa7:	5e                   	pop    %esi
80100fa8:	5f                   	pop    %edi
80100fa9:	5d                   	pop    %ebp
80100faa:	c3                   	ret    
    return 0;
80100fab:	bb 00 00 00 00       	mov    $0x0,%ebx
80100fb0:	eb ef                	jmp    80100fa1 <skipelem+0x5d>

80100fb2 <bzero>:
{
80100fb2:	55                   	push   %ebp
80100fb3:	89 e5                	mov    %esp,%ebp
80100fb5:	53                   	push   %ebx
80100fb6:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100fb9:	52                   	push   %edx
80100fba:	50                   	push   %eax
80100fbb:	e8 ae f1 ff ff       	call   8010016e <bread>
80100fc0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80100fc2:	8d 40 5c             	lea    0x5c(%eax),%eax
80100fc5:	83 c4 0c             	add    $0xc,%esp
80100fc8:	68 00 02 00 00       	push   $0x200
80100fcd:	6a 00                	push   $0x0
80100fcf:	50                   	push   %eax
80100fd0:	e8 39 2d 00 00       	call   80103d0e <memset>
  log_write(bp);
80100fd5:	89 1c 24             	mov    %ebx,(%esp)
80100fd8:	e8 27 19 00 00       	call   80102904 <log_write>
  brelse(bp);
80100fdd:	89 1c 24             	mov    %ebx,(%esp)
80100fe0:	e8 fa f1 ff ff       	call   801001df <brelse>
}
80100fe5:	83 c4 10             	add    $0x10,%esp
80100fe8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100feb:	c9                   	leave  
80100fec:	c3                   	ret    

80100fed <balloc>:
{
80100fed:	55                   	push   %ebp
80100fee:	89 e5                	mov    %esp,%ebp
80100ff0:	57                   	push   %edi
80100ff1:	56                   	push   %esi
80100ff2:	53                   	push   %ebx
80100ff3:	83 ec 1c             	sub    $0x1c,%esp
80100ff6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80100ff9:	bf 00 00 00 00       	mov    $0x0,%edi
80100ffe:	eb 6d                	jmp    8010106d <balloc+0x80>
    bp = bread(dev, BBLOCK(b, sb));
80101000:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80101006:	eb 73                	jmp    8010107b <balloc+0x8e>
      m = 1 << (bi % 8);
80101008:	49                   	dec    %ecx
80101009:	83 c9 f8             	or     $0xfffffff8,%ecx
8010100c:	41                   	inc    %ecx
8010100d:	eb 38                	jmp    80101047 <balloc+0x5a>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010100f:	c1 f9 03             	sar    $0x3,%ecx
80101012:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80101015:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101018:	8a 4c 0e 5c          	mov    0x5c(%esi,%ecx,1),%cl
8010101c:	0f b6 f1             	movzbl %cl,%esi
8010101f:	85 d6                	test   %edx,%esi
80101021:	0f 84 83 00 00 00    	je     801010aa <balloc+0xbd>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101027:	40                   	inc    %eax
80101028:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010102d:	7f 2a                	jg     80101059 <balloc+0x6c>
8010102f:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80101032:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80101035:	3b 1d c0 09 11 80    	cmp    0x801109c0,%ebx
8010103b:	73 1c                	jae    80101059 <balloc+0x6c>
      m = 1 << (bi % 8);
8010103d:	89 c1                	mov    %eax,%ecx
8010103f:	81 e1 07 00 00 80    	and    $0x80000007,%ecx
80101045:	78 c1                	js     80101008 <balloc+0x1b>
80101047:	ba 01 00 00 00       	mov    $0x1,%edx
8010104c:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010104e:	89 c1                	mov    %eax,%ecx
80101050:	85 c0                	test   %eax,%eax
80101052:	79 bb                	jns    8010100f <balloc+0x22>
80101054:	8d 48 07             	lea    0x7(%eax),%ecx
80101057:	eb b6                	jmp    8010100f <balloc+0x22>
    brelse(bp);
80101059:	83 ec 0c             	sub    $0xc,%esp
8010105c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010105f:	e8 7b f1 ff ff       	call   801001df <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101064:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010106a:	83 c4 10             	add    $0x10,%esp
8010106d:	39 3d c0 09 11 80    	cmp    %edi,0x801109c0
80101073:	76 28                	jbe    8010109d <balloc+0xb0>
    bp = bread(dev, BBLOCK(b, sb));
80101075:	89 f8                	mov    %edi,%eax
80101077:	85 ff                	test   %edi,%edi
80101079:	78 85                	js     80101000 <balloc+0x13>
8010107b:	c1 f8 0c             	sar    $0xc,%eax
8010107e:	83 ec 08             	sub    $0x8,%esp
80101081:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101087:	50                   	push   %eax
80101088:	ff 75 d8             	pushl  -0x28(%ebp)
8010108b:	e8 de f0 ff ff       	call   8010016e <bread>
80101090:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101093:	83 c4 10             	add    $0x10,%esp
80101096:	b8 00 00 00 00       	mov    $0x0,%eax
8010109b:	eb 8b                	jmp    80101028 <balloc+0x3b>
  panic("balloc: out of blocks");
8010109d:	83 ec 0c             	sub    $0xc,%esp
801010a0:	68 bf 68 10 80       	push   $0x801068bf
801010a5:	e8 ab f2 ff ff       	call   80100355 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
801010aa:	09 ca                	or     %ecx,%edx
801010ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010af:	8b 7d dc             	mov    -0x24(%ebp),%edi
801010b2:	88 54 38 5c          	mov    %dl,0x5c(%eax,%edi,1)
        log_write(bp);
801010b6:	83 ec 0c             	sub    $0xc,%esp
801010b9:	89 c7                	mov    %eax,%edi
801010bb:	50                   	push   %eax
801010bc:	e8 43 18 00 00       	call   80102904 <log_write>
        brelse(bp);
801010c1:	89 3c 24             	mov    %edi,(%esp)
801010c4:	e8 16 f1 ff ff       	call   801001df <brelse>
        bzero(dev, b + bi);
801010c9:	89 da                	mov    %ebx,%edx
801010cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801010ce:	e8 df fe ff ff       	call   80100fb2 <bzero>
}
801010d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
801010dd:	c3                   	ret    

801010de <bmap>:
{
801010de:	55                   	push   %ebp
801010df:	89 e5                	mov    %esp,%ebp
801010e1:	57                   	push   %edi
801010e2:	56                   	push   %esi
801010e3:	53                   	push   %ebx
801010e4:	83 ec 1c             	sub    $0x1c,%esp
801010e7:	89 c3                	mov    %eax,%ebx
801010e9:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
801010eb:	83 fa 0b             	cmp    $0xb,%edx
801010ee:	76 45                	jbe    80101135 <bmap+0x57>
  bn -= NDIRECT;
801010f0:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801010f3:	83 fe 7f             	cmp    $0x7f,%esi
801010f6:	77 7f                	ja     80101177 <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
801010f8:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801010fe:	85 c0                	test   %eax,%eax
80101100:	74 4a                	je     8010114c <bmap+0x6e>
    bp = bread(ip->dev, addr);
80101102:	83 ec 08             	sub    $0x8,%esp
80101105:	50                   	push   %eax
80101106:	ff 33                	pushl  (%ebx)
80101108:	e8 61 f0 ff ff       	call   8010016e <bread>
8010110d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010110f:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
80101113:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101116:	8b 30                	mov    (%eax),%esi
80101118:	83 c4 10             	add    $0x10,%esp
8010111b:	85 f6                	test   %esi,%esi
8010111d:	74 3c                	je     8010115b <bmap+0x7d>
    brelse(bp);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	57                   	push   %edi
80101123:	e8 b7 f0 ff ff       	call   801001df <brelse>
    return addr;
80101128:	83 c4 10             	add    $0x10,%esp
}
8010112b:	89 f0                	mov    %esi,%eax
8010112d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101130:	5b                   	pop    %ebx
80101131:	5e                   	pop    %esi
80101132:	5f                   	pop    %edi
80101133:	5d                   	pop    %ebp
80101134:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
80101135:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
80101139:	85 f6                	test   %esi,%esi
8010113b:	75 ee                	jne    8010112b <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010113d:	8b 00                	mov    (%eax),%eax
8010113f:	e8 a9 fe ff ff       	call   80100fed <balloc>
80101144:	89 c6                	mov    %eax,%esi
80101146:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
8010114a:	eb df                	jmp    8010112b <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
8010114c:	8b 03                	mov    (%ebx),%eax
8010114e:	e8 9a fe ff ff       	call   80100fed <balloc>
80101153:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101159:	eb a7                	jmp    80101102 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
8010115b:	8b 03                	mov    (%ebx),%eax
8010115d:	e8 8b fe ff ff       	call   80100fed <balloc>
80101162:	89 c6                	mov    %eax,%esi
80101164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101167:	89 30                	mov    %esi,(%eax)
      log_write(bp);
80101169:	83 ec 0c             	sub    $0xc,%esp
8010116c:	57                   	push   %edi
8010116d:	e8 92 17 00 00       	call   80102904 <log_write>
80101172:	83 c4 10             	add    $0x10,%esp
80101175:	eb a8                	jmp    8010111f <bmap+0x41>
  panic("bmap: out of range");
80101177:	83 ec 0c             	sub    $0xc,%esp
8010117a:	68 d5 68 10 80       	push   $0x801068d5
8010117f:	e8 d1 f1 ff ff       	call   80100355 <panic>

80101184 <iget>:
{
80101184:	55                   	push   %ebp
80101185:	89 e5                	mov    %esp,%ebp
80101187:	57                   	push   %edi
80101188:	56                   	push   %esi
80101189:	53                   	push   %ebx
8010118a:	83 ec 28             	sub    $0x28,%esp
8010118d:	89 c7                	mov    %eax,%edi
8010118f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101192:	68 e0 09 11 80       	push   $0x801109e0
80101197:	e8 be 2a 00 00       	call   80103c5a <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010119c:	83 c4 10             	add    $0x10,%esp
  empty = 0;
8010119f:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011a4:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
801011a9:	eb 0a                	jmp    801011b5 <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011ab:	85 f6                	test   %esi,%esi
801011ad:	74 39                	je     801011e8 <iget+0x64>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011af:	81 c3 90 00 00 00    	add    $0x90,%ebx
801011b5:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801011bb:	73 33                	jae    801011f0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011bd:	8b 43 08             	mov    0x8(%ebx),%eax
801011c0:	85 c0                	test   %eax,%eax
801011c2:	7e e7                	jle    801011ab <iget+0x27>
801011c4:	39 3b                	cmp    %edi,(%ebx)
801011c6:	75 e3                	jne    801011ab <iget+0x27>
801011c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801011cb:	39 4b 04             	cmp    %ecx,0x4(%ebx)
801011ce:	75 db                	jne    801011ab <iget+0x27>
      ip->ref++;
801011d0:	40                   	inc    %eax
801011d1:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801011d4:	83 ec 0c             	sub    $0xc,%esp
801011d7:	68 e0 09 11 80       	push   $0x801109e0
801011dc:	e8 e2 2a 00 00       	call   80103cc3 <release>
      return ip;
801011e1:	83 c4 10             	add    $0x10,%esp
801011e4:	89 de                	mov    %ebx,%esi
801011e6:	eb 32                	jmp    8010121a <iget+0x96>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011e8:	85 c0                	test   %eax,%eax
801011ea:	75 c3                	jne    801011af <iget+0x2b>
      empty = ip;
801011ec:	89 de                	mov    %ebx,%esi
801011ee:	eb bf                	jmp    801011af <iget+0x2b>
  if(empty == 0)
801011f0:	85 f6                	test   %esi,%esi
801011f2:	74 30                	je     80101224 <iget+0xa0>
  ip->dev = dev;
801011f4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801011f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011f9:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
801011fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101203:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010120a:	83 ec 0c             	sub    $0xc,%esp
8010120d:	68 e0 09 11 80       	push   $0x801109e0
80101212:	e8 ac 2a 00 00       	call   80103cc3 <release>
  return ip;
80101217:	83 c4 10             	add    $0x10,%esp
}
8010121a:	89 f0                	mov    %esi,%eax
8010121c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121f:	5b                   	pop    %ebx
80101220:	5e                   	pop    %esi
80101221:	5f                   	pop    %edi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("iget: no inodes");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 e8 68 10 80       	push   $0x801068e8
8010122c:	e8 24 f1 ff ff       	call   80100355 <panic>

80101231 <readsb>:
{
80101231:	f3 0f 1e fb          	endbr32 
80101235:	55                   	push   %ebp
80101236:	89 e5                	mov    %esp,%ebp
80101238:	53                   	push   %ebx
80101239:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
8010123c:	6a 01                	push   $0x1
8010123e:	ff 75 08             	pushl  0x8(%ebp)
80101241:	e8 28 ef ff ff       	call   8010016e <bread>
80101246:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101248:	8d 40 5c             	lea    0x5c(%eax),%eax
8010124b:	83 c4 0c             	add    $0xc,%esp
8010124e:	6a 1c                	push   $0x1c
80101250:	50                   	push   %eax
80101251:	ff 75 0c             	pushl  0xc(%ebp)
80101254:	e8 33 2b 00 00       	call   80103d8c <memmove>
  brelse(bp);
80101259:	89 1c 24             	mov    %ebx,(%esp)
8010125c:	e8 7e ef ff ff       	call   801001df <brelse>
}
80101261:	83 c4 10             	add    $0x10,%esp
80101264:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101267:	c9                   	leave  
80101268:	c3                   	ret    

80101269 <bfree>:
{
80101269:	55                   	push   %ebp
8010126a:	89 e5                	mov    %esp,%ebp
8010126c:	57                   	push   %edi
8010126d:	56                   	push   %esi
8010126e:	53                   	push   %ebx
8010126f:	83 ec 14             	sub    $0x14,%esp
80101272:	89 c3                	mov    %eax,%ebx
80101274:	89 d6                	mov    %edx,%esi
  readsb(dev, &sb);
80101276:	68 c0 09 11 80       	push   $0x801109c0
8010127b:	50                   	push   %eax
8010127c:	e8 b0 ff ff ff       	call   80101231 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101281:	89 f0                	mov    %esi,%eax
80101283:	c1 e8 0c             	shr    $0xc,%eax
80101286:	83 c4 08             	add    $0x8,%esp
80101289:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010128f:	50                   	push   %eax
80101290:	53                   	push   %ebx
80101291:	e8 d8 ee ff ff       	call   8010016e <bread>
80101296:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
80101298:	89 f7                	mov    %esi,%edi
8010129a:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  m = 1 << (bi % 8);
801012a0:	89 f1                	mov    %esi,%ecx
801012a2:	83 e1 07             	and    $0x7,%ecx
801012a5:	b8 01 00 00 00       	mov    $0x1,%eax
801012aa:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801012ac:	83 c4 10             	add    $0x10,%esp
801012af:	c1 ff 03             	sar    $0x3,%edi
801012b2:	8a 54 3b 5c          	mov    0x5c(%ebx,%edi,1),%dl
801012b6:	0f b6 ca             	movzbl %dl,%ecx
801012b9:	85 c1                	test   %eax,%ecx
801012bb:	74 24                	je     801012e1 <bfree+0x78>
  bp->data[bi/8] &= ~m;
801012bd:	f7 d0                	not    %eax
801012bf:	21 d0                	and    %edx,%eax
801012c1:	88 44 3b 5c          	mov    %al,0x5c(%ebx,%edi,1)
  log_write(bp);
801012c5:	83 ec 0c             	sub    $0xc,%esp
801012c8:	53                   	push   %ebx
801012c9:	e8 36 16 00 00       	call   80102904 <log_write>
  brelse(bp);
801012ce:	89 1c 24             	mov    %ebx,(%esp)
801012d1:	e8 09 ef ff ff       	call   801001df <brelse>
}
801012d6:	83 c4 10             	add    $0x10,%esp
801012d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dc:	5b                   	pop    %ebx
801012dd:	5e                   	pop    %esi
801012de:	5f                   	pop    %edi
801012df:	5d                   	pop    %ebp
801012e0:	c3                   	ret    
    panic("freeing free block");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 f8 68 10 80       	push   $0x801068f8
801012e9:	e8 67 f0 ff ff       	call   80100355 <panic>

801012ee <iinit>:
{
801012ee:	f3 0f 1e fb          	endbr32 
801012f2:	55                   	push   %ebp
801012f3:	89 e5                	mov    %esp,%ebp
801012f5:	53                   	push   %ebx
801012f6:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801012f9:	68 0b 69 10 80       	push   $0x8010690b
801012fe:	68 e0 09 11 80       	push   $0x801109e0
80101303:	e8 07 28 00 00       	call   80103b0f <initlock>
  for(i = 0; i < NINODE; i++) {
80101308:	83 c4 10             	add    $0x10,%esp
8010130b:	bb 00 00 00 00       	mov    $0x0,%ebx
80101310:	83 fb 31             	cmp    $0x31,%ebx
80101313:	7f 21                	jg     80101336 <iinit+0x48>
    initsleeplock(&icache.inode[i].lock, "inode");
80101315:	83 ec 08             	sub    $0x8,%esp
80101318:	68 12 69 10 80       	push   $0x80106912
8010131d:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101320:	89 d0                	mov    %edx,%eax
80101322:	c1 e0 04             	shl    $0x4,%eax
80101325:	05 20 0a 11 80       	add    $0x80110a20,%eax
8010132a:	50                   	push   %eax
8010132b:	e8 c4 26 00 00       	call   801039f4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101330:	43                   	inc    %ebx
80101331:	83 c4 10             	add    $0x10,%esp
80101334:	eb da                	jmp    80101310 <iinit+0x22>
  readsb(dev, &sb);
80101336:	83 ec 08             	sub    $0x8,%esp
80101339:	68 c0 09 11 80       	push   $0x801109c0
8010133e:	ff 75 08             	pushl  0x8(%ebp)
80101341:	e8 eb fe ff ff       	call   80101231 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101346:	ff 35 d8 09 11 80    	pushl  0x801109d8
8010134c:	ff 35 d4 09 11 80    	pushl  0x801109d4
80101352:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101358:	ff 35 cc 09 11 80    	pushl  0x801109cc
8010135e:	ff 35 c8 09 11 80    	pushl  0x801109c8
80101364:	ff 35 c4 09 11 80    	pushl  0x801109c4
8010136a:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101370:	68 78 69 10 80       	push   $0x80106978
80101375:	e8 83 f2 ff ff       	call   801005fd <cprintf>
}
8010137a:	83 c4 30             	add    $0x30,%esp
8010137d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101380:	c9                   	leave  
80101381:	c3                   	ret    

80101382 <ialloc>:
{
80101382:	f3 0f 1e fb          	endbr32 
80101386:	55                   	push   %ebp
80101387:	89 e5                	mov    %esp,%ebp
80101389:	57                   	push   %edi
8010138a:	56                   	push   %esi
8010138b:	53                   	push   %ebx
8010138c:	83 ec 1c             	sub    $0x1c,%esp
8010138f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101392:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101395:	bb 01 00 00 00       	mov    $0x1,%ebx
8010139a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010139d:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
801013a3:	76 73                	jbe    80101418 <ialloc+0x96>
    bp = bread(dev, IBLOCK(inum, sb));
801013a5:	89 d8                	mov    %ebx,%eax
801013a7:	c1 e8 03             	shr    $0x3,%eax
801013aa:	83 ec 08             	sub    $0x8,%esp
801013ad:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801013b3:	50                   	push   %eax
801013b4:	ff 75 08             	pushl  0x8(%ebp)
801013b7:	e8 b2 ed ff ff       	call   8010016e <bread>
801013bc:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013be:	89 d8                	mov    %ebx,%eax
801013c0:	83 e0 07             	and    $0x7,%eax
801013c3:	c1 e0 06             	shl    $0x6,%eax
801013c6:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013ca:	83 c4 10             	add    $0x10,%esp
801013cd:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013d1:	74 0f                	je     801013e2 <ialloc+0x60>
    brelse(bp);
801013d3:	83 ec 0c             	sub    $0xc,%esp
801013d6:	56                   	push   %esi
801013d7:	e8 03 ee ff ff       	call   801001df <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013dc:	43                   	inc    %ebx
801013dd:	83 c4 10             	add    $0x10,%esp
801013e0:	eb b8                	jmp    8010139a <ialloc+0x18>
      memset(dip, 0, sizeof(*dip));
801013e2:	83 ec 04             	sub    $0x4,%esp
801013e5:	6a 40                	push   $0x40
801013e7:	6a 00                	push   $0x0
801013e9:	57                   	push   %edi
801013ea:	e8 1f 29 00 00       	call   80103d0e <memset>
      dip->type = type;
801013ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013f2:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
801013f5:	89 34 24             	mov    %esi,(%esp)
801013f8:	e8 07 15 00 00       	call   80102904 <log_write>
      brelse(bp);
801013fd:	89 34 24             	mov    %esi,(%esp)
80101400:	e8 da ed ff ff       	call   801001df <brelse>
      return iget(dev, inum);
80101405:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101408:	8b 45 08             	mov    0x8(%ebp),%eax
8010140b:	e8 74 fd ff ff       	call   80101184 <iget>
}
80101410:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101413:	5b                   	pop    %ebx
80101414:	5e                   	pop    %esi
80101415:	5f                   	pop    %edi
80101416:	5d                   	pop    %ebp
80101417:	c3                   	ret    
  panic("ialloc: no inodes");
80101418:	83 ec 0c             	sub    $0xc,%esp
8010141b:	68 18 69 10 80       	push   $0x80106918
80101420:	e8 30 ef ff ff       	call   80100355 <panic>

80101425 <iupdate>:
{
80101425:	f3 0f 1e fb          	endbr32 
80101429:	55                   	push   %ebp
8010142a:	89 e5                	mov    %esp,%ebp
8010142c:	56                   	push   %esi
8010142d:	53                   	push   %ebx
8010142e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101431:	8b 43 04             	mov    0x4(%ebx),%eax
80101434:	c1 e8 03             	shr    $0x3,%eax
80101437:	83 ec 08             	sub    $0x8,%esp
8010143a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101440:	50                   	push   %eax
80101441:	ff 33                	pushl  (%ebx)
80101443:	e8 26 ed ff ff       	call   8010016e <bread>
80101448:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010144a:	8b 43 04             	mov    0x4(%ebx),%eax
8010144d:	83 e0 07             	and    $0x7,%eax
80101450:	c1 e0 06             	shl    $0x6,%eax
80101453:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101457:	8b 53 50             	mov    0x50(%ebx),%edx
8010145a:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010145d:	66 8b 53 52          	mov    0x52(%ebx),%dx
80101461:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101465:	8b 53 54             	mov    0x54(%ebx),%edx
80101468:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010146c:	66 8b 53 56          	mov    0x56(%ebx),%dx
80101470:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101474:	8b 53 58             	mov    0x58(%ebx),%edx
80101477:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010147a:	83 c3 5c             	add    $0x5c,%ebx
8010147d:	83 c0 0c             	add    $0xc,%eax
80101480:	83 c4 0c             	add    $0xc,%esp
80101483:	6a 34                	push   $0x34
80101485:	53                   	push   %ebx
80101486:	50                   	push   %eax
80101487:	e8 00 29 00 00       	call   80103d8c <memmove>
  log_write(bp);
8010148c:	89 34 24             	mov    %esi,(%esp)
8010148f:	e8 70 14 00 00       	call   80102904 <log_write>
  brelse(bp);
80101494:	89 34 24             	mov    %esi,(%esp)
80101497:	e8 43 ed ff ff       	call   801001df <brelse>
}
8010149c:	83 c4 10             	add    $0x10,%esp
8010149f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014a2:	5b                   	pop    %ebx
801014a3:	5e                   	pop    %esi
801014a4:	5d                   	pop    %ebp
801014a5:	c3                   	ret    

801014a6 <itrunc>:
{
801014a6:	55                   	push   %ebp
801014a7:	89 e5                	mov    %esp,%ebp
801014a9:	57                   	push   %edi
801014aa:	56                   	push   %esi
801014ab:	53                   	push   %ebx
801014ac:	83 ec 1c             	sub    $0x1c,%esp
801014af:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801014b1:	bb 00 00 00 00       	mov    $0x0,%ebx
801014b6:	eb 01                	jmp    801014b9 <itrunc+0x13>
801014b8:	43                   	inc    %ebx
801014b9:	83 fb 0b             	cmp    $0xb,%ebx
801014bc:	7f 19                	jg     801014d7 <itrunc+0x31>
    if(ip->addrs[i]){
801014be:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
801014c2:	85 d2                	test   %edx,%edx
801014c4:	74 f2                	je     801014b8 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
801014c6:	8b 06                	mov    (%esi),%eax
801014c8:	e8 9c fd ff ff       	call   80101269 <bfree>
      ip->addrs[i] = 0;
801014cd:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
801014d4:	00 
801014d5:	eb e1                	jmp    801014b8 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
801014d7:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801014dd:	85 c0                	test   %eax,%eax
801014df:	75 1b                	jne    801014fc <itrunc+0x56>
  ip->size = 0;
801014e1:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	56                   	push   %esi
801014ec:	e8 34 ff ff ff       	call   80101425 <iupdate>
}
801014f1:	83 c4 10             	add    $0x10,%esp
801014f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f7:	5b                   	pop    %ebx
801014f8:	5e                   	pop    %esi
801014f9:	5f                   	pop    %edi
801014fa:	5d                   	pop    %ebp
801014fb:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801014fc:	83 ec 08             	sub    $0x8,%esp
801014ff:	50                   	push   %eax
80101500:	ff 36                	pushl  (%esi)
80101502:	e8 67 ec ff ff       	call   8010016e <bread>
80101507:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010150a:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010150d:	83 c4 10             	add    $0x10,%esp
80101510:	bb 00 00 00 00       	mov    $0x0,%ebx
80101515:	eb 08                	jmp    8010151f <itrunc+0x79>
        bfree(ip->dev, a[j]);
80101517:	8b 06                	mov    (%esi),%eax
80101519:	e8 4b fd ff ff       	call   80101269 <bfree>
    for(j = 0; j < NINDIRECT; j++){
8010151e:	43                   	inc    %ebx
8010151f:	83 fb 7f             	cmp    $0x7f,%ebx
80101522:	77 09                	ja     8010152d <itrunc+0x87>
      if(a[j])
80101524:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
80101527:	85 d2                	test   %edx,%edx
80101529:	74 f3                	je     8010151e <itrunc+0x78>
8010152b:	eb ea                	jmp    80101517 <itrunc+0x71>
    brelse(bp);
8010152d:	83 ec 0c             	sub    $0xc,%esp
80101530:	ff 75 e4             	pushl  -0x1c(%ebp)
80101533:	e8 a7 ec ff ff       	call   801001df <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101538:	8b 06                	mov    (%esi),%eax
8010153a:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101540:	e8 24 fd ff ff       	call   80101269 <bfree>
    ip->addrs[NDIRECT] = 0;
80101545:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010154c:	00 00 00 
8010154f:	83 c4 10             	add    $0x10,%esp
80101552:	eb 8d                	jmp    801014e1 <itrunc+0x3b>

80101554 <idup>:
{
80101554:	f3 0f 1e fb          	endbr32 
80101558:	55                   	push   %ebp
80101559:	89 e5                	mov    %esp,%ebp
8010155b:	53                   	push   %ebx
8010155c:	83 ec 10             	sub    $0x10,%esp
8010155f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101562:	68 e0 09 11 80       	push   $0x801109e0
80101567:	e8 ee 26 00 00       	call   80103c5a <acquire>
  ip->ref++;
8010156c:	8b 43 08             	mov    0x8(%ebx),%eax
8010156f:	40                   	inc    %eax
80101570:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101573:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010157a:	e8 44 27 00 00       	call   80103cc3 <release>
}
8010157f:	89 d8                	mov    %ebx,%eax
80101581:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101584:	c9                   	leave  
80101585:	c3                   	ret    

80101586 <ilock>:
{
80101586:	f3 0f 1e fb          	endbr32 
8010158a:	55                   	push   %ebp
8010158b:	89 e5                	mov    %esp,%ebp
8010158d:	56                   	push   %esi
8010158e:	53                   	push   %ebx
8010158f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101592:	85 db                	test   %ebx,%ebx
80101594:	74 22                	je     801015b8 <ilock+0x32>
80101596:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
8010159a:	7e 1c                	jle    801015b8 <ilock+0x32>
  acquiresleep(&ip->lock);
8010159c:	83 ec 0c             	sub    $0xc,%esp
8010159f:	8d 43 0c             	lea    0xc(%ebx),%eax
801015a2:	50                   	push   %eax
801015a3:	e8 83 24 00 00       	call   80103a2b <acquiresleep>
  if(ip->valid == 0){
801015a8:	83 c4 10             	add    $0x10,%esp
801015ab:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801015af:	74 14                	je     801015c5 <ilock+0x3f>
}
801015b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015b4:	5b                   	pop    %ebx
801015b5:	5e                   	pop    %esi
801015b6:	5d                   	pop    %ebp
801015b7:	c3                   	ret    
    panic("ilock");
801015b8:	83 ec 0c             	sub    $0xc,%esp
801015bb:	68 2a 69 10 80       	push   $0x8010692a
801015c0:	e8 90 ed ff ff       	call   80100355 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c5:	8b 43 04             	mov    0x4(%ebx),%eax
801015c8:	c1 e8 03             	shr    $0x3,%eax
801015cb:	83 ec 08             	sub    $0x8,%esp
801015ce:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015d4:	50                   	push   %eax
801015d5:	ff 33                	pushl  (%ebx)
801015d7:	e8 92 eb ff ff       	call   8010016e <bread>
801015dc:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015de:	8b 43 04             	mov    0x4(%ebx),%eax
801015e1:	83 e0 07             	and    $0x7,%eax
801015e4:	c1 e0 06             	shl    $0x6,%eax
801015e7:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015eb:	8b 10                	mov    (%eax),%edx
801015ed:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801015f1:	66 8b 50 02          	mov    0x2(%eax),%dx
801015f5:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801015f9:	8b 50 04             	mov    0x4(%eax),%edx
801015fc:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101600:	66 8b 50 06          	mov    0x6(%eax),%dx
80101604:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101608:	8b 50 08             	mov    0x8(%eax),%edx
8010160b:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010160e:	83 c0 0c             	add    $0xc,%eax
80101611:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101614:	83 c4 0c             	add    $0xc,%esp
80101617:	6a 34                	push   $0x34
80101619:	50                   	push   %eax
8010161a:	52                   	push   %edx
8010161b:	e8 6c 27 00 00       	call   80103d8c <memmove>
    brelse(bp);
80101620:	89 34 24             	mov    %esi,(%esp)
80101623:	e8 b7 eb ff ff       	call   801001df <brelse>
    ip->valid = 1;
80101628:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010162f:	83 c4 10             	add    $0x10,%esp
80101632:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101637:	0f 85 74 ff ff ff    	jne    801015b1 <ilock+0x2b>
      panic("ilock: no type");
8010163d:	83 ec 0c             	sub    $0xc,%esp
80101640:	68 30 69 10 80       	push   $0x80106930
80101645:	e8 0b ed ff ff       	call   80100355 <panic>

8010164a <iunlock>:
{
8010164a:	f3 0f 1e fb          	endbr32 
8010164e:	55                   	push   %ebp
8010164f:	89 e5                	mov    %esp,%ebp
80101651:	56                   	push   %esi
80101652:	53                   	push   %ebx
80101653:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101656:	85 db                	test   %ebx,%ebx
80101658:	74 2c                	je     80101686 <iunlock+0x3c>
8010165a:	8d 73 0c             	lea    0xc(%ebx),%esi
8010165d:	83 ec 0c             	sub    $0xc,%esp
80101660:	56                   	push   %esi
80101661:	e8 57 24 00 00       	call   80103abd <holdingsleep>
80101666:	83 c4 10             	add    $0x10,%esp
80101669:	85 c0                	test   %eax,%eax
8010166b:	74 19                	je     80101686 <iunlock+0x3c>
8010166d:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101671:	7e 13                	jle    80101686 <iunlock+0x3c>
  releasesleep(&ip->lock);
80101673:	83 ec 0c             	sub    $0xc,%esp
80101676:	56                   	push   %esi
80101677:	e8 02 24 00 00       	call   80103a7e <releasesleep>
}
8010167c:	83 c4 10             	add    $0x10,%esp
8010167f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101682:	5b                   	pop    %ebx
80101683:	5e                   	pop    %esi
80101684:	5d                   	pop    %ebp
80101685:	c3                   	ret    
    panic("iunlock");
80101686:	83 ec 0c             	sub    $0xc,%esp
80101689:	68 3f 69 10 80       	push   $0x8010693f
8010168e:	e8 c2 ec ff ff       	call   80100355 <panic>

80101693 <iput>:
{
80101693:	f3 0f 1e fb          	endbr32 
80101697:	55                   	push   %ebp
80101698:	89 e5                	mov    %esp,%ebp
8010169a:	57                   	push   %edi
8010169b:	56                   	push   %esi
8010169c:	53                   	push   %ebx
8010169d:	83 ec 18             	sub    $0x18,%esp
801016a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801016a3:	8d 73 0c             	lea    0xc(%ebx),%esi
801016a6:	56                   	push   %esi
801016a7:	e8 7f 23 00 00       	call   80103a2b <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016ac:	83 c4 10             	add    $0x10,%esp
801016af:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801016b3:	74 07                	je     801016bc <iput+0x29>
801016b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801016ba:	74 33                	je     801016ef <iput+0x5c>
  releasesleep(&ip->lock);
801016bc:	83 ec 0c             	sub    $0xc,%esp
801016bf:	56                   	push   %esi
801016c0:	e8 b9 23 00 00       	call   80103a7e <releasesleep>
  acquire(&icache.lock);
801016c5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016cc:	e8 89 25 00 00       	call   80103c5a <acquire>
  ip->ref--;
801016d1:	8b 43 08             	mov    0x8(%ebx),%eax
801016d4:	48                   	dec    %eax
801016d5:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801016d8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016df:	e8 df 25 00 00       	call   80103cc3 <release>
}
801016e4:	83 c4 10             	add    $0x10,%esp
801016e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ea:	5b                   	pop    %ebx
801016eb:	5e                   	pop    %esi
801016ec:	5f                   	pop    %edi
801016ed:	5d                   	pop    %ebp
801016ee:	c3                   	ret    
    acquire(&icache.lock);
801016ef:	83 ec 0c             	sub    $0xc,%esp
801016f2:	68 e0 09 11 80       	push   $0x801109e0
801016f7:	e8 5e 25 00 00       	call   80103c5a <acquire>
    int r = ip->ref;
801016fc:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016ff:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101706:	e8 b8 25 00 00       	call   80103cc3 <release>
    if(r == 1){
8010170b:	83 c4 10             	add    $0x10,%esp
8010170e:	83 ff 01             	cmp    $0x1,%edi
80101711:	75 a9                	jne    801016bc <iput+0x29>
      itrunc(ip);
80101713:	89 d8                	mov    %ebx,%eax
80101715:	e8 8c fd ff ff       	call   801014a6 <itrunc>
      ip->type = 0;
8010171a:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101720:	83 ec 0c             	sub    $0xc,%esp
80101723:	53                   	push   %ebx
80101724:	e8 fc fc ff ff       	call   80101425 <iupdate>
      ip->valid = 0;
80101729:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101730:	83 c4 10             	add    $0x10,%esp
80101733:	eb 87                	jmp    801016bc <iput+0x29>

80101735 <iunlockput>:
{
80101735:	f3 0f 1e fb          	endbr32 
80101739:	55                   	push   %ebp
8010173a:	89 e5                	mov    %esp,%ebp
8010173c:	53                   	push   %ebx
8010173d:	83 ec 10             	sub    $0x10,%esp
80101740:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101743:	53                   	push   %ebx
80101744:	e8 01 ff ff ff       	call   8010164a <iunlock>
  iput(ip);
80101749:	89 1c 24             	mov    %ebx,(%esp)
8010174c:	e8 42 ff ff ff       	call   80101693 <iput>
}
80101751:	83 c4 10             	add    $0x10,%esp
80101754:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101757:	c9                   	leave  
80101758:	c3                   	ret    

80101759 <stati>:
{
80101759:	f3 0f 1e fb          	endbr32 
8010175d:	55                   	push   %ebp
8010175e:	89 e5                	mov    %esp,%ebp
80101760:	8b 55 08             	mov    0x8(%ebp),%edx
80101763:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101766:	8b 0a                	mov    (%edx),%ecx
80101768:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010176b:	8b 4a 04             	mov    0x4(%edx),%ecx
8010176e:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101771:	8b 4a 50             	mov    0x50(%edx),%ecx
80101774:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101777:	66 8b 4a 56          	mov    0x56(%edx),%cx
8010177b:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
8010177f:	8b 52 58             	mov    0x58(%edx),%edx
80101782:	89 50 10             	mov    %edx,0x10(%eax)
}
80101785:	5d                   	pop    %ebp
80101786:	c3                   	ret    

80101787 <readi>:
{
80101787:	f3 0f 1e fb          	endbr32 
8010178b:	55                   	push   %ebp
8010178c:	89 e5                	mov    %esp,%ebp
8010178e:	57                   	push   %edi
8010178f:	56                   	push   %esi
80101790:	53                   	push   %ebx
80101791:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
80101794:	8b 45 08             	mov    0x8(%ebp),%eax
80101797:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010179c:	74 2c                	je     801017ca <readi+0x43>
  if(off > ip->size || off + n < off)
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	8b 40 58             	mov    0x58(%eax),%eax
801017a4:	3b 45 10             	cmp    0x10(%ebp),%eax
801017a7:	0f 82 d0 00 00 00    	jb     8010187d <readi+0xf6>
801017ad:	8b 55 10             	mov    0x10(%ebp),%edx
801017b0:	03 55 14             	add    0x14(%ebp),%edx
801017b3:	0f 82 cb 00 00 00    	jb     80101884 <readi+0xfd>
  if(off + n > ip->size)
801017b9:	39 d0                	cmp    %edx,%eax
801017bb:	73 06                	jae    801017c3 <readi+0x3c>
    n = ip->size - off;
801017bd:	2b 45 10             	sub    0x10(%ebp),%eax
801017c0:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017c3:	bf 00 00 00 00       	mov    $0x0,%edi
801017c8:	eb 55                	jmp    8010181f <readi+0x98>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801017ca:	66 8b 40 52          	mov    0x52(%eax),%ax
801017ce:	66 83 f8 09          	cmp    $0x9,%ax
801017d2:	0f 87 97 00 00 00    	ja     8010186f <readi+0xe8>
801017d8:	98                   	cwtl   
801017d9:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
801017e0:	85 c0                	test   %eax,%eax
801017e2:	0f 84 8e 00 00 00    	je     80101876 <readi+0xef>
    return devsw[ip->major].read(ip, dst, n);
801017e8:	83 ec 04             	sub    $0x4,%esp
801017eb:	ff 75 14             	pushl  0x14(%ebp)
801017ee:	ff 75 0c             	pushl  0xc(%ebp)
801017f1:	ff 75 08             	pushl  0x8(%ebp)
801017f4:	ff d0                	call   *%eax
801017f6:	83 c4 10             	add    $0x10,%esp
801017f9:	eb 6c                	jmp    80101867 <readi+0xe0>
    memmove(dst, bp->data + off%BSIZE, m);
801017fb:	83 ec 04             	sub    $0x4,%esp
801017fe:	53                   	push   %ebx
801017ff:	8d 44 16 5c          	lea    0x5c(%esi,%edx,1),%eax
80101803:	50                   	push   %eax
80101804:	ff 75 0c             	pushl  0xc(%ebp)
80101807:	e8 80 25 00 00       	call   80103d8c <memmove>
    brelse(bp);
8010180c:	89 34 24             	mov    %esi,(%esp)
8010180f:	e8 cb e9 ff ff       	call   801001df <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101814:	01 df                	add    %ebx,%edi
80101816:	01 5d 10             	add    %ebx,0x10(%ebp)
80101819:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010181c:	83 c4 10             	add    $0x10,%esp
8010181f:	39 7d 14             	cmp    %edi,0x14(%ebp)
80101822:	76 40                	jbe    80101864 <readi+0xdd>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101824:	8b 55 10             	mov    0x10(%ebp),%edx
80101827:	c1 ea 09             	shr    $0x9,%edx
8010182a:	8b 45 08             	mov    0x8(%ebp),%eax
8010182d:	e8 ac f8 ff ff       	call   801010de <bmap>
80101832:	83 ec 08             	sub    $0x8,%esp
80101835:	50                   	push   %eax
80101836:	8b 45 08             	mov    0x8(%ebp),%eax
80101839:	ff 30                	pushl  (%eax)
8010183b:	e8 2e e9 ff ff       	call   8010016e <bread>
80101840:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101842:	8b 55 10             	mov    0x10(%ebp),%edx
80101845:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010184b:	b8 00 02 00 00       	mov    $0x200,%eax
80101850:	29 d0                	sub    %edx,%eax
80101852:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101855:	29 f9                	sub    %edi,%ecx
80101857:	89 c3                	mov    %eax,%ebx
80101859:	83 c4 10             	add    $0x10,%esp
8010185c:	39 c8                	cmp    %ecx,%eax
8010185e:	76 9b                	jbe    801017fb <readi+0x74>
80101860:	89 cb                	mov    %ecx,%ebx
80101862:	eb 97                	jmp    801017fb <readi+0x74>
  return n;
80101864:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101867:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010186a:	5b                   	pop    %ebx
8010186b:	5e                   	pop    %esi
8010186c:	5f                   	pop    %edi
8010186d:	5d                   	pop    %ebp
8010186e:	c3                   	ret    
      return -1;
8010186f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101874:	eb f1                	jmp    80101867 <readi+0xe0>
80101876:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010187b:	eb ea                	jmp    80101867 <readi+0xe0>
    return -1;
8010187d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101882:	eb e3                	jmp    80101867 <readi+0xe0>
80101884:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101889:	eb dc                	jmp    80101867 <readi+0xe0>

8010188b <writei>:
{
8010188b:	f3 0f 1e fb          	endbr32 
8010188f:	55                   	push   %ebp
80101890:	89 e5                	mov    %esp,%ebp
80101892:	57                   	push   %edi
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
80101898:	8b 45 08             	mov    0x8(%ebp),%eax
8010189b:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018a0:	74 2c                	je     801018ce <writei+0x43>
  if(off > ip->size || off + n < off)
801018a2:	8b 45 08             	mov    0x8(%ebp),%eax
801018a5:	8b 7d 10             	mov    0x10(%ebp),%edi
801018a8:	39 78 58             	cmp    %edi,0x58(%eax)
801018ab:	0f 82 fd 00 00 00    	jb     801019ae <writei+0x123>
801018b1:	89 f8                	mov    %edi,%eax
801018b3:	03 45 14             	add    0x14(%ebp),%eax
801018b6:	0f 82 f9 00 00 00    	jb     801019b5 <writei+0x12a>
  if(off + n > MAXFILE*BSIZE)
801018bc:	3d 00 18 01 00       	cmp    $0x11800,%eax
801018c1:	0f 87 f5 00 00 00    	ja     801019bc <writei+0x131>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018c7:	bf 00 00 00 00       	mov    $0x0,%edi
801018cc:	eb 60                	jmp    8010192e <writei+0xa3>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801018ce:	66 8b 40 52          	mov    0x52(%eax),%ax
801018d2:	66 83 f8 09          	cmp    $0x9,%ax
801018d6:	0f 87 c4 00 00 00    	ja     801019a0 <writei+0x115>
801018dc:	98                   	cwtl   
801018dd:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
801018e4:	85 c0                	test   %eax,%eax
801018e6:	0f 84 bb 00 00 00    	je     801019a7 <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801018ec:	83 ec 04             	sub    $0x4,%esp
801018ef:	ff 75 14             	pushl  0x14(%ebp)
801018f2:	ff 75 0c             	pushl  0xc(%ebp)
801018f5:	ff 75 08             	pushl  0x8(%ebp)
801018f8:	ff d0                	call   *%eax
801018fa:	83 c4 10             	add    $0x10,%esp
801018fd:	e9 85 00 00 00       	jmp    80101987 <writei+0xfc>
    memmove(bp->data + off%BSIZE, src, m);
80101902:	83 ec 04             	sub    $0x4,%esp
80101905:	56                   	push   %esi
80101906:	ff 75 0c             	pushl  0xc(%ebp)
80101909:	8d 44 13 5c          	lea    0x5c(%ebx,%edx,1),%eax
8010190d:	50                   	push   %eax
8010190e:	e8 79 24 00 00       	call   80103d8c <memmove>
    log_write(bp);
80101913:	89 1c 24             	mov    %ebx,(%esp)
80101916:	e8 e9 0f 00 00       	call   80102904 <log_write>
    brelse(bp);
8010191b:	89 1c 24             	mov    %ebx,(%esp)
8010191e:	e8 bc e8 ff ff       	call   801001df <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101923:	01 f7                	add    %esi,%edi
80101925:	01 75 10             	add    %esi,0x10(%ebp)
80101928:	01 75 0c             	add    %esi,0xc(%ebp)
8010192b:	83 c4 10             	add    $0x10,%esp
8010192e:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101931:	73 40                	jae    80101973 <writei+0xe8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101933:	8b 55 10             	mov    0x10(%ebp),%edx
80101936:	c1 ea 09             	shr    $0x9,%edx
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	e8 9d f7 ff ff       	call   801010de <bmap>
80101941:	83 ec 08             	sub    $0x8,%esp
80101944:	50                   	push   %eax
80101945:	8b 45 08             	mov    0x8(%ebp),%eax
80101948:	ff 30                	pushl  (%eax)
8010194a:	e8 1f e8 ff ff       	call   8010016e <bread>
8010194f:	89 c3                	mov    %eax,%ebx
    m = min(n - tot, BSIZE - off%BSIZE);
80101951:	8b 55 10             	mov    0x10(%ebp),%edx
80101954:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010195a:	b8 00 02 00 00       	mov    $0x200,%eax
8010195f:	29 d0                	sub    %edx,%eax
80101961:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101964:	29 f9                	sub    %edi,%ecx
80101966:	89 c6                	mov    %eax,%esi
80101968:	83 c4 10             	add    $0x10,%esp
8010196b:	39 c8                	cmp    %ecx,%eax
8010196d:	76 93                	jbe    80101902 <writei+0x77>
8010196f:	89 ce                	mov    %ecx,%esi
80101971:	eb 8f                	jmp    80101902 <writei+0x77>
  if(n > 0 && off > ip->size){
80101973:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101977:	74 0b                	je     80101984 <writei+0xf9>
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 7d 10             	mov    0x10(%ebp),%edi
8010197f:	39 78 58             	cmp    %edi,0x58(%eax)
80101982:	72 0b                	jb     8010198f <writei+0x104>
  return n;
80101984:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101987:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010198a:	5b                   	pop    %ebx
8010198b:	5e                   	pop    %esi
8010198c:	5f                   	pop    %edi
8010198d:	5d                   	pop    %ebp
8010198e:	c3                   	ret    
    ip->size = off;
8010198f:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101992:	83 ec 0c             	sub    $0xc,%esp
80101995:	50                   	push   %eax
80101996:	e8 8a fa ff ff       	call   80101425 <iupdate>
8010199b:	83 c4 10             	add    $0x10,%esp
8010199e:	eb e4                	jmp    80101984 <writei+0xf9>
      return -1;
801019a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019a5:	eb e0                	jmp    80101987 <writei+0xfc>
801019a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019ac:	eb d9                	jmp    80101987 <writei+0xfc>
    return -1;
801019ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019b3:	eb d2                	jmp    80101987 <writei+0xfc>
801019b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019ba:	eb cb                	jmp    80101987 <writei+0xfc>
    return -1;
801019bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019c1:	eb c4                	jmp    80101987 <writei+0xfc>

801019c3 <namecmp>:
{
801019c3:	f3 0f 1e fb          	endbr32 
801019c7:	55                   	push   %ebp
801019c8:	89 e5                	mov    %esp,%ebp
801019ca:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801019cd:	6a 0e                	push   $0xe
801019cf:	ff 75 0c             	pushl  0xc(%ebp)
801019d2:	ff 75 08             	pushl  0x8(%ebp)
801019d5:	e8 1e 24 00 00       	call   80103df8 <strncmp>
}
801019da:	c9                   	leave  
801019db:	c3                   	ret    

801019dc <dirlookup>:
{
801019dc:	f3 0f 1e fb          	endbr32 
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 1c             	sub    $0x1c,%esp
801019e9:	8b 75 08             	mov    0x8(%ebp),%esi
801019ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
801019ef:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019f4:	75 07                	jne    801019fd <dirlookup+0x21>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019f6:	bb 00 00 00 00       	mov    $0x0,%ebx
801019fb:	eb 1d                	jmp    80101a1a <dirlookup+0x3e>
    panic("dirlookup not DIR");
801019fd:	83 ec 0c             	sub    $0xc,%esp
80101a00:	68 47 69 10 80       	push   $0x80106947
80101a05:	e8 4b e9 ff ff       	call   80100355 <panic>
      panic("dirlookup read");
80101a0a:	83 ec 0c             	sub    $0xc,%esp
80101a0d:	68 59 69 10 80       	push   $0x80106959
80101a12:	e8 3e e9 ff ff       	call   80100355 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a17:	83 c3 10             	add    $0x10,%ebx
80101a1a:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a1d:	76 48                	jbe    80101a67 <dirlookup+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a1f:	6a 10                	push   $0x10
80101a21:	53                   	push   %ebx
80101a22:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101a25:	50                   	push   %eax
80101a26:	56                   	push   %esi
80101a27:	e8 5b fd ff ff       	call   80101787 <readi>
80101a2c:	83 c4 10             	add    $0x10,%esp
80101a2f:	83 f8 10             	cmp    $0x10,%eax
80101a32:	75 d6                	jne    80101a0a <dirlookup+0x2e>
    if(de.inum == 0)
80101a34:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a39:	74 dc                	je     80101a17 <dirlookup+0x3b>
    if(namecmp(name, de.name) == 0){
80101a3b:	83 ec 08             	sub    $0x8,%esp
80101a3e:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a41:	50                   	push   %eax
80101a42:	57                   	push   %edi
80101a43:	e8 7b ff ff ff       	call   801019c3 <namecmp>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	75 c8                	jne    80101a17 <dirlookup+0x3b>
      if(poff)
80101a4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a53:	74 05                	je     80101a5a <dirlookup+0x7e>
        *poff = off;
80101a55:	8b 45 10             	mov    0x10(%ebp),%eax
80101a58:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a5a:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a5e:	8b 06                	mov    (%esi),%eax
80101a60:	e8 1f f7 ff ff       	call   80101184 <iget>
80101a65:	eb 05                	jmp    80101a6c <dirlookup+0x90>
  return 0;
80101a67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a6f:	5b                   	pop    %ebx
80101a70:	5e                   	pop    %esi
80101a71:	5f                   	pop    %edi
80101a72:	5d                   	pop    %ebp
80101a73:	c3                   	ret    

80101a74 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	89 c3                	mov    %eax,%ebx
80101a7f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101a82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a85:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a88:	74 17                	je     80101aa1 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a8a:	e8 c2 17 00 00       	call   80103251 <myproc>
80101a8f:	83 ec 0c             	sub    $0xc,%esp
80101a92:	ff 70 68             	pushl  0x68(%eax)
80101a95:	e8 ba fa ff ff       	call   80101554 <idup>
80101a9a:	89 c6                	mov    %eax,%esi
80101a9c:	83 c4 10             	add    $0x10,%esp
80101a9f:	eb 53                	jmp    80101af4 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101aa1:	ba 01 00 00 00       	mov    $0x1,%edx
80101aa6:	b8 01 00 00 00       	mov    $0x1,%eax
80101aab:	e8 d4 f6 ff ff       	call   80101184 <iget>
80101ab0:	89 c6                	mov    %eax,%esi
80101ab2:	eb 40                	jmp    80101af4 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101ab4:	83 ec 0c             	sub    $0xc,%esp
80101ab7:	56                   	push   %esi
80101ab8:	e8 78 fc ff ff       	call   80101735 <iunlockput>
      return 0;
80101abd:	83 c4 10             	add    $0x10,%esp
80101ac0:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ac5:	89 f0                	mov    %esi,%eax
80101ac7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aca:	5b                   	pop    %ebx
80101acb:	5e                   	pop    %esi
80101acc:	5f                   	pop    %edi
80101acd:	5d                   	pop    %ebp
80101ace:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101acf:	83 ec 04             	sub    $0x4,%esp
80101ad2:	6a 00                	push   $0x0
80101ad4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ad7:	56                   	push   %esi
80101ad8:	e8 ff fe ff ff       	call   801019dc <dirlookup>
80101add:	89 c7                	mov    %eax,%edi
80101adf:	83 c4 10             	add    $0x10,%esp
80101ae2:	85 c0                	test   %eax,%eax
80101ae4:	74 4a                	je     80101b30 <namex+0xbc>
    iunlockput(ip);
80101ae6:	83 ec 0c             	sub    $0xc,%esp
80101ae9:	56                   	push   %esi
80101aea:	e8 46 fc ff ff       	call   80101735 <iunlockput>
80101aef:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101af2:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101af4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101af7:	89 d8                	mov    %ebx,%eax
80101af9:	e8 46 f4 ff ff       	call   80100f44 <skipelem>
80101afe:	89 c3                	mov    %eax,%ebx
80101b00:	85 c0                	test   %eax,%eax
80101b02:	74 3c                	je     80101b40 <namex+0xcc>
    ilock(ip);
80101b04:	83 ec 0c             	sub    $0xc,%esp
80101b07:	56                   	push   %esi
80101b08:	e8 79 fa ff ff       	call   80101586 <ilock>
    if(ip->type != T_DIR){
80101b0d:	83 c4 10             	add    $0x10,%esp
80101b10:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b15:	75 9d                	jne    80101ab4 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101b17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b1b:	74 b2                	je     80101acf <namex+0x5b>
80101b1d:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b20:	75 ad                	jne    80101acf <namex+0x5b>
      iunlock(ip);
80101b22:	83 ec 0c             	sub    $0xc,%esp
80101b25:	56                   	push   %esi
80101b26:	e8 1f fb ff ff       	call   8010164a <iunlock>
      return ip;
80101b2b:	83 c4 10             	add    $0x10,%esp
80101b2e:	eb 95                	jmp    80101ac5 <namex+0x51>
      iunlockput(ip);
80101b30:	83 ec 0c             	sub    $0xc,%esp
80101b33:	56                   	push   %esi
80101b34:	e8 fc fb ff ff       	call   80101735 <iunlockput>
      return 0;
80101b39:	83 c4 10             	add    $0x10,%esp
80101b3c:	89 fe                	mov    %edi,%esi
80101b3e:	eb 85                	jmp    80101ac5 <namex+0x51>
  if(nameiparent){
80101b40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b44:	0f 84 7b ff ff ff    	je     80101ac5 <namex+0x51>
    iput(ip);
80101b4a:	83 ec 0c             	sub    $0xc,%esp
80101b4d:	56                   	push   %esi
80101b4e:	e8 40 fb ff ff       	call   80101693 <iput>
    return 0;
80101b53:	83 c4 10             	add    $0x10,%esp
80101b56:	89 de                	mov    %ebx,%esi
80101b58:	e9 68 ff ff ff       	jmp    80101ac5 <namex+0x51>

80101b5d <dirlink>:
{
80101b5d:	f3 0f 1e fb          	endbr32 
80101b61:	55                   	push   %ebp
80101b62:	89 e5                	mov    %esp,%ebp
80101b64:	57                   	push   %edi
80101b65:	56                   	push   %esi
80101b66:	53                   	push   %ebx
80101b67:	83 ec 20             	sub    $0x20,%esp
80101b6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101b70:	6a 00                	push   $0x0
80101b72:	57                   	push   %edi
80101b73:	53                   	push   %ebx
80101b74:	e8 63 fe ff ff       	call   801019dc <dirlookup>
80101b79:	83 c4 10             	add    $0x10,%esp
80101b7c:	85 c0                	test   %eax,%eax
80101b7e:	75 07                	jne    80101b87 <dirlink+0x2a>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b80:	b8 00 00 00 00       	mov    $0x0,%eax
80101b85:	eb 23                	jmp    80101baa <dirlink+0x4d>
    iput(ip);
80101b87:	83 ec 0c             	sub    $0xc,%esp
80101b8a:	50                   	push   %eax
80101b8b:	e8 03 fb ff ff       	call   80101693 <iput>
    return -1;
80101b90:	83 c4 10             	add    $0x10,%esp
80101b93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b98:	eb 63                	jmp    80101bfd <dirlink+0xa0>
      panic("dirlink read");
80101b9a:	83 ec 0c             	sub    $0xc,%esp
80101b9d:	68 68 69 10 80       	push   $0x80106968
80101ba2:	e8 ae e7 ff ff       	call   80100355 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ba7:	8d 46 10             	lea    0x10(%esi),%eax
80101baa:	89 c6                	mov    %eax,%esi
80101bac:	39 43 58             	cmp    %eax,0x58(%ebx)
80101baf:	76 1c                	jbe    80101bcd <dirlink+0x70>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bb1:	6a 10                	push   $0x10
80101bb3:	50                   	push   %eax
80101bb4:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101bb7:	50                   	push   %eax
80101bb8:	53                   	push   %ebx
80101bb9:	e8 c9 fb ff ff       	call   80101787 <readi>
80101bbe:	83 c4 10             	add    $0x10,%esp
80101bc1:	83 f8 10             	cmp    $0x10,%eax
80101bc4:	75 d4                	jne    80101b9a <dirlink+0x3d>
    if(de.inum == 0)
80101bc6:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bcb:	75 da                	jne    80101ba7 <dirlink+0x4a>
  strncpy(de.name, name, DIRSIZ);
80101bcd:	83 ec 04             	sub    $0x4,%esp
80101bd0:	6a 0e                	push   $0xe
80101bd2:	57                   	push   %edi
80101bd3:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101bd6:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bd9:	50                   	push   %eax
80101bda:	e8 53 22 00 00       	call   80103e32 <strncpy>
  de.inum = inum;
80101bdf:	8b 45 10             	mov    0x10(%ebp),%eax
80101be2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be6:	6a 10                	push   $0x10
80101be8:	56                   	push   %esi
80101be9:	57                   	push   %edi
80101bea:	53                   	push   %ebx
80101beb:	e8 9b fc ff ff       	call   8010188b <writei>
80101bf0:	83 c4 20             	add    $0x20,%esp
80101bf3:	83 f8 10             	cmp    $0x10,%eax
80101bf6:	75 0d                	jne    80101c05 <dirlink+0xa8>
  return 0;
80101bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c00:	5b                   	pop    %ebx
80101c01:	5e                   	pop    %esi
80101c02:	5f                   	pop    %edi
80101c03:	5d                   	pop    %ebp
80101c04:	c3                   	ret    
    panic("dirlink");
80101c05:	83 ec 0c             	sub    $0xc,%esp
80101c08:	68 58 6f 10 80       	push   $0x80106f58
80101c0d:	e8 43 e7 ff ff       	call   80100355 <panic>

80101c12 <namei>:

struct inode*
namei(char *path)
{
80101c12:	f3 0f 1e fb          	endbr32 
80101c16:	55                   	push   %ebp
80101c17:	89 e5                	mov    %esp,%ebp
80101c19:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c1c:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c1f:	ba 00 00 00 00       	mov    $0x0,%edx
80101c24:	8b 45 08             	mov    0x8(%ebp),%eax
80101c27:	e8 48 fe ff ff       	call   80101a74 <namex>
}
80101c2c:	c9                   	leave  
80101c2d:	c3                   	ret    

80101c2e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c2e:	f3 0f 1e fb          	endbr32 
80101c32:	55                   	push   %ebp
80101c33:	89 e5                	mov    %esp,%ebp
80101c35:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c3b:	ba 01 00 00 00       	mov    $0x1,%edx
80101c40:	8b 45 08             	mov    0x8(%ebp),%eax
80101c43:	e8 2c fe ff ff       	call   80101a74 <namex>
}
80101c48:	c9                   	leave  
80101c49:	c3                   	ret    

80101c4a <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101c4a:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c4c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c51:	ec                   	in     (%dx),%al
80101c52:	88 c2                	mov    %al,%dl
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c54:	83 e0 c0             	and    $0xffffffc0,%eax
80101c57:	3c 40                	cmp    $0x40,%al
80101c59:	75 f1                	jne    80101c4c <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c5b:	85 c9                	test   %ecx,%ecx
80101c5d:	74 0a                	je     80101c69 <idewait+0x1f>
80101c5f:	f6 c2 21             	test   $0x21,%dl
80101c62:	75 08                	jne    80101c6c <idewait+0x22>
    return -1;
  return 0;
80101c64:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101c69:	89 c8                	mov    %ecx,%eax
80101c6b:	c3                   	ret    
    return -1;
80101c6c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101c71:	eb f6                	jmp    80101c69 <idewait+0x1f>

80101c73 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101c73:	55                   	push   %ebp
80101c74:	89 e5                	mov    %esp,%ebp
80101c76:	56                   	push   %esi
80101c77:	53                   	push   %ebx
  if(b == 0)
80101c78:	85 c0                	test   %eax,%eax
80101c7a:	0f 84 87 00 00 00    	je     80101d07 <idestart+0x94>
80101c80:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c82:	8b 58 08             	mov    0x8(%eax),%ebx
80101c85:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101c8b:	0f 87 83 00 00 00    	ja     80101d14 <idestart+0xa1>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101c91:	b8 00 00 00 00       	mov    $0x0,%eax
80101c96:	e8 af ff ff ff       	call   80101c4a <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c9b:	b0 00                	mov    $0x0,%al
80101c9d:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ca2:	ee                   	out    %al,(%dx)
80101ca3:	b0 01                	mov    $0x1,%al
80101ca5:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101caa:	ee                   	out    %al,(%dx)
80101cab:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cb0:	88 d8                	mov    %bl,%al
80101cb2:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cb3:	89 d8                	mov    %ebx,%eax
80101cb5:	c1 f8 08             	sar    $0x8,%eax
80101cb8:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101cbd:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101cbe:	89 d8                	mov    %ebx,%eax
80101cc0:	c1 f8 10             	sar    $0x10,%eax
80101cc3:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101cc8:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101cc9:	8a 46 04             	mov    0x4(%esi),%al
80101ccc:	c1 e0 04             	shl    $0x4,%eax
80101ccf:	83 e0 10             	and    $0x10,%eax
80101cd2:	c1 fb 18             	sar    $0x18,%ebx
80101cd5:	83 e3 0f             	and    $0xf,%ebx
80101cd8:	09 d8                	or     %ebx,%eax
80101cda:	83 c8 e0             	or     $0xffffffe0,%eax
80101cdd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ce2:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101ce3:	f6 06 04             	testb  $0x4,(%esi)
80101ce6:	74 39                	je     80101d21 <idestart+0xae>
80101ce8:	b0 30                	mov    $0x30,%al
80101cea:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cef:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101cf0:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101cf3:	b9 80 00 00 00       	mov    $0x80,%ecx
80101cf8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101cfd:	fc                   	cld    
80101cfe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d03:	5b                   	pop    %ebx
80101d04:	5e                   	pop    %esi
80101d05:	5d                   	pop    %ebp
80101d06:	c3                   	ret    
    panic("idestart");
80101d07:	83 ec 0c             	sub    $0xc,%esp
80101d0a:	68 cb 69 10 80       	push   $0x801069cb
80101d0f:	e8 41 e6 ff ff       	call   80100355 <panic>
    panic("incorrect blockno");
80101d14:	83 ec 0c             	sub    $0xc,%esp
80101d17:	68 d4 69 10 80       	push   $0x801069d4
80101d1c:	e8 34 e6 ff ff       	call   80100355 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d21:	b0 20                	mov    $0x20,%al
80101d23:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d28:	ee                   	out    %al,(%dx)
}
80101d29:	eb d5                	jmp    80101d00 <idestart+0x8d>

80101d2b <ideinit>:
{
80101d2b:	f3 0f 1e fb          	endbr32 
80101d2f:	55                   	push   %ebp
80101d30:	89 e5                	mov    %esp,%ebp
80101d32:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d35:	68 e6 69 10 80       	push   $0x801069e6
80101d3a:	68 80 a5 10 80       	push   $0x8010a580
80101d3f:	e8 cb 1d 00 00       	call   80103b0f <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d44:	83 c4 08             	add    $0x8,%esp
80101d47:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101d4c:	48                   	dec    %eax
80101d4d:	50                   	push   %eax
80101d4e:	6a 0e                	push   $0xe
80101d50:	e8 50 02 00 00       	call   80101fa5 <ioapicenable>
  idewait(0);
80101d55:	b8 00 00 00 00       	mov    $0x0,%eax
80101d5a:	e8 eb fe ff ff       	call   80101c4a <idewait>
80101d5f:	b0 f0                	mov    $0xf0,%al
80101d61:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d66:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101d67:	83 c4 10             	add    $0x10,%esp
80101d6a:	b9 00 00 00 00       	mov    $0x0,%ecx
80101d6f:	eb 01                	jmp    80101d72 <ideinit+0x47>
80101d71:	41                   	inc    %ecx
80101d72:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101d78:	7f 14                	jg     80101d8e <ideinit+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d7a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d7f:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101d80:	84 c0                	test   %al,%al
80101d82:	74 ed                	je     80101d71 <ideinit+0x46>
      havedisk1 = 1;
80101d84:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101d8b:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d8e:	b0 e0                	mov    $0xe0,%al
80101d90:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d95:	ee                   	out    %al,(%dx)
}
80101d96:	c9                   	leave  
80101d97:	c3                   	ret    

80101d98 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101d98:	f3 0f 1e fb          	endbr32 
80101d9c:	55                   	push   %ebp
80101d9d:	89 e5                	mov    %esp,%ebp
80101d9f:	57                   	push   %edi
80101da0:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101da1:	83 ec 0c             	sub    $0xc,%esp
80101da4:	68 80 a5 10 80       	push   $0x8010a580
80101da9:	e8 ac 1e 00 00       	call   80103c5a <acquire>

  if((b = idequeue) == 0){
80101dae:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101db4:	83 c4 10             	add    $0x10,%esp
80101db7:	85 db                	test   %ebx,%ebx
80101db9:	74 48                	je     80101e03 <ideintr+0x6b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101dbb:	8b 43 58             	mov    0x58(%ebx),%eax
80101dbe:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101dc3:	f6 03 04             	testb  $0x4,(%ebx)
80101dc6:	74 4d                	je     80101e15 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101dc8:	8b 03                	mov    (%ebx),%eax
80101dca:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101dcd:	83 e0 fb             	and    $0xfffffffb,%eax
80101dd0:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101dd2:	83 ec 0c             	sub    $0xc,%esp
80101dd5:	53                   	push   %ebx
80101dd6:	e8 c0 1a 00 00       	call   8010389b <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101ddb:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101de0:	83 c4 10             	add    $0x10,%esp
80101de3:	85 c0                	test   %eax,%eax
80101de5:	74 05                	je     80101dec <ideintr+0x54>
    idestart(idequeue);
80101de7:	e8 87 fe ff ff       	call   80101c73 <idestart>

  release(&idelock);
80101dec:	83 ec 0c             	sub    $0xc,%esp
80101def:	68 80 a5 10 80       	push   $0x8010a580
80101df4:	e8 ca 1e 00 00       	call   80103cc3 <release>
80101df9:	83 c4 10             	add    $0x10,%esp
}
80101dfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dff:	5b                   	pop    %ebx
80101e00:	5f                   	pop    %edi
80101e01:	5d                   	pop    %ebp
80101e02:	c3                   	ret    
    release(&idelock);
80101e03:	83 ec 0c             	sub    $0xc,%esp
80101e06:	68 80 a5 10 80       	push   $0x8010a580
80101e0b:	e8 b3 1e 00 00       	call   80103cc3 <release>
    return;
80101e10:	83 c4 10             	add    $0x10,%esp
80101e13:	eb e7                	jmp    80101dfc <ideintr+0x64>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e15:	b8 01 00 00 00       	mov    $0x1,%eax
80101e1a:	e8 2b fe ff ff       	call   80101c4a <idewait>
80101e1f:	85 c0                	test   %eax,%eax
80101e21:	78 a5                	js     80101dc8 <ideintr+0x30>
    insl(0x1f0, b->data, BSIZE/4);
80101e23:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e26:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e2b:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e30:	fc                   	cld    
80101e31:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101e33:	eb 93                	jmp    80101dc8 <ideintr+0x30>

80101e35 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e35:	f3 0f 1e fb          	endbr32 
80101e39:	55                   	push   %ebp
80101e3a:	89 e5                	mov    %esp,%ebp
80101e3c:	53                   	push   %ebx
80101e3d:	83 ec 10             	sub    $0x10,%esp
80101e40:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e43:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e46:	50                   	push   %eax
80101e47:	e8 71 1c 00 00       	call   80103abd <holdingsleep>
80101e4c:	83 c4 10             	add    $0x10,%esp
80101e4f:	85 c0                	test   %eax,%eax
80101e51:	74 37                	je     80101e8a <iderw+0x55>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101e53:	8b 03                	mov    (%ebx),%eax
80101e55:	83 e0 06             	and    $0x6,%eax
80101e58:	83 f8 02             	cmp    $0x2,%eax
80101e5b:	74 3a                	je     80101e97 <iderw+0x62>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101e5d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101e61:	74 09                	je     80101e6c <iderw+0x37>
80101e63:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101e6a:	74 38                	je     80101ea4 <iderw+0x6f>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101e6c:	83 ec 0c             	sub    $0xc,%esp
80101e6f:	68 80 a5 10 80       	push   $0x8010a580
80101e74:	e8 e1 1d 00 00       	call   80103c5a <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101e79:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e80:	83 c4 10             	add    $0x10,%esp
80101e83:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101e88:	eb 2a                	jmp    80101eb4 <iderw+0x7f>
    panic("iderw: buf not locked");
80101e8a:	83 ec 0c             	sub    $0xc,%esp
80101e8d:	68 ea 69 10 80       	push   $0x801069ea
80101e92:	e8 be e4 ff ff       	call   80100355 <panic>
    panic("iderw: nothing to do");
80101e97:	83 ec 0c             	sub    $0xc,%esp
80101e9a:	68 00 6a 10 80       	push   $0x80106a00
80101e9f:	e8 b1 e4 ff ff       	call   80100355 <panic>
    panic("iderw: ide disk 1 not present");
80101ea4:	83 ec 0c             	sub    $0xc,%esp
80101ea7:	68 15 6a 10 80       	push   $0x80106a15
80101eac:	e8 a4 e4 ff ff       	call   80100355 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101eb1:	8d 50 58             	lea    0x58(%eax),%edx
80101eb4:	8b 02                	mov    (%edx),%eax
80101eb6:	85 c0                	test   %eax,%eax
80101eb8:	75 f7                	jne    80101eb1 <iderw+0x7c>
    ;
  *pp = b;
80101eba:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101ebc:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101ec2:	75 1a                	jne    80101ede <iderw+0xa9>
    idestart(b);
80101ec4:	89 d8                	mov    %ebx,%eax
80101ec6:	e8 a8 fd ff ff       	call   80101c73 <idestart>
80101ecb:	eb 11                	jmp    80101ede <iderw+0xa9>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101ecd:	83 ec 08             	sub    $0x8,%esp
80101ed0:	68 80 a5 10 80       	push   $0x8010a580
80101ed5:	53                   	push   %ebx
80101ed6:	e8 49 18 00 00       	call   80103724 <sleep>
80101edb:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101ede:	8b 03                	mov    (%ebx),%eax
80101ee0:	83 e0 06             	and    $0x6,%eax
80101ee3:	83 f8 02             	cmp    $0x2,%eax
80101ee6:	75 e5                	jne    80101ecd <iderw+0x98>
  }


  release(&idelock);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	68 80 a5 10 80       	push   $0x8010a580
80101ef0:	e8 ce 1d 00 00       	call   80103cc3 <release>
}
80101ef5:	83 c4 10             	add    $0x10,%esp
80101ef8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101efb:	c9                   	leave  
80101efc:	c3                   	ret    

80101efd <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101efd:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80101f03:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101f05:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f0a:	8b 40 10             	mov    0x10(%eax),%eax
}
80101f0d:	c3                   	ret    

80101f0e <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101f0e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101f14:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101f16:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f1b:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f1e:	c3                   	ret    

80101f1f <ioapicinit>:

void
ioapicinit(void)
{
80101f1f:	f3 0f 1e fb          	endbr32 
80101f23:	55                   	push   %ebp
80101f24:	89 e5                	mov    %esp,%ebp
80101f26:	57                   	push   %edi
80101f27:	56                   	push   %esi
80101f28:	53                   	push   %ebx
80101f29:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f2c:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101f33:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f36:	b8 01 00 00 00       	mov    $0x1,%eax
80101f3b:	e8 bd ff ff ff       	call   80101efd <ioapicread>
80101f40:	c1 e8 10             	shr    $0x10,%eax
80101f43:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f46:	b8 00 00 00 00       	mov    $0x0,%eax
80101f4b:	e8 ad ff ff ff       	call   80101efd <ioapicread>
80101f50:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101f53:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80101f5a:	39 c2                	cmp    %eax,%edx
80101f5c:	75 2d                	jne    80101f8b <ioapicinit+0x6c>
{
80101f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80101f63:	39 fb                	cmp    %edi,%ebx
80101f65:	7f 36                	jg     80101f9d <ioapicinit+0x7e>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101f67:	8d 53 20             	lea    0x20(%ebx),%edx
80101f6a:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101f70:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101f74:	89 f0                	mov    %esi,%eax
80101f76:	e8 93 ff ff ff       	call   80101f0e <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101f7b:	8d 46 01             	lea    0x1(%esi),%eax
80101f7e:	ba 00 00 00 00       	mov    $0x0,%edx
80101f83:	e8 86 ff ff ff       	call   80101f0e <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101f88:	43                   	inc    %ebx
80101f89:	eb d8                	jmp    80101f63 <ioapicinit+0x44>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101f8b:	83 ec 0c             	sub    $0xc,%esp
80101f8e:	68 34 6a 10 80       	push   $0x80106a34
80101f93:	e8 65 e6 ff ff       	call   801005fd <cprintf>
80101f98:	83 c4 10             	add    $0x10,%esp
80101f9b:	eb c1                	jmp    80101f5e <ioapicinit+0x3f>
  }
}
80101f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa0:	5b                   	pop    %ebx
80101fa1:	5e                   	pop    %esi
80101fa2:	5f                   	pop    %edi
80101fa3:	5d                   	pop    %ebp
80101fa4:	c3                   	ret    

80101fa5 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101fa5:	f3 0f 1e fb          	endbr32 
80101fa9:	55                   	push   %ebp
80101faa:	89 e5                	mov    %esp,%ebp
80101fac:	53                   	push   %ebx
80101fad:	83 ec 04             	sub    $0x4,%esp
80101fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101fb3:	8d 50 20             	lea    0x20(%eax),%edx
80101fb6:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101fba:	89 d8                	mov    %ebx,%eax
80101fbc:	e8 4d ff ff ff       	call   80101f0e <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fc4:	c1 e2 18             	shl    $0x18,%edx
80101fc7:	8d 43 01             	lea    0x1(%ebx),%eax
80101fca:	e8 3f ff ff ff       	call   80101f0e <ioapicwrite>
}
80101fcf:	83 c4 04             	add    $0x4,%esp
80101fd2:	5b                   	pop    %ebx
80101fd3:	5d                   	pop    %ebp
80101fd4:	c3                   	ret    

80101fd5 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101fd5:	f3 0f 1e fb          	endbr32 
80101fd9:	55                   	push   %ebp
80101fda:	89 e5                	mov    %esp,%ebp
80101fdc:	53                   	push   %ebx
80101fdd:	83 ec 04             	sub    $0x4,%esp
80101fe0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101fe3:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101fe9:	75 4c                	jne    80102037 <kfree+0x62>
80101feb:	81 fb a8 55 11 80    	cmp    $0x801155a8,%ebx
80101ff1:	72 44                	jb     80102037 <kfree+0x62>
80101ff3:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101ff9:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101ffe:	77 37                	ja     80102037 <kfree+0x62>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102000:	83 ec 04             	sub    $0x4,%esp
80102003:	68 00 10 00 00       	push   $0x1000
80102008:	6a 01                	push   $0x1
8010200a:	53                   	push   %ebx
8010200b:	e8 fe 1c 00 00       	call   80103d0e <memset>

  if(kmem.use_lock)
80102010:	83 c4 10             	add    $0x10,%esp
80102013:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010201a:	75 28                	jne    80102044 <kfree+0x6f>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010201c:	a1 78 26 11 80       	mov    0x80112678,%eax
80102021:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102023:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102029:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102030:	75 24                	jne    80102056 <kfree+0x81>
    release(&kmem.lock);
}
80102032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102035:	c9                   	leave  
80102036:	c3                   	ret    
    panic("kfree");
80102037:	83 ec 0c             	sub    $0xc,%esp
8010203a:	68 66 6a 10 80       	push   $0x80106a66
8010203f:	e8 11 e3 ff ff       	call   80100355 <panic>
    acquire(&kmem.lock);
80102044:	83 ec 0c             	sub    $0xc,%esp
80102047:	68 40 26 11 80       	push   $0x80112640
8010204c:	e8 09 1c 00 00       	call   80103c5a <acquire>
80102051:	83 c4 10             	add    $0x10,%esp
80102054:	eb c6                	jmp    8010201c <kfree+0x47>
    release(&kmem.lock);
80102056:	83 ec 0c             	sub    $0xc,%esp
80102059:	68 40 26 11 80       	push   $0x80112640
8010205e:	e8 60 1c 00 00       	call   80103cc3 <release>
80102063:	83 c4 10             	add    $0x10,%esp
}
80102066:	eb ca                	jmp    80102032 <kfree+0x5d>

80102068 <freerange>:
{
80102068:	f3 0f 1e fb          	endbr32 
8010206c:	55                   	push   %ebp
8010206d:	89 e5                	mov    %esp,%ebp
8010206f:	56                   	push   %esi
80102070:	53                   	push   %ebx
80102071:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102074:	8b 45 08             	mov    0x8(%ebp),%eax
80102077:	05 ff 0f 00 00       	add    $0xfff,%eax
8010207c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102081:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80102087:	39 de                	cmp    %ebx,%esi
80102089:	77 10                	ja     8010209b <freerange+0x33>
    kfree(p);
8010208b:	83 ec 0c             	sub    $0xc,%esp
8010208e:	50                   	push   %eax
8010208f:	e8 41 ff ff ff       	call   80101fd5 <kfree>
80102094:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102097:	89 f0                	mov    %esi,%eax
80102099:	eb e6                	jmp    80102081 <freerange+0x19>
}
8010209b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010209e:	5b                   	pop    %ebx
8010209f:	5e                   	pop    %esi
801020a0:	5d                   	pop    %ebp
801020a1:	c3                   	ret    

801020a2 <kinit1>:
{
801020a2:	f3 0f 1e fb          	endbr32 
801020a6:	55                   	push   %ebp
801020a7:	89 e5                	mov    %esp,%ebp
801020a9:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
801020ac:	68 6c 6a 10 80       	push   $0x80106a6c
801020b1:	68 40 26 11 80       	push   $0x80112640
801020b6:	e8 54 1a 00 00       	call   80103b0f <initlock>
  kmem.use_lock = 0;
801020bb:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801020c2:	00 00 00 
  freerange(vstart, vend);
801020c5:	83 c4 08             	add    $0x8,%esp
801020c8:	ff 75 0c             	pushl  0xc(%ebp)
801020cb:	ff 75 08             	pushl  0x8(%ebp)
801020ce:	e8 95 ff ff ff       	call   80102068 <freerange>
}
801020d3:	83 c4 10             	add    $0x10,%esp
801020d6:	c9                   	leave  
801020d7:	c3                   	ret    

801020d8 <kinit2>:
{
801020d8:	f3 0f 1e fb          	endbr32 
801020dc:	55                   	push   %ebp
801020dd:	89 e5                	mov    %esp,%ebp
801020df:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
801020e2:	ff 75 0c             	pushl  0xc(%ebp)
801020e5:	ff 75 08             	pushl  0x8(%ebp)
801020e8:	e8 7b ff ff ff       	call   80102068 <freerange>
  kmem.use_lock = 1;
801020ed:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801020f4:	00 00 00 
}
801020f7:	83 c4 10             	add    $0x10,%esp
801020fa:	c9                   	leave  
801020fb:	c3                   	ret    

801020fc <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801020fc:	f3 0f 1e fb          	endbr32 
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	53                   	push   %ebx
80102104:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102107:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010210e:	75 21                	jne    80102131 <kalloc+0x35>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102110:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102116:	85 db                	test   %ebx,%ebx
80102118:	74 07                	je     80102121 <kalloc+0x25>
    kmem.freelist = r->next;
8010211a:	8b 03                	mov    (%ebx),%eax
8010211c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
80102121:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102128:	75 19                	jne    80102143 <kalloc+0x47>
    release(&kmem.lock);
  return (char*)r;
}
8010212a:	89 d8                	mov    %ebx,%eax
8010212c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010212f:	c9                   	leave  
80102130:	c3                   	ret    
    acquire(&kmem.lock);
80102131:	83 ec 0c             	sub    $0xc,%esp
80102134:	68 40 26 11 80       	push   $0x80112640
80102139:	e8 1c 1b 00 00       	call   80103c5a <acquire>
8010213e:	83 c4 10             	add    $0x10,%esp
80102141:	eb cd                	jmp    80102110 <kalloc+0x14>
    release(&kmem.lock);
80102143:	83 ec 0c             	sub    $0xc,%esp
80102146:	68 40 26 11 80       	push   $0x80112640
8010214b:	e8 73 1b 00 00       	call   80103cc3 <release>
80102150:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102153:	eb d5                	jmp    8010212a <kalloc+0x2e>

80102155 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102155:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102159:	ba 64 00 00 00       	mov    $0x64,%edx
8010215e:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010215f:	a8 01                	test   $0x1,%al
80102161:	0f 84 ac 00 00 00    	je     80102213 <kbdgetc+0xbe>
80102167:	ba 60 00 00 00       	mov    $0x60,%edx
8010216c:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010216d:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102170:	3c e0                	cmp    $0xe0,%al
80102172:	74 5b                	je     801021cf <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102174:	84 c0                	test   %al,%al
80102176:	78 64                	js     801021dc <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102178:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
8010217e:	f6 c1 40             	test   $0x40,%cl
80102181:	74 0f                	je     80102192 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102183:	83 c8 80             	or     $0xffffff80,%eax
80102186:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
80102189:	83 e1 bf             	and    $0xffffffbf,%ecx
8010218c:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
80102192:	0f b6 8a a0 6b 10 80 	movzbl -0x7fef9460(%edx),%ecx
80102199:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
8010219f:	0f b6 82 a0 6a 10 80 	movzbl -0x7fef9560(%edx),%eax
801021a6:	31 c1                	xor    %eax,%ecx
801021a8:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801021ae:	89 c8                	mov    %ecx,%eax
801021b0:	83 e0 03             	and    $0x3,%eax
801021b3:	8b 04 85 80 6a 10 80 	mov    -0x7fef9580(,%eax,4),%eax
801021ba:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801021be:	f6 c1 08             	test   $0x8,%cl
801021c1:	74 55                	je     80102218 <kbdgetc+0xc3>
    if('a' <= c && c <= 'z')
801021c3:	8d 50 9f             	lea    -0x61(%eax),%edx
801021c6:	83 fa 19             	cmp    $0x19,%edx
801021c9:	77 3c                	ja     80102207 <kbdgetc+0xb2>
      c += 'A' - 'a';
801021cb:	83 e8 20             	sub    $0x20,%eax
801021ce:	c3                   	ret    
    shift |= E0ESC;
801021cf:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801021d6:	b8 00 00 00 00       	mov    $0x0,%eax
801021db:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801021dc:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
801021e2:	f6 c1 40             	test   $0x40,%cl
801021e5:	75 05                	jne    801021ec <kbdgetc+0x97>
801021e7:	89 c2                	mov    %eax,%edx
801021e9:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801021ec:	8a 82 a0 6b 10 80    	mov    -0x7fef9460(%edx),%al
801021f2:	83 c8 40             	or     $0x40,%eax
801021f5:	0f b6 c0             	movzbl %al,%eax
801021f8:	f7 d0                	not    %eax
801021fa:	21 c8                	and    %ecx,%eax
801021fc:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
80102201:	b8 00 00 00 00       	mov    $0x0,%eax
80102206:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102207:	8d 50 bf             	lea    -0x41(%eax),%edx
8010220a:	83 fa 19             	cmp    $0x19,%edx
8010220d:	77 09                	ja     80102218 <kbdgetc+0xc3>
      c += 'a' - 'A';
8010220f:	83 c0 20             	add    $0x20,%eax
  }
  return c;
80102212:	c3                   	ret    
    return -1;
80102213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102218:	c3                   	ret    

80102219 <kbdintr>:

void
kbdintr(void)
{
80102219:	f3 0f 1e fb          	endbr32 
8010221d:	55                   	push   %ebp
8010221e:	89 e5                	mov    %esp,%ebp
80102220:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102223:	68 55 21 10 80       	push   $0x80102155
80102228:	e8 f9 e4 ff ff       	call   80100726 <consoleintr>
}
8010222d:	83 c4 10             	add    $0x10,%esp
80102230:	c9                   	leave  
80102231:	c3                   	ret    

80102232 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102232:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
80102238:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010223b:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010223d:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102242:	8b 40 20             	mov    0x20(%eax),%eax
}
80102245:	c3                   	ret    

80102246 <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102246:	ba 70 00 00 00       	mov    $0x70,%edx
8010224b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224c:	ba 71 00 00 00       	mov    $0x71,%edx
80102251:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102252:	0f b6 c0             	movzbl %al,%eax
}
80102255:	c3                   	ret    

80102256 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
80102256:	55                   	push   %ebp
80102257:	89 e5                	mov    %esp,%ebp
80102259:	53                   	push   %ebx
8010225a:	83 ec 04             	sub    $0x4,%esp
8010225d:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
8010225f:	b8 00 00 00 00       	mov    $0x0,%eax
80102264:	e8 dd ff ff ff       	call   80102246 <cmos_read>
80102269:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
8010226b:	b8 02 00 00 00       	mov    $0x2,%eax
80102270:	e8 d1 ff ff ff       	call   80102246 <cmos_read>
80102275:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
80102278:	b8 04 00 00 00       	mov    $0x4,%eax
8010227d:	e8 c4 ff ff ff       	call   80102246 <cmos_read>
80102282:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
80102285:	b8 07 00 00 00       	mov    $0x7,%eax
8010228a:	e8 b7 ff ff ff       	call   80102246 <cmos_read>
8010228f:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
80102292:	b8 08 00 00 00       	mov    $0x8,%eax
80102297:	e8 aa ff ff ff       	call   80102246 <cmos_read>
8010229c:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
8010229f:	b8 09 00 00 00       	mov    $0x9,%eax
801022a4:	e8 9d ff ff ff       	call   80102246 <cmos_read>
801022a9:	89 43 14             	mov    %eax,0x14(%ebx)
}
801022ac:	83 c4 04             	add    $0x4,%esp
801022af:	5b                   	pop    %ebx
801022b0:	5d                   	pop    %ebp
801022b1:	c3                   	ret    

801022b2 <lapicinit>:
{
801022b2:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801022b6:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
801022bd:	0f 84 fe 00 00 00    	je     801023c1 <lapicinit+0x10f>
{
801022c3:	55                   	push   %ebp
801022c4:	89 e5                	mov    %esp,%ebp
801022c6:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801022c9:	ba 3f 01 00 00       	mov    $0x13f,%edx
801022ce:	b8 3c 00 00 00       	mov    $0x3c,%eax
801022d3:	e8 5a ff ff ff       	call   80102232 <lapicw>
  lapicw(TDCR, X1);
801022d8:	ba 0b 00 00 00       	mov    $0xb,%edx
801022dd:	b8 f8 00 00 00       	mov    $0xf8,%eax
801022e2:	e8 4b ff ff ff       	call   80102232 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801022e7:	ba 20 00 02 00       	mov    $0x20020,%edx
801022ec:	b8 c8 00 00 00       	mov    $0xc8,%eax
801022f1:	e8 3c ff ff ff       	call   80102232 <lapicw>
  lapicw(TICR, 10000000);
801022f6:	ba 80 96 98 00       	mov    $0x989680,%edx
801022fb:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102300:	e8 2d ff ff ff       	call   80102232 <lapicw>
  lapicw(LINT0, MASKED);
80102305:	ba 00 00 01 00       	mov    $0x10000,%edx
8010230a:	b8 d4 00 00 00       	mov    $0xd4,%eax
8010230f:	e8 1e ff ff ff       	call   80102232 <lapicw>
  lapicw(LINT1, MASKED);
80102314:	ba 00 00 01 00       	mov    $0x10000,%edx
80102319:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010231e:	e8 0f ff ff ff       	call   80102232 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102323:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102328:	8b 40 30             	mov    0x30(%eax),%eax
8010232b:	c1 e8 10             	shr    $0x10,%eax
8010232e:	a8 fc                	test   $0xfc,%al
80102330:	75 7b                	jne    801023ad <lapicinit+0xfb>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102332:	ba 33 00 00 00       	mov    $0x33,%edx
80102337:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010233c:	e8 f1 fe ff ff       	call   80102232 <lapicw>
  lapicw(ESR, 0);
80102341:	ba 00 00 00 00       	mov    $0x0,%edx
80102346:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010234b:	e8 e2 fe ff ff       	call   80102232 <lapicw>
  lapicw(ESR, 0);
80102350:	ba 00 00 00 00       	mov    $0x0,%edx
80102355:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010235a:	e8 d3 fe ff ff       	call   80102232 <lapicw>
  lapicw(EOI, 0);
8010235f:	ba 00 00 00 00       	mov    $0x0,%edx
80102364:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102369:	e8 c4 fe ff ff       	call   80102232 <lapicw>
  lapicw(ICRHI, 0);
8010236e:	ba 00 00 00 00       	mov    $0x0,%edx
80102373:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102378:	e8 b5 fe ff ff       	call   80102232 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010237d:	ba 00 85 08 00       	mov    $0x88500,%edx
80102382:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102387:	e8 a6 fe ff ff       	call   80102232 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010238c:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102391:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
80102397:	f6 c4 10             	test   $0x10,%ah
8010239a:	75 f0                	jne    8010238c <lapicinit+0xda>
  lapicw(TPR, 0);
8010239c:	ba 00 00 00 00       	mov    $0x0,%edx
801023a1:	b8 20 00 00 00       	mov    $0x20,%eax
801023a6:	e8 87 fe ff ff       	call   80102232 <lapicw>
}
801023ab:	c9                   	leave  
801023ac:	c3                   	ret    
    lapicw(PCINT, MASKED);
801023ad:	ba 00 00 01 00       	mov    $0x10000,%edx
801023b2:	b8 d0 00 00 00       	mov    $0xd0,%eax
801023b7:	e8 76 fe ff ff       	call   80102232 <lapicw>
801023bc:	e9 71 ff ff ff       	jmp    80102332 <lapicinit+0x80>
801023c1:	c3                   	ret    

801023c2 <lapicid>:
{
801023c2:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801023c6:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801023cb:	85 c0                	test   %eax,%eax
801023cd:	74 07                	je     801023d6 <lapicid+0x14>
  return lapic[ID] >> 24;
801023cf:	8b 40 20             	mov    0x20(%eax),%eax
801023d2:	c1 e8 18             	shr    $0x18,%eax
801023d5:	c3                   	ret    
    return 0;
801023d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023db:	c3                   	ret    

801023dc <lapiceoi>:
{
801023dc:	f3 0f 1e fb          	endbr32 
  if(lapic)
801023e0:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
801023e7:	74 17                	je     80102400 <lapiceoi+0x24>
{
801023e9:	55                   	push   %ebp
801023ea:	89 e5                	mov    %esp,%ebp
801023ec:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
801023ef:	ba 00 00 00 00       	mov    $0x0,%edx
801023f4:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023f9:	e8 34 fe ff ff       	call   80102232 <lapicw>
}
801023fe:	c9                   	leave  
801023ff:	c3                   	ret    
80102400:	c3                   	ret    

80102401 <microdelay>:
{
80102401:	f3 0f 1e fb          	endbr32 
}
80102405:	c3                   	ret    

80102406 <lapicstartap>:
{
80102406:	f3 0f 1e fb          	endbr32 
8010240a:	55                   	push   %ebp
8010240b:	89 e5                	mov    %esp,%ebp
8010240d:	57                   	push   %edi
8010240e:	56                   	push   %esi
8010240f:	53                   	push   %ebx
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	8b 75 08             	mov    0x8(%ebp),%esi
80102416:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102419:	b0 0f                	mov    $0xf,%al
8010241b:	ba 70 00 00 00       	mov    $0x70,%edx
80102420:	ee                   	out    %al,(%dx)
80102421:	b0 0a                	mov    $0xa,%al
80102423:	ba 71 00 00 00       	mov    $0x71,%edx
80102428:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102429:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102430:	00 00 
  wrv[1] = addr >> 4;
80102432:	89 f8                	mov    %edi,%eax
80102434:	c1 e8 04             	shr    $0x4,%eax
80102437:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
8010243d:	c1 e6 18             	shl    $0x18,%esi
80102440:	89 f2                	mov    %esi,%edx
80102442:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102447:	e8 e6 fd ff ff       	call   80102232 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010244c:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102451:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102456:	e8 d7 fd ff ff       	call   80102232 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
8010245b:	ba 00 85 00 00       	mov    $0x8500,%edx
80102460:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102465:	e8 c8 fd ff ff       	call   80102232 <lapicw>
  for(i = 0; i < 2; i++){
8010246a:	bb 00 00 00 00       	mov    $0x0,%ebx
8010246f:	eb 1f                	jmp    80102490 <lapicstartap+0x8a>
    lapicw(ICRHI, apicid<<24);
80102471:	89 f2                	mov    %esi,%edx
80102473:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102478:	e8 b5 fd ff ff       	call   80102232 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010247d:	89 fa                	mov    %edi,%edx
8010247f:	c1 ea 0c             	shr    $0xc,%edx
80102482:	80 ce 06             	or     $0x6,%dh
80102485:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010248a:	e8 a3 fd ff ff       	call   80102232 <lapicw>
  for(i = 0; i < 2; i++){
8010248f:	43                   	inc    %ebx
80102490:	83 fb 01             	cmp    $0x1,%ebx
80102493:	7e dc                	jle    80102471 <lapicstartap+0x6b>
}
80102495:	83 c4 0c             	add    $0xc,%esp
80102498:	5b                   	pop    %ebx
80102499:	5e                   	pop    %esi
8010249a:	5f                   	pop    %edi
8010249b:	5d                   	pop    %ebp
8010249c:	c3                   	ret    

8010249d <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
8010249d:	f3 0f 1e fb          	endbr32 
801024a1:	55                   	push   %ebp
801024a2:	89 e5                	mov    %esp,%ebp
801024a4:	57                   	push   %edi
801024a5:	56                   	push   %esi
801024a6:	53                   	push   %ebx
801024a7:	83 ec 3c             	sub    $0x3c,%esp
801024aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801024ad:	b8 0b 00 00 00       	mov    $0xb,%eax
801024b2:	e8 8f fd ff ff       	call   80102246 <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
801024b7:	83 e0 04             	and    $0x4,%eax
801024ba:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801024bc:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024bf:	e8 92 fd ff ff       	call   80102256 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801024c4:	b8 0a 00 00 00       	mov    $0xa,%eax
801024c9:	e8 78 fd ff ff       	call   80102246 <cmos_read>
801024ce:	a8 80                	test   $0x80,%al
801024d0:	75 ea                	jne    801024bc <cmostime+0x1f>
        continue;
    fill_rtcdate(&t2);
801024d2:	8d 75 b8             	lea    -0x48(%ebp),%esi
801024d5:	89 f0                	mov    %esi,%eax
801024d7:	e8 7a fd ff ff       	call   80102256 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801024dc:	83 ec 04             	sub    $0x4,%esp
801024df:	6a 18                	push   $0x18
801024e1:	56                   	push   %esi
801024e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024e5:	50                   	push   %eax
801024e6:	e8 6e 18 00 00       	call   80103d59 <memcmp>
801024eb:	83 c4 10             	add    $0x10,%esp
801024ee:	85 c0                	test   %eax,%eax
801024f0:	75 ca                	jne    801024bc <cmostime+0x1f>
      break;
  }

  // convert
  if(bcd) {
801024f2:	85 ff                	test   %edi,%edi
801024f4:	75 7e                	jne    80102574 <cmostime+0xd7>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801024f6:	8b 55 d0             	mov    -0x30(%ebp),%edx
801024f9:	89 d0                	mov    %edx,%eax
801024fb:	c1 e8 04             	shr    $0x4,%eax
801024fe:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102501:	01 c0                	add    %eax,%eax
80102503:	83 e2 0f             	and    $0xf,%edx
80102506:	01 d0                	add    %edx,%eax
80102508:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010250b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010250e:	89 d0                	mov    %edx,%eax
80102510:	c1 e8 04             	shr    $0x4,%eax
80102513:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102516:	01 c0                	add    %eax,%eax
80102518:	83 e2 0f             	and    $0xf,%edx
8010251b:	01 d0                	add    %edx,%eax
8010251d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
80102520:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102523:	89 d0                	mov    %edx,%eax
80102525:	c1 e8 04             	shr    $0x4,%eax
80102528:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010252b:	01 c0                	add    %eax,%eax
8010252d:	83 e2 0f             	and    $0xf,%edx
80102530:	01 d0                	add    %edx,%eax
80102532:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102535:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102538:	89 d0                	mov    %edx,%eax
8010253a:	c1 e8 04             	shr    $0x4,%eax
8010253d:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102540:	01 c0                	add    %eax,%eax
80102542:	83 e2 0f             	and    $0xf,%edx
80102545:	01 d0                	add    %edx,%eax
80102547:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
8010254a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010254d:	89 d0                	mov    %edx,%eax
8010254f:	c1 e8 04             	shr    $0x4,%eax
80102552:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102555:	01 c0                	add    %eax,%eax
80102557:	83 e2 0f             	and    $0xf,%edx
8010255a:	01 d0                	add    %edx,%eax
8010255c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
8010255f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102562:	89 d0                	mov    %edx,%eax
80102564:	c1 e8 04             	shr    $0x4,%eax
80102567:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010256a:	01 c0                	add    %eax,%eax
8010256c:	83 e2 0f             	and    $0xf,%edx
8010256f:	01 d0                	add    %edx,%eax
80102571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102574:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102577:	b9 06 00 00 00       	mov    $0x6,%ecx
8010257c:	89 df                	mov    %ebx,%edi
8010257e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
80102580:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102587:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010258a:	5b                   	pop    %ebx
8010258b:	5e                   	pop    %esi
8010258c:	5f                   	pop    %edi
8010258d:	5d                   	pop    %ebp
8010258e:	c3                   	ret    

8010258f <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010258f:	55                   	push   %ebp
80102590:	89 e5                	mov    %esp,%ebp
80102592:	53                   	push   %ebx
80102593:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102596:	ff 35 b4 26 11 80    	pushl  0x801126b4
8010259c:	ff 35 c4 26 11 80    	pushl  0x801126c4
801025a2:	e8 c7 db ff ff       	call   8010016e <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801025a7:	8b 58 5c             	mov    0x5c(%eax),%ebx
801025aa:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
801025b0:	83 c4 10             	add    $0x10,%esp
801025b3:	ba 00 00 00 00       	mov    $0x0,%edx
801025b8:	39 d3                	cmp    %edx,%ebx
801025ba:	7e 0e                	jle    801025ca <read_head+0x3b>
    log.lh.block[i] = lh->block[i];
801025bc:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801025c0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801025c7:	42                   	inc    %edx
801025c8:	eb ee                	jmp    801025b8 <read_head+0x29>
  }
  brelse(buf);
801025ca:	83 ec 0c             	sub    $0xc,%esp
801025cd:	50                   	push   %eax
801025ce:	e8 0c dc ff ff       	call   801001df <brelse>
}
801025d3:	83 c4 10             	add    $0x10,%esp
801025d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025d9:	c9                   	leave  
801025da:	c3                   	ret    

801025db <install_trans>:
{
801025db:	55                   	push   %ebp
801025dc:	89 e5                	mov    %esp,%ebp
801025de:	57                   	push   %edi
801025df:	56                   	push   %esi
801025e0:	53                   	push   %ebx
801025e1:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801025e4:	be 00 00 00 00       	mov    $0x0,%esi
801025e9:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
801025ef:	7e 64                	jle    80102655 <install_trans+0x7a>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801025f1:	89 f0                	mov    %esi,%eax
801025f3:	03 05 b4 26 11 80    	add    0x801126b4,%eax
801025f9:	40                   	inc    %eax
801025fa:	83 ec 08             	sub    $0x8,%esp
801025fd:	50                   	push   %eax
801025fe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102604:	e8 65 db ff ff       	call   8010016e <bread>
80102609:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010260b:	83 c4 08             	add    $0x8,%esp
8010260e:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
80102615:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010261b:	e8 4e db ff ff       	call   8010016e <bread>
80102620:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102622:	8d 57 5c             	lea    0x5c(%edi),%edx
80102625:	8d 40 5c             	lea    0x5c(%eax),%eax
80102628:	83 c4 0c             	add    $0xc,%esp
8010262b:	68 00 02 00 00       	push   $0x200
80102630:	52                   	push   %edx
80102631:	50                   	push   %eax
80102632:	e8 55 17 00 00       	call   80103d8c <memmove>
    bwrite(dbuf);  // write dst to disk
80102637:	89 1c 24             	mov    %ebx,(%esp)
8010263a:	e8 61 db ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
8010263f:	89 3c 24             	mov    %edi,(%esp)
80102642:	e8 98 db ff ff       	call   801001df <brelse>
    brelse(dbuf);
80102647:	89 1c 24             	mov    %ebx,(%esp)
8010264a:	e8 90 db ff ff       	call   801001df <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010264f:	46                   	inc    %esi
80102650:	83 c4 10             	add    $0x10,%esp
80102653:	eb 94                	jmp    801025e9 <install_trans+0xe>
}
80102655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102658:	5b                   	pop    %ebx
80102659:	5e                   	pop    %esi
8010265a:	5f                   	pop    %edi
8010265b:	5d                   	pop    %ebp
8010265c:	c3                   	ret    

8010265d <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010265d:	55                   	push   %ebp
8010265e:	89 e5                	mov    %esp,%ebp
80102660:	53                   	push   %ebx
80102661:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102664:	ff 35 b4 26 11 80    	pushl  0x801126b4
8010266a:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102670:	e8 f9 da ff ff       	call   8010016e <bread>
80102675:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102677:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
8010267d:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102680:	83 c4 10             	add    $0x10,%esp
80102683:	b8 00 00 00 00       	mov    $0x0,%eax
80102688:	39 c1                	cmp    %eax,%ecx
8010268a:	7e 0e                	jle    8010269a <write_head+0x3d>
    hb->block[i] = log.lh.block[i];
8010268c:	8b 14 85 cc 26 11 80 	mov    -0x7feed934(,%eax,4),%edx
80102693:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102697:	40                   	inc    %eax
80102698:	eb ee                	jmp    80102688 <write_head+0x2b>
  }
  bwrite(buf);
8010269a:	83 ec 0c             	sub    $0xc,%esp
8010269d:	53                   	push   %ebx
8010269e:	e8 fd da ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801026a3:	89 1c 24             	mov    %ebx,(%esp)
801026a6:	e8 34 db ff ff       	call   801001df <brelse>
}
801026ab:	83 c4 10             	add    $0x10,%esp
801026ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026b1:	c9                   	leave  
801026b2:	c3                   	ret    

801026b3 <recover_from_log>:

static void
recover_from_log(void)
{
801026b3:	55                   	push   %ebp
801026b4:	89 e5                	mov    %esp,%ebp
801026b6:	83 ec 08             	sub    $0x8,%esp
  read_head();
801026b9:	e8 d1 fe ff ff       	call   8010258f <read_head>
  install_trans(); // if committed, copy from log to disk
801026be:	e8 18 ff ff ff       	call   801025db <install_trans>
  log.lh.n = 0;
801026c3:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
801026ca:	00 00 00 
  write_head(); // clear the log
801026cd:	e8 8b ff ff ff       	call   8010265d <write_head>
}
801026d2:	c9                   	leave  
801026d3:	c3                   	ret    

801026d4 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801026d4:	55                   	push   %ebp
801026d5:	89 e5                	mov    %esp,%ebp
801026d7:	57                   	push   %edi
801026d8:	56                   	push   %esi
801026d9:	53                   	push   %ebx
801026da:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026dd:	be 00 00 00 00       	mov    $0x0,%esi
801026e2:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
801026e8:	7e 64                	jle    8010274e <write_log+0x7a>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801026ea:	89 f0                	mov    %esi,%eax
801026ec:	03 05 b4 26 11 80    	add    0x801126b4,%eax
801026f2:	40                   	inc    %eax
801026f3:	83 ec 08             	sub    $0x8,%esp
801026f6:	50                   	push   %eax
801026f7:	ff 35 c4 26 11 80    	pushl  0x801126c4
801026fd:	e8 6c da ff ff       	call   8010016e <bread>
80102702:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102704:	83 c4 08             	add    $0x8,%esp
80102707:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
8010270e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102714:	e8 55 da ff ff       	call   8010016e <bread>
80102719:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010271b:	8d 50 5c             	lea    0x5c(%eax),%edx
8010271e:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102721:	83 c4 0c             	add    $0xc,%esp
80102724:	68 00 02 00 00       	push   $0x200
80102729:	52                   	push   %edx
8010272a:	50                   	push   %eax
8010272b:	e8 5c 16 00 00       	call   80103d8c <memmove>
    bwrite(to);  // write the log
80102730:	89 1c 24             	mov    %ebx,(%esp)
80102733:	e8 68 da ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102738:	89 3c 24             	mov    %edi,(%esp)
8010273b:	e8 9f da ff ff       	call   801001df <brelse>
    brelse(to);
80102740:	89 1c 24             	mov    %ebx,(%esp)
80102743:	e8 97 da ff ff       	call   801001df <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102748:	46                   	inc    %esi
80102749:	83 c4 10             	add    $0x10,%esp
8010274c:	eb 94                	jmp    801026e2 <write_log+0xe>
  }
}
8010274e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102751:	5b                   	pop    %ebx
80102752:	5e                   	pop    %esi
80102753:	5f                   	pop    %edi
80102754:	5d                   	pop    %ebp
80102755:	c3                   	ret    

80102756 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102756:	83 3d c8 26 11 80 00 	cmpl   $0x0,0x801126c8
8010275d:	7f 01                	jg     80102760 <commit+0xa>
8010275f:	c3                   	ret    
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102766:	e8 69 ff ff ff       	call   801026d4 <write_log>
    write_head();    // Write header to disk -- the real commit
8010276b:	e8 ed fe ff ff       	call   8010265d <write_head>
    install_trans(); // Now install writes to home locations
80102770:	e8 66 fe ff ff       	call   801025db <install_trans>
    log.lh.n = 0;
80102775:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
8010277c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010277f:	e8 d9 fe ff ff       	call   8010265d <write_head>
  }
}
80102784:	c9                   	leave  
80102785:	c3                   	ret    

80102786 <initlog>:
{
80102786:	f3 0f 1e fb          	endbr32 
8010278a:	55                   	push   %ebp
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	83 ec 2c             	sub    $0x2c,%esp
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102794:	68 a0 6c 10 80       	push   $0x80106ca0
80102799:	68 80 26 11 80       	push   $0x80112680
8010279e:	e8 6c 13 00 00       	call   80103b0f <initlock>
  readsb(dev, &sb);
801027a3:	83 c4 08             	add    $0x8,%esp
801027a6:	8d 45 dc             	lea    -0x24(%ebp),%eax
801027a9:	50                   	push   %eax
801027aa:	53                   	push   %ebx
801027ab:	e8 81 ea ff ff       	call   80101231 <readsb>
  log.start = sb.logstart;
801027b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027b3:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
801027b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801027bb:	a3 b8 26 11 80       	mov    %eax,0x801126b8
  log.dev = dev;
801027c0:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  recover_from_log();
801027c6:	e8 e8 fe ff ff       	call   801026b3 <recover_from_log>
}
801027cb:	83 c4 10             	add    $0x10,%esp
801027ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d1:	c9                   	leave  
801027d2:	c3                   	ret    

801027d3 <begin_op>:
{
801027d3:	f3 0f 1e fb          	endbr32 
801027d7:	55                   	push   %ebp
801027d8:	89 e5                	mov    %esp,%ebp
801027da:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801027dd:	68 80 26 11 80       	push   $0x80112680
801027e2:	e8 73 14 00 00       	call   80103c5a <acquire>
801027e7:	83 c4 10             	add    $0x10,%esp
801027ea:	eb 15                	jmp    80102801 <begin_op+0x2e>
      sleep(&log, &log.lock);
801027ec:	83 ec 08             	sub    $0x8,%esp
801027ef:	68 80 26 11 80       	push   $0x80112680
801027f4:	68 80 26 11 80       	push   $0x80112680
801027f9:	e8 26 0f 00 00       	call   80103724 <sleep>
801027fe:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102801:	83 3d c0 26 11 80 00 	cmpl   $0x0,0x801126c0
80102808:	75 e2                	jne    801027ec <begin_op+0x19>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010280a:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010280f:	8d 48 01             	lea    0x1(%eax),%ecx
80102812:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
80102816:	8d 04 12             	lea    (%edx,%edx,1),%eax
80102819:	03 05 c8 26 11 80    	add    0x801126c8,%eax
8010281f:	83 f8 1e             	cmp    $0x1e,%eax
80102822:	7e 17                	jle    8010283b <begin_op+0x68>
      sleep(&log, &log.lock);
80102824:	83 ec 08             	sub    $0x8,%esp
80102827:	68 80 26 11 80       	push   $0x80112680
8010282c:	68 80 26 11 80       	push   $0x80112680
80102831:	e8 ee 0e 00 00       	call   80103724 <sleep>
80102836:	83 c4 10             	add    $0x10,%esp
80102839:	eb c6                	jmp    80102801 <begin_op+0x2e>
      log.outstanding += 1;
8010283b:	89 0d bc 26 11 80    	mov    %ecx,0x801126bc
      release(&log.lock);
80102841:	83 ec 0c             	sub    $0xc,%esp
80102844:	68 80 26 11 80       	push   $0x80112680
80102849:	e8 75 14 00 00       	call   80103cc3 <release>
}
8010284e:	83 c4 10             	add    $0x10,%esp
80102851:	c9                   	leave  
80102852:	c3                   	ret    

80102853 <end_op>:
{
80102853:	f3 0f 1e fb          	endbr32 
80102857:	55                   	push   %ebp
80102858:	89 e5                	mov    %esp,%ebp
8010285a:	53                   	push   %ebx
8010285b:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010285e:	68 80 26 11 80       	push   $0x80112680
80102863:	e8 f2 13 00 00       	call   80103c5a <acquire>
  log.outstanding -= 1;
80102868:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010286d:	48                   	dec    %eax
8010286e:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102873:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102879:	83 c4 10             	add    $0x10,%esp
8010287c:	85 db                	test   %ebx,%ebx
8010287e:	75 2c                	jne    801028ac <end_op+0x59>
  if(log.outstanding == 0){
80102880:	85 c0                	test   %eax,%eax
80102882:	75 35                	jne    801028b9 <end_op+0x66>
    log.committing = 1;
80102884:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
8010288b:	00 00 00 
    do_commit = 1;
8010288e:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102893:	83 ec 0c             	sub    $0xc,%esp
80102896:	68 80 26 11 80       	push   $0x80112680
8010289b:	e8 23 14 00 00       	call   80103cc3 <release>
  if(do_commit){
801028a0:	83 c4 10             	add    $0x10,%esp
801028a3:	85 db                	test   %ebx,%ebx
801028a5:	75 24                	jne    801028cb <end_op+0x78>
}
801028a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028aa:	c9                   	leave  
801028ab:	c3                   	ret    
    panic("log.committing");
801028ac:	83 ec 0c             	sub    $0xc,%esp
801028af:	68 a4 6c 10 80       	push   $0x80106ca4
801028b4:	e8 9c da ff ff       	call   80100355 <panic>
    wakeup(&log);
801028b9:	83 ec 0c             	sub    $0xc,%esp
801028bc:	68 80 26 11 80       	push   $0x80112680
801028c1:	e8 d5 0f 00 00       	call   8010389b <wakeup>
801028c6:	83 c4 10             	add    $0x10,%esp
801028c9:	eb c8                	jmp    80102893 <end_op+0x40>
    commit();
801028cb:	e8 86 fe ff ff       	call   80102756 <commit>
    acquire(&log.lock);
801028d0:	83 ec 0c             	sub    $0xc,%esp
801028d3:	68 80 26 11 80       	push   $0x80112680
801028d8:	e8 7d 13 00 00       	call   80103c5a <acquire>
    log.committing = 0;
801028dd:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
801028e4:	00 00 00 
    wakeup(&log);
801028e7:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028ee:	e8 a8 0f 00 00       	call   8010389b <wakeup>
    release(&log.lock);
801028f3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028fa:	e8 c4 13 00 00       	call   80103cc3 <release>
801028ff:	83 c4 10             	add    $0x10,%esp
}
80102902:	eb a3                	jmp    801028a7 <end_op+0x54>

80102904 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102904:	f3 0f 1e fb          	endbr32 
80102908:	55                   	push   %ebp
80102909:	89 e5                	mov    %esp,%ebp
8010290b:	53                   	push   %ebx
8010290c:	83 ec 04             	sub    $0x4,%esp
8010290f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102912:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102918:	83 fa 1d             	cmp    $0x1d,%edx
8010291b:	7f 41                	jg     8010295e <log_write+0x5a>
8010291d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102922:	48                   	dec    %eax
80102923:	39 c2                	cmp    %eax,%edx
80102925:	7d 37                	jge    8010295e <log_write+0x5a>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102927:	83 3d bc 26 11 80 00 	cmpl   $0x0,0x801126bc
8010292e:	7e 3b                	jle    8010296b <log_write+0x67>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102930:	83 ec 0c             	sub    $0xc,%esp
80102933:	68 80 26 11 80       	push   $0x80112680
80102938:	e8 1d 13 00 00       	call   80103c5a <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010293d:	83 c4 10             	add    $0x10,%esp
80102940:	b8 00 00 00 00       	mov    $0x0,%eax
80102945:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
8010294b:	39 c2                	cmp    %eax,%edx
8010294d:	7e 29                	jle    80102978 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010294f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102952:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102959:	74 1d                	je     80102978 <log_write+0x74>
  for (i = 0; i < log.lh.n; i++) {
8010295b:	40                   	inc    %eax
8010295c:	eb e7                	jmp    80102945 <log_write+0x41>
    panic("too big a transaction");
8010295e:	83 ec 0c             	sub    $0xc,%esp
80102961:	68 b3 6c 10 80       	push   $0x80106cb3
80102966:	e8 ea d9 ff ff       	call   80100355 <panic>
    panic("log_write outside of trans");
8010296b:	83 ec 0c             	sub    $0xc,%esp
8010296e:	68 c9 6c 10 80       	push   $0x80106cc9
80102973:	e8 dd d9 ff ff       	call   80100355 <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
80102978:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010297b:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102982:	39 c2                	cmp    %eax,%edx
80102984:	74 18                	je     8010299e <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102986:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102989:	83 ec 0c             	sub    $0xc,%esp
8010298c:	68 80 26 11 80       	push   $0x80112680
80102991:	e8 2d 13 00 00       	call   80103cc3 <release>
}
80102996:	83 c4 10             	add    $0x10,%esp
80102999:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010299c:	c9                   	leave  
8010299d:	c3                   	ret    
    log.lh.n++;
8010299e:	42                   	inc    %edx
8010299f:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
801029a5:	eb df                	jmp    80102986 <log_write+0x82>

801029a7 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801029a7:	55                   	push   %ebp
801029a8:	89 e5                	mov    %esp,%ebp
801029aa:	53                   	push   %ebx
801029ab:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801029ae:	68 8e 00 00 00       	push   $0x8e
801029b3:	68 8c a4 10 80       	push   $0x8010a48c
801029b8:	68 00 70 00 80       	push   $0x80007000
801029bd:	e8 ca 13 00 00       	call   80103d8c <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801029c2:	83 c4 10             	add    $0x10,%esp
801029c5:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801029ca:	eb 47                	jmp    80102a13 <startothers+0x6c>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801029cc:	e8 2b f7 ff ff       	call   801020fc <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801029d1:	05 00 10 00 00       	add    $0x1000,%eax
801029d6:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
801029db:	c7 05 f8 6f 00 80 7b 	movl   $0x80102a7b,0x80006ff8
801029e2:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801029e5:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801029ec:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
801029ef:	83 ec 08             	sub    $0x8,%esp
801029f2:	68 00 70 00 00       	push   $0x7000
801029f7:	0f b6 03             	movzbl (%ebx),%eax
801029fa:	50                   	push   %eax
801029fb:	e8 06 fa ff ff       	call   80102406 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102a00:	83 c4 10             	add    $0x10,%esp
80102a03:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102a09:	85 c0                	test   %eax,%eax
80102a0b:	74 f6                	je     80102a03 <startothers+0x5c>
  for(c = cpus; c < cpus+ncpu; c++){
80102a0d:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102a13:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80102a19:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102a1c:	01 c0                	add    %eax,%eax
80102a1e:	01 d0                	add    %edx,%eax
80102a20:	c1 e0 04             	shl    $0x4,%eax
80102a23:	05 80 27 11 80       	add    $0x80112780,%eax
80102a28:	39 d8                	cmp    %ebx,%eax
80102a2a:	76 0b                	jbe    80102a37 <startothers+0x90>
    if(c == mycpu())  // We've started already.
80102a2c:	e8 84 07 00 00       	call   801031b5 <mycpu>
80102a31:	39 c3                	cmp    %eax,%ebx
80102a33:	74 d8                	je     80102a0d <startothers+0x66>
80102a35:	eb 95                	jmp    801029cc <startothers+0x25>
      ;
  }
}
80102a37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a3a:	c9                   	leave  
80102a3b:	c3                   	ret    

80102a3c <mpmain>:
{
80102a3c:	55                   	push   %ebp
80102a3d:	89 e5                	mov    %esp,%ebp
80102a3f:	53                   	push   %ebx
80102a40:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102a43:	e8 d4 07 00 00       	call   8010321c <cpuid>
80102a48:	89 c3                	mov    %eax,%ebx
80102a4a:	e8 cd 07 00 00       	call   8010321c <cpuid>
80102a4f:	83 ec 04             	sub    $0x4,%esp
80102a52:	53                   	push   %ebx
80102a53:	50                   	push   %eax
80102a54:	68 e4 6c 10 80       	push   $0x80106ce4
80102a59:	e8 9f db ff ff       	call   801005fd <cprintf>
  idtinit();       // load idt register
80102a5e:	e8 4c 25 00 00       	call   80104faf <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a63:	e8 4d 07 00 00       	call   801031b5 <mycpu>
80102a68:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a6a:	b8 01 00 00 00       	mov    $0x1,%eax
80102a6f:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a76:	e8 5f 0a 00 00       	call   801034da <scheduler>

80102a7b <mpenter>:
{
80102a7b:	f3 0f 1e fb          	endbr32 
80102a7f:	55                   	push   %ebp
80102a80:	89 e5                	mov    %esp,%ebp
80102a82:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a85:	e8 bb 36 00 00       	call   80106145 <switchkvm>
  seginit();
80102a8a:	e8 c3 34 00 00       	call   80105f52 <seginit>
  lapicinit();
80102a8f:	e8 1e f8 ff ff       	call   801022b2 <lapicinit>
  mpmain();
80102a94:	e8 a3 ff ff ff       	call   80102a3c <mpmain>

80102a99 <main>:
{
80102a99:	f3 0f 1e fb          	endbr32 
80102a9d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102aa1:	83 e4 f0             	and    $0xfffffff0,%esp
80102aa4:	ff 71 fc             	pushl  -0x4(%ecx)
80102aa7:	55                   	push   %ebp
80102aa8:	89 e5                	mov    %esp,%ebp
80102aaa:	51                   	push   %ecx
80102aab:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102aae:	68 00 00 40 80       	push   $0x80400000
80102ab3:	68 a8 55 11 80       	push   $0x801155a8
80102ab8:	e8 e5 f5 ff ff       	call   801020a2 <kinit1>
  kvmalloc();      // kernel page table
80102abd:	e8 2a 3b 00 00       	call   801065ec <kvmalloc>
  mpinit();        // detect other processors
80102ac2:	e8 b8 01 00 00       	call   80102c7f <mpinit>
  lapicinit();     // interrupt controller
80102ac7:	e8 e6 f7 ff ff       	call   801022b2 <lapicinit>
  seginit();       // segment descriptors
80102acc:	e8 81 34 00 00       	call   80105f52 <seginit>
  picinit();       // disable pic
80102ad1:	e8 7d 02 00 00       	call   80102d53 <picinit>
  ioapicinit();    // another interrupt controller
80102ad6:	e8 44 f4 ff ff       	call   80101f1f <ioapicinit>
  consoleinit();   // console hardware
80102adb:	e8 97 dd ff ff       	call   80100877 <consoleinit>
  uartinit();      // serial port
80102ae0:	e8 dd 28 00 00       	call   801053c2 <uartinit>
  pinit();         // process table
80102ae5:	e8 ad 06 00 00       	call   80103197 <pinit>
  tvinit();        // trap vectors
80102aea:	e8 10 24 00 00       	call   80104eff <tvinit>
  binit();         // buffer cache
80102aef:	e8 fe d5 ff ff       	call   801000f2 <binit>
  fileinit();      // file table
80102af4:	e8 0a e1 ff ff       	call   80100c03 <fileinit>
  ideinit();       // disk 
80102af9:	e8 2d f2 ff ff       	call   80101d2b <ideinit>
  startothers();   // start other processors
80102afe:	e8 a4 fe ff ff       	call   801029a7 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102b03:	83 c4 08             	add    $0x8,%esp
80102b06:	68 00 00 00 8e       	push   $0x8e000000
80102b0b:	68 00 00 40 80       	push   $0x80400000
80102b10:	e8 c3 f5 ff ff       	call   801020d8 <kinit2>
  userinit();      // first user process
80102b15:	e8 5f 07 00 00       	call   80103279 <userinit>
  mpmain();        // finish this processor's setup
80102b1a:	e8 1d ff ff ff       	call   80102a3c <mpmain>

80102b1f <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102b1f:	55                   	push   %ebp
80102b20:	89 e5                	mov    %esp,%ebp
80102b22:	56                   	push   %esi
80102b23:	53                   	push   %ebx
80102b24:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102b26:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102b2b:	b9 00 00 00 00       	mov    $0x0,%ecx
80102b30:	39 d1                	cmp    %edx,%ecx
80102b32:	7d 09                	jge    80102b3d <sum+0x1e>
    sum += addr[i];
80102b34:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102b38:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102b3a:	41                   	inc    %ecx
80102b3b:	eb f3                	jmp    80102b30 <sum+0x11>
  return sum;
}
80102b3d:	5b                   	pop    %ebx
80102b3e:	5e                   	pop    %esi
80102b3f:	5d                   	pop    %ebp
80102b40:	c3                   	ret    

80102b41 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102b41:	55                   	push   %ebp
80102b42:	89 e5                	mov    %esp,%ebp
80102b44:	56                   	push   %esi
80102b45:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102b46:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102b4c:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102b4e:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102b50:	eb 03                	jmp    80102b55 <mpsearch1+0x14>
80102b52:	83 c3 10             	add    $0x10,%ebx
80102b55:	39 f3                	cmp    %esi,%ebx
80102b57:	73 29                	jae    80102b82 <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102b59:	83 ec 04             	sub    $0x4,%esp
80102b5c:	6a 04                	push   $0x4
80102b5e:	68 f8 6c 10 80       	push   $0x80106cf8
80102b63:	53                   	push   %ebx
80102b64:	e8 f0 11 00 00       	call   80103d59 <memcmp>
80102b69:	83 c4 10             	add    $0x10,%esp
80102b6c:	85 c0                	test   %eax,%eax
80102b6e:	75 e2                	jne    80102b52 <mpsearch1+0x11>
80102b70:	ba 10 00 00 00       	mov    $0x10,%edx
80102b75:	89 d8                	mov    %ebx,%eax
80102b77:	e8 a3 ff ff ff       	call   80102b1f <sum>
80102b7c:	84 c0                	test   %al,%al
80102b7e:	75 d2                	jne    80102b52 <mpsearch1+0x11>
80102b80:	eb 05                	jmp    80102b87 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102b82:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102b87:	89 d8                	mov    %ebx,%eax
80102b89:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b8c:	5b                   	pop    %ebx
80102b8d:	5e                   	pop    %esi
80102b8e:	5d                   	pop    %ebp
80102b8f:	c3                   	ret    

80102b90 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102b96:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102b9d:	c1 e0 08             	shl    $0x8,%eax
80102ba0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102ba7:	09 d0                	or     %edx,%eax
80102ba9:	c1 e0 04             	shl    $0x4,%eax
80102bac:	74 1f                	je     80102bcd <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102bae:	ba 00 04 00 00       	mov    $0x400,%edx
80102bb3:	e8 89 ff ff ff       	call   80102b41 <mpsearch1>
80102bb8:	85 c0                	test   %eax,%eax
80102bba:	75 0f                	jne    80102bcb <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102bbc:	ba 00 00 01 00       	mov    $0x10000,%edx
80102bc1:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102bc6:	e8 76 ff ff ff       	call   80102b41 <mpsearch1>
}
80102bcb:	c9                   	leave  
80102bcc:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102bcd:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102bd4:	c1 e0 08             	shl    $0x8,%eax
80102bd7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102bde:	09 d0                	or     %edx,%eax
80102be0:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102be3:	2d 00 04 00 00       	sub    $0x400,%eax
80102be8:	ba 00 04 00 00       	mov    $0x400,%edx
80102bed:	e8 4f ff ff ff       	call   80102b41 <mpsearch1>
80102bf2:	85 c0                	test   %eax,%eax
80102bf4:	75 d5                	jne    80102bcb <mpsearch+0x3b>
80102bf6:	eb c4                	jmp    80102bbc <mpsearch+0x2c>

80102bf8 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102bf8:	55                   	push   %ebp
80102bf9:	89 e5                	mov    %esp,%ebp
80102bfb:	57                   	push   %edi
80102bfc:	56                   	push   %esi
80102bfd:	53                   	push   %ebx
80102bfe:	83 ec 1c             	sub    $0x1c,%esp
80102c01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c04:	e8 87 ff ff ff       	call   80102b90 <mpsearch>
80102c09:	89 c3                	mov    %eax,%ebx
80102c0b:	85 c0                	test   %eax,%eax
80102c0d:	74 53                	je     80102c62 <mpconfig+0x6a>
80102c0f:	8b 70 04             	mov    0x4(%eax),%esi
80102c12:	85 f6                	test   %esi,%esi
80102c14:	74 50                	je     80102c66 <mpconfig+0x6e>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c16:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c1c:	83 ec 04             	sub    $0x4,%esp
80102c1f:	6a 04                	push   $0x4
80102c21:	68 fd 6c 10 80       	push   $0x80106cfd
80102c26:	57                   	push   %edi
80102c27:	e8 2d 11 00 00       	call   80103d59 <memcmp>
80102c2c:	83 c4 10             	add    $0x10,%esp
80102c2f:	85 c0                	test   %eax,%eax
80102c31:	75 37                	jne    80102c6a <mpconfig+0x72>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102c33:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102c39:	3c 01                	cmp    $0x1,%al
80102c3b:	74 04                	je     80102c41 <mpconfig+0x49>
80102c3d:	3c 04                	cmp    $0x4,%al
80102c3f:	75 30                	jne    80102c71 <mpconfig+0x79>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102c41:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102c48:	89 f8                	mov    %edi,%eax
80102c4a:	e8 d0 fe ff ff       	call   80102b1f <sum>
80102c4f:	84 c0                	test   %al,%al
80102c51:	75 25                	jne    80102c78 <mpconfig+0x80>
    return 0;
  *pmp = mp;
80102c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c56:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102c58:	89 f8                	mov    %edi,%eax
80102c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5d:	5b                   	pop    %ebx
80102c5e:	5e                   	pop    %esi
80102c5f:	5f                   	pop    %edi
80102c60:	5d                   	pop    %ebp
80102c61:	c3                   	ret    
    return 0;
80102c62:	89 c7                	mov    %eax,%edi
80102c64:	eb f2                	jmp    80102c58 <mpconfig+0x60>
80102c66:	89 f7                	mov    %esi,%edi
80102c68:	eb ee                	jmp    80102c58 <mpconfig+0x60>
    return 0;
80102c6a:	bf 00 00 00 00       	mov    $0x0,%edi
80102c6f:	eb e7                	jmp    80102c58 <mpconfig+0x60>
    return 0;
80102c71:	bf 00 00 00 00       	mov    $0x0,%edi
80102c76:	eb e0                	jmp    80102c58 <mpconfig+0x60>
    return 0;
80102c78:	bf 00 00 00 00       	mov    $0x0,%edi
80102c7d:	eb d9                	jmp    80102c58 <mpconfig+0x60>

80102c7f <mpinit>:

void
mpinit(void)
{
80102c7f:	f3 0f 1e fb          	endbr32 
80102c83:	55                   	push   %ebp
80102c84:	89 e5                	mov    %esp,%ebp
80102c86:	57                   	push   %edi
80102c87:	56                   	push   %esi
80102c88:	53                   	push   %ebx
80102c89:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102c8c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102c8f:	e8 64 ff ff ff       	call   80102bf8 <mpconfig>
80102c94:	85 c0                	test   %eax,%eax
80102c96:	74 19                	je     80102cb1 <mpinit+0x32>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102c98:	8b 50 24             	mov    0x24(%eax),%edx
80102c9b:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ca1:	8d 50 2c             	lea    0x2c(%eax),%edx
80102ca4:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102ca8:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102caa:	bf 01 00 00 00       	mov    $0x1,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102caf:	eb 20                	jmp    80102cd1 <mpinit+0x52>
    panic("Expect to run on an SMP");
80102cb1:	83 ec 0c             	sub    $0xc,%esp
80102cb4:	68 02 6d 10 80       	push   $0x80106d02
80102cb9:	e8 97 d6 ff ff       	call   80100355 <panic>
    switch(*p){
80102cbe:	bf 00 00 00 00       	mov    $0x0,%edi
80102cc3:	eb 0c                	jmp    80102cd1 <mpinit+0x52>
80102cc5:	83 e8 03             	sub    $0x3,%eax
80102cc8:	3c 01                	cmp    $0x1,%al
80102cca:	76 19                	jbe    80102ce5 <mpinit+0x66>
80102ccc:	bf 00 00 00 00       	mov    $0x0,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cd1:	39 ca                	cmp    %ecx,%edx
80102cd3:	73 4a                	jae    80102d1f <mpinit+0xa0>
    switch(*p){
80102cd5:	8a 02                	mov    (%edx),%al
80102cd7:	3c 02                	cmp    $0x2,%al
80102cd9:	74 37                	je     80102d12 <mpinit+0x93>
80102cdb:	77 e8                	ja     80102cc5 <mpinit+0x46>
80102cdd:	84 c0                	test   %al,%al
80102cdf:	74 09                	je     80102cea <mpinit+0x6b>
80102ce1:	3c 01                	cmp    $0x1,%al
80102ce3:	75 d9                	jne    80102cbe <mpinit+0x3f>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102ce5:	83 c2 08             	add    $0x8,%edx
      continue;
80102ce8:	eb e7                	jmp    80102cd1 <mpinit+0x52>
      if(ncpu < NCPU) {
80102cea:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80102cef:	83 f8 07             	cmp    $0x7,%eax
80102cf2:	7f 19                	jg     80102d0d <mpinit+0x8e>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102cf4:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102cf7:	01 f6                	add    %esi,%esi
80102cf9:	01 c6                	add    %eax,%esi
80102cfb:	c1 e6 04             	shl    $0x4,%esi
80102cfe:	8a 5a 01             	mov    0x1(%edx),%bl
80102d01:	88 9e 80 27 11 80    	mov    %bl,-0x7feed880(%esi)
        ncpu++;
80102d07:	40                   	inc    %eax
80102d08:	a3 00 2d 11 80       	mov    %eax,0x80112d00
      p += sizeof(struct mpproc);
80102d0d:	83 c2 14             	add    $0x14,%edx
      continue;
80102d10:	eb bf                	jmp    80102cd1 <mpinit+0x52>
      ioapicid = ioapic->apicno;
80102d12:	8a 42 01             	mov    0x1(%edx),%al
80102d15:	a2 60 27 11 80       	mov    %al,0x80112760
      p += sizeof(struct mpioapic);
80102d1a:	83 c2 08             	add    $0x8,%edx
      continue;
80102d1d:	eb b2                	jmp    80102cd1 <mpinit+0x52>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102d1f:	85 ff                	test   %edi,%edi
80102d21:	74 23                	je     80102d46 <mpinit+0xc7>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d26:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102d2a:	74 12                	je     80102d3e <mpinit+0xbf>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d2c:	b0 70                	mov    $0x70,%al
80102d2e:	ba 22 00 00 00       	mov    $0x22,%edx
80102d33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d34:	ba 23 00 00 00       	mov    $0x23,%edx
80102d39:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102d3a:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3d:	ee                   	out    %al,(%dx)
  }
}
80102d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d41:	5b                   	pop    %ebx
80102d42:	5e                   	pop    %esi
80102d43:	5f                   	pop    %edi
80102d44:	5d                   	pop    %ebp
80102d45:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102d46:	83 ec 0c             	sub    $0xc,%esp
80102d49:	68 1c 6d 10 80       	push   $0x80106d1c
80102d4e:	e8 02 d6 ff ff       	call   80100355 <panic>

80102d53 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102d53:	f3 0f 1e fb          	endbr32 
80102d57:	b0 ff                	mov    $0xff,%al
80102d59:	ba 21 00 00 00       	mov    $0x21,%edx
80102d5e:	ee                   	out    %al,(%dx)
80102d5f:	ba a1 00 00 00       	mov    $0xa1,%edx
80102d64:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102d65:	c3                   	ret    

80102d66 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102d66:	f3 0f 1e fb          	endbr32 
80102d6a:	55                   	push   %ebp
80102d6b:	89 e5                	mov    %esp,%ebp
80102d6d:	57                   	push   %edi
80102d6e:	56                   	push   %esi
80102d6f:	53                   	push   %ebx
80102d70:	83 ec 0c             	sub    $0xc,%esp
80102d73:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d76:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102d79:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d7f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102d85:	e8 97 de ff ff       	call   80100c21 <filealloc>
80102d8a:	89 03                	mov    %eax,(%ebx)
80102d8c:	85 c0                	test   %eax,%eax
80102d8e:	0f 84 88 00 00 00    	je     80102e1c <pipealloc+0xb6>
80102d94:	e8 88 de ff ff       	call   80100c21 <filealloc>
80102d99:	89 06                	mov    %eax,(%esi)
80102d9b:	85 c0                	test   %eax,%eax
80102d9d:	74 7d                	je     80102e1c <pipealloc+0xb6>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102d9f:	e8 58 f3 ff ff       	call   801020fc <kalloc>
80102da4:	89 c7                	mov    %eax,%edi
80102da6:	85 c0                	test   %eax,%eax
80102da8:	74 72                	je     80102e1c <pipealloc+0xb6>
    goto bad;
  p->readopen = 1;
80102daa:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102db1:	00 00 00 
  p->writeopen = 1;
80102db4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102dbb:	00 00 00 
  p->nwrite = 0;
80102dbe:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102dc5:	00 00 00 
  p->nread = 0;
80102dc8:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102dcf:	00 00 00 
  initlock(&p->lock, "pipe");
80102dd2:	83 ec 08             	sub    $0x8,%esp
80102dd5:	68 3b 6d 10 80       	push   $0x80106d3b
80102dda:	50                   	push   %eax
80102ddb:	e8 2f 0d 00 00       	call   80103b0f <initlock>
  (*f0)->type = FD_PIPE;
80102de0:	8b 03                	mov    (%ebx),%eax
80102de2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102de8:	8b 03                	mov    (%ebx),%eax
80102dea:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102dee:	8b 03                	mov    (%ebx),%eax
80102df0:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102df4:	8b 03                	mov    (%ebx),%eax
80102df6:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102df9:	8b 06                	mov    (%esi),%eax
80102dfb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e01:	8b 06                	mov    (%esi),%eax
80102e03:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e07:	8b 06                	mov    (%esi),%eax
80102e09:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e0d:	8b 06                	mov    (%esi),%eax
80102e0f:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102e12:	83 c4 10             	add    $0x10,%esp
80102e15:	b8 00 00 00 00       	mov    $0x0,%eax
80102e1a:	eb 29                	jmp    80102e45 <pipealloc+0xdf>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102e1c:	8b 03                	mov    (%ebx),%eax
80102e1e:	85 c0                	test   %eax,%eax
80102e20:	74 0c                	je     80102e2e <pipealloc+0xc8>
    fileclose(*f0);
80102e22:	83 ec 0c             	sub    $0xc,%esp
80102e25:	50                   	push   %eax
80102e26:	e8 a2 de ff ff       	call   80100ccd <fileclose>
80102e2b:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102e2e:	8b 06                	mov    (%esi),%eax
80102e30:	85 c0                	test   %eax,%eax
80102e32:	74 19                	je     80102e4d <pipealloc+0xe7>
    fileclose(*f1);
80102e34:	83 ec 0c             	sub    $0xc,%esp
80102e37:	50                   	push   %eax
80102e38:	e8 90 de ff ff       	call   80100ccd <fileclose>
80102e3d:	83 c4 10             	add    $0x10,%esp
  return -1;
80102e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e48:	5b                   	pop    %ebx
80102e49:	5e                   	pop    %esi
80102e4a:	5f                   	pop    %edi
80102e4b:	5d                   	pop    %ebp
80102e4c:	c3                   	ret    
  return -1;
80102e4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e52:	eb f1                	jmp    80102e45 <pipealloc+0xdf>

80102e54 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102e54:	f3 0f 1e fb          	endbr32 
80102e58:	55                   	push   %ebp
80102e59:	89 e5                	mov    %esp,%ebp
80102e5b:	53                   	push   %ebx
80102e5c:	83 ec 10             	sub    $0x10,%esp
80102e5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102e62:	53                   	push   %ebx
80102e63:	e8 f2 0d 00 00       	call   80103c5a <acquire>
  if(writable){
80102e68:	83 c4 10             	add    $0x10,%esp
80102e6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102e6f:	74 3f                	je     80102eb0 <pipeclose+0x5c>
    p->writeopen = 0;
80102e71:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102e78:	00 00 00 
    wakeup(&p->nread);
80102e7b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e81:	83 ec 0c             	sub    $0xc,%esp
80102e84:	50                   	push   %eax
80102e85:	e8 11 0a 00 00       	call   8010389b <wakeup>
80102e8a:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102e8d:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e94:	75 09                	jne    80102e9f <pipeclose+0x4b>
80102e96:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102e9d:	74 2f                	je     80102ece <pipeclose+0x7a>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102e9f:	83 ec 0c             	sub    $0xc,%esp
80102ea2:	53                   	push   %ebx
80102ea3:	e8 1b 0e 00 00       	call   80103cc3 <release>
80102ea8:	83 c4 10             	add    $0x10,%esp
}
80102eab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eae:	c9                   	leave  
80102eaf:	c3                   	ret    
    p->readopen = 0;
80102eb0:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102eb7:	00 00 00 
    wakeup(&p->nwrite);
80102eba:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102ec0:	83 ec 0c             	sub    $0xc,%esp
80102ec3:	50                   	push   %eax
80102ec4:	e8 d2 09 00 00       	call   8010389b <wakeup>
80102ec9:	83 c4 10             	add    $0x10,%esp
80102ecc:	eb bf                	jmp    80102e8d <pipeclose+0x39>
    release(&p->lock);
80102ece:	83 ec 0c             	sub    $0xc,%esp
80102ed1:	53                   	push   %ebx
80102ed2:	e8 ec 0d 00 00       	call   80103cc3 <release>
    kfree((char*)p);
80102ed7:	89 1c 24             	mov    %ebx,(%esp)
80102eda:	e8 f6 f0 ff ff       	call   80101fd5 <kfree>
80102edf:	83 c4 10             	add    $0x10,%esp
80102ee2:	eb c7                	jmp    80102eab <pipeclose+0x57>

80102ee4 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102ee4:	f3 0f 1e fb          	endbr32 
80102ee8:	55                   	push   %ebp
80102ee9:	89 e5                	mov    %esp,%ebp
80102eeb:	57                   	push   %edi
80102eec:	56                   	push   %esi
80102eed:	53                   	push   %ebx
80102eee:	83 ec 28             	sub    $0x28,%esp
80102ef1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102ef4:	89 de                	mov    %ebx,%esi
80102ef6:	53                   	push   %ebx
80102ef7:	e8 5e 0d 00 00       	call   80103c5a <acquire>
  for(i = 0; i < n; i++){
80102efc:	83 c4 10             	add    $0x10,%esp
80102eff:	bf 00 00 00 00       	mov    $0x0,%edi
80102f04:	3b 7d 10             	cmp    0x10(%ebp),%edi
80102f07:	7c 41                	jl     80102f4a <pipewrite+0x66>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102f09:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f0f:	83 ec 0c             	sub    $0xc,%esp
80102f12:	50                   	push   %eax
80102f13:	e8 83 09 00 00       	call   8010389b <wakeup>
  release(&p->lock);
80102f18:	89 1c 24             	mov    %ebx,(%esp)
80102f1b:	e8 a3 0d 00 00       	call   80103cc3 <release>
  return n;
80102f20:	83 c4 10             	add    $0x10,%esp
80102f23:	8b 45 10             	mov    0x10(%ebp),%eax
80102f26:	eb 5c                	jmp    80102f84 <pipewrite+0xa0>
      wakeup(&p->nread);
80102f28:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f2e:	83 ec 0c             	sub    $0xc,%esp
80102f31:	50                   	push   %eax
80102f32:	e8 64 09 00 00       	call   8010389b <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f37:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f3d:	83 c4 08             	add    $0x8,%esp
80102f40:	56                   	push   %esi
80102f41:	50                   	push   %eax
80102f42:	e8 dd 07 00 00       	call   80103724 <sleep>
80102f47:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f4a:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102f50:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f56:	05 00 02 00 00       	add    $0x200,%eax
80102f5b:	39 c2                	cmp    %eax,%edx
80102f5d:	75 2d                	jne    80102f8c <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80102f5f:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f66:	74 0b                	je     80102f73 <pipewrite+0x8f>
80102f68:	e8 e4 02 00 00       	call   80103251 <myproc>
80102f6d:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f71:	74 b5                	je     80102f28 <pipewrite+0x44>
        release(&p->lock);
80102f73:	83 ec 0c             	sub    $0xc,%esp
80102f76:	53                   	push   %ebx
80102f77:	e8 47 0d 00 00       	call   80103cc3 <release>
        return -1;
80102f7c:	83 c4 10             	add    $0x10,%esp
80102f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f87:	5b                   	pop    %ebx
80102f88:	5e                   	pop    %esi
80102f89:	5f                   	pop    %edi
80102f8a:	5d                   	pop    %ebp
80102f8b:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102f8c:	8d 42 01             	lea    0x1(%edx),%eax
80102f8f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102f95:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f9e:	8a 04 38             	mov    (%eax,%edi,1),%al
80102fa1:	88 45 e7             	mov    %al,-0x19(%ebp)
80102fa4:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102fa8:	47                   	inc    %edi
80102fa9:	e9 56 ff ff ff       	jmp    80102f04 <pipewrite+0x20>

80102fae <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102fae:	f3 0f 1e fb          	endbr32 
80102fb2:	55                   	push   %ebp
80102fb3:	89 e5                	mov    %esp,%ebp
80102fb5:	57                   	push   %edi
80102fb6:	56                   	push   %esi
80102fb7:	53                   	push   %ebx
80102fb8:	83 ec 18             	sub    $0x18,%esp
80102fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102fbe:	89 df                	mov    %ebx,%edi
80102fc0:	53                   	push   %ebx
80102fc1:	e8 94 0c 00 00       	call   80103c5a <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fc6:	83 c4 10             	add    $0x10,%esp
80102fc9:	eb 13                	jmp    80102fde <piperead+0x30>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102fcb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fd1:	83 ec 08             	sub    $0x8,%esp
80102fd4:	57                   	push   %edi
80102fd5:	50                   	push   %eax
80102fd6:	e8 49 07 00 00       	call   80103724 <sleep>
80102fdb:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fde:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102fe4:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102fea:	75 28                	jne    80103014 <piperead+0x66>
80102fec:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102ff2:	85 f6                	test   %esi,%esi
80102ff4:	74 23                	je     80103019 <piperead+0x6b>
    if(myproc()->killed){
80102ff6:	e8 56 02 00 00       	call   80103251 <myproc>
80102ffb:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102fff:	74 ca                	je     80102fcb <piperead+0x1d>
      release(&p->lock);
80103001:	83 ec 0c             	sub    $0xc,%esp
80103004:	53                   	push   %ebx
80103005:	e8 b9 0c 00 00       	call   80103cc3 <release>
      return -1;
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103012:	eb 4d                	jmp    80103061 <piperead+0xb3>
80103014:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103019:	3b 75 10             	cmp    0x10(%ebp),%esi
8010301c:	7d 29                	jge    80103047 <piperead+0x99>
    if(p->nread == p->nwrite)
8010301e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103024:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
8010302a:	74 1b                	je     80103047 <piperead+0x99>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010302c:	8d 50 01             	lea    0x1(%eax),%edx
8010302f:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80103035:	25 ff 01 00 00       	and    $0x1ff,%eax
8010303a:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
8010303e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103041:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103044:	46                   	inc    %esi
80103045:	eb d2                	jmp    80103019 <piperead+0x6b>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103047:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010304d:	83 ec 0c             	sub    $0xc,%esp
80103050:	50                   	push   %eax
80103051:	e8 45 08 00 00       	call   8010389b <wakeup>
  release(&p->lock);
80103056:	89 1c 24             	mov    %ebx,(%esp)
80103059:	e8 65 0c 00 00       	call   80103cc3 <release>
  return i;
8010305e:	83 c4 10             	add    $0x10,%esp
}
80103061:	89 f0                	mov    %esi,%eax
80103063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103066:	5b                   	pop    %ebx
80103067:	5e                   	pop    %esi
80103068:	5f                   	pop    %edi
80103069:	5d                   	pop    %ebp
8010306a:	c3                   	ret    

8010306b <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010306b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103070:	eb 0a                	jmp    8010307c <wakeup1+0x11>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
80103072:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103079:	83 ea 80             	sub    $0xffffff80,%edx
8010307c:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103082:	73 0d                	jae    80103091 <wakeup1+0x26>
    if(p->state == SLEEPING && p->chan == chan)
80103084:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103088:	75 ef                	jne    80103079 <wakeup1+0xe>
8010308a:	39 42 20             	cmp    %eax,0x20(%edx)
8010308d:	75 ea                	jne    80103079 <wakeup1+0xe>
8010308f:	eb e1                	jmp    80103072 <wakeup1+0x7>
}
80103091:	c3                   	ret    

80103092 <allocproc>:
{
80103092:	55                   	push   %ebp
80103093:	89 e5                	mov    %esp,%ebp
80103095:	53                   	push   %ebx
80103096:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103099:	68 20 2d 11 80       	push   $0x80112d20
8010309e:	e8 b7 0b 00 00       	call   80103c5a <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030a3:	83 c4 10             	add    $0x10,%esp
801030a6:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801030ab:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801030b1:	73 7b                	jae    8010312e <allocproc+0x9c>
    if(p->state == UNUSED)
801030b3:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
801030b7:	74 05                	je     801030be <allocproc+0x2c>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030b9:	83 eb 80             	sub    $0xffffff80,%ebx
801030bc:	eb ed                	jmp    801030ab <allocproc+0x19>
  p->state = EMBRYO;
801030be:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801030c5:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801030ca:	8d 50 01             	lea    0x1(%eax),%edx
801030cd:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801030d3:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801030d6:	83 ec 0c             	sub    $0xc,%esp
801030d9:	68 20 2d 11 80       	push   $0x80112d20
801030de:	e8 e0 0b 00 00       	call   80103cc3 <release>
  if((p->kstack = kalloc()) == 0){
801030e3:	e8 14 f0 ff ff       	call   801020fc <kalloc>
801030e8:	89 43 08             	mov    %eax,0x8(%ebx)
801030eb:	83 c4 10             	add    $0x10,%esp
801030ee:	85 c0                	test   %eax,%eax
801030f0:	74 53                	je     80103145 <allocproc+0xb3>
  sp -= sizeof *p->tf;
801030f2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
801030f8:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801030fb:	c7 80 b0 0f 00 00 f4 	movl   $0x80104ef4,0xfb0(%eax)
80103102:	4e 10 80 
  sp -= sizeof *p->context;
80103105:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
8010310a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010310d:	83 ec 04             	sub    $0x4,%esp
80103110:	6a 14                	push   $0x14
80103112:	6a 00                	push   $0x0
80103114:	50                   	push   %eax
80103115:	e8 f4 0b 00 00       	call   80103d0e <memset>
  p->context->eip = (uint)forkret;
8010311a:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010311d:	c7 40 10 50 31 10 80 	movl   $0x80103150,0x10(%eax)
  return p;
80103124:	83 c4 10             	add    $0x10,%esp
}
80103127:	89 d8                	mov    %ebx,%eax
80103129:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010312c:	c9                   	leave  
8010312d:	c3                   	ret    
  release(&ptable.lock);
8010312e:	83 ec 0c             	sub    $0xc,%esp
80103131:	68 20 2d 11 80       	push   $0x80112d20
80103136:	e8 88 0b 00 00       	call   80103cc3 <release>
  return 0;
8010313b:	83 c4 10             	add    $0x10,%esp
8010313e:	bb 00 00 00 00       	mov    $0x0,%ebx
80103143:	eb e2                	jmp    80103127 <allocproc+0x95>
    p->state = UNUSED;
80103145:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010314c:	89 c3                	mov    %eax,%ebx
8010314e:	eb d7                	jmp    80103127 <allocproc+0x95>

80103150 <forkret>:
{
80103150:	f3 0f 1e fb          	endbr32 
80103154:	55                   	push   %ebp
80103155:	89 e5                	mov    %esp,%ebp
80103157:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
8010315a:	68 20 2d 11 80       	push   $0x80112d20
8010315f:	e8 5f 0b 00 00       	call   80103cc3 <release>
  if (first) {
80103164:	83 c4 10             	add    $0x10,%esp
80103167:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
8010316e:	75 02                	jne    80103172 <forkret+0x22>
}
80103170:	c9                   	leave  
80103171:	c3                   	ret    
    first = 0;
80103172:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103179:	00 00 00 
    iinit(ROOTDEV);
8010317c:	83 ec 0c             	sub    $0xc,%esp
8010317f:	6a 01                	push   $0x1
80103181:	e8 68 e1 ff ff       	call   801012ee <iinit>
    initlog(ROOTDEV);
80103186:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010318d:	e8 f4 f5 ff ff       	call   80102786 <initlog>
80103192:	83 c4 10             	add    $0x10,%esp
}
80103195:	eb d9                	jmp    80103170 <forkret+0x20>

80103197 <pinit>:
{
80103197:	f3 0f 1e fb          	endbr32 
8010319b:	55                   	push   %ebp
8010319c:	89 e5                	mov    %esp,%ebp
8010319e:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801031a1:	68 40 6d 10 80       	push   $0x80106d40
801031a6:	68 20 2d 11 80       	push   $0x80112d20
801031ab:	e8 5f 09 00 00       	call   80103b0f <initlock>
}
801031b0:	83 c4 10             	add    $0x10,%esp
801031b3:	c9                   	leave  
801031b4:	c3                   	ret    

801031b5 <mycpu>:
{
801031b5:	f3 0f 1e fb          	endbr32 
801031b9:	55                   	push   %ebp
801031ba:	89 e5                	mov    %esp,%ebp
801031bc:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031bf:	9c                   	pushf  
801031c0:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801031c1:	f6 c4 02             	test   $0x2,%ah
801031c4:	75 2a                	jne    801031f0 <mycpu+0x3b>
  apicid = lapicid();
801031c6:	e8 f7 f1 ff ff       	call   801023c2 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801031cb:	b9 00 00 00 00       	mov    $0x0,%ecx
801031d0:	39 0d 00 2d 11 80    	cmp    %ecx,0x80112d00
801031d6:	7e 37                	jle    8010320f <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801031d8:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
801031db:	01 d2                	add    %edx,%edx
801031dd:	01 ca                	add    %ecx,%edx
801031df:	c1 e2 04             	shl    $0x4,%edx
801031e2:	0f b6 92 80 27 11 80 	movzbl -0x7feed880(%edx),%edx
801031e9:	39 c2                	cmp    %eax,%edx
801031eb:	74 10                	je     801031fd <mycpu+0x48>
  for (i = 0; i < ncpu; ++i) {
801031ed:	41                   	inc    %ecx
801031ee:	eb e0                	jmp    801031d0 <mycpu+0x1b>
    panic("mycpu called with interrupts enabled\n");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 24 6e 10 80       	push   $0x80106e24
801031f8:	e8 58 d1 ff ff       	call   80100355 <panic>
      return &cpus[i];
801031fd:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
80103200:	01 c0                	add    %eax,%eax
80103202:	01 c8                	add    %ecx,%eax
80103204:	c1 e0 04             	shl    $0x4,%eax
80103207:	8d 80 80 27 11 80    	lea    -0x7feed880(%eax),%eax
}
8010320d:	c9                   	leave  
8010320e:	c3                   	ret    
  panic("unknown apicid\n");
8010320f:	83 ec 0c             	sub    $0xc,%esp
80103212:	68 47 6d 10 80       	push   $0x80106d47
80103217:	e8 39 d1 ff ff       	call   80100355 <panic>

8010321c <cpuid>:
cpuid() {
8010321c:	f3 0f 1e fb          	endbr32 
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103226:	e8 8a ff ff ff       	call   801031b5 <mycpu>
8010322b:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103230:	c1 f8 04             	sar    $0x4,%eax
80103233:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
80103236:	89 ca                	mov    %ecx,%edx
80103238:	c1 e2 05             	shl    $0x5,%edx
8010323b:	29 ca                	sub    %ecx,%edx
8010323d:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103240:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
80103243:	89 ca                	mov    %ecx,%edx
80103245:	c1 e2 0f             	shl    $0xf,%edx
80103248:	29 ca                	sub    %ecx,%edx
8010324a:	8d 04 90             	lea    (%eax,%edx,4),%eax
8010324d:	f7 d8                	neg    %eax
}
8010324f:	c9                   	leave  
80103250:	c3                   	ret    

80103251 <myproc>:
myproc(void) {
80103251:	f3 0f 1e fb          	endbr32 
80103255:	55                   	push   %ebp
80103256:	89 e5                	mov    %esp,%ebp
80103258:	53                   	push   %ebx
80103259:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010325c:	e8 11 09 00 00       	call   80103b72 <pushcli>
  c = mycpu();
80103261:	e8 4f ff ff ff       	call   801031b5 <mycpu>
  p = c->proc;
80103266:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010326c:	e8 41 09 00 00       	call   80103bb2 <popcli>
}
80103271:	89 d8                	mov    %ebx,%eax
80103273:	83 c4 04             	add    $0x4,%esp
80103276:	5b                   	pop    %ebx
80103277:	5d                   	pop    %ebp
80103278:	c3                   	ret    

80103279 <userinit>:
{
80103279:	f3 0f 1e fb          	endbr32 
8010327d:	55                   	push   %ebp
8010327e:	89 e5                	mov    %esp,%ebp
80103280:	53                   	push   %ebx
80103281:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103284:	e8 09 fe ff ff       	call   80103092 <allocproc>
80103289:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010328b:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103290:	e8 e3 32 00 00       	call   80106578 <setupkvm>
80103295:	89 43 04             	mov    %eax,0x4(%ebx)
80103298:	85 c0                	test   %eax,%eax
8010329a:	0f 84 b6 00 00 00    	je     80103356 <userinit+0xdd>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801032a0:	83 ec 04             	sub    $0x4,%esp
801032a3:	68 2c 00 00 00       	push   $0x2c
801032a8:	68 60 a4 10 80       	push   $0x8010a460
801032ad:	50                   	push   %eax
801032ae:	e8 bd 2f 00 00       	call   80106270 <inituvm>
  p->sz = PGSIZE;
801032b3:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801032b9:	8b 43 18             	mov    0x18(%ebx),%eax
801032bc:	83 c4 0c             	add    $0xc,%esp
801032bf:	6a 4c                	push   $0x4c
801032c1:	6a 00                	push   $0x0
801032c3:	50                   	push   %eax
801032c4:	e8 45 0a 00 00       	call   80103d0e <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801032c9:	8b 43 18             	mov    0x18(%ebx),%eax
801032cc:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801032d2:	8b 43 18             	mov    0x18(%ebx),%eax
801032d5:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801032db:	8b 43 18             	mov    0x18(%ebx),%eax
801032de:	8b 50 2c             	mov    0x2c(%eax),%edx
801032e1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801032e5:	8b 43 18             	mov    0x18(%ebx),%eax
801032e8:	8b 50 2c             	mov    0x2c(%eax),%edx
801032eb:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801032ef:	8b 43 18             	mov    0x18(%ebx),%eax
801032f2:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801032f9:	8b 43 18             	mov    0x18(%ebx),%eax
801032fc:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103303:	8b 43 18             	mov    0x18(%ebx),%eax
80103306:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010330d:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103310:	83 c4 0c             	add    $0xc,%esp
80103313:	6a 10                	push   $0x10
80103315:	68 70 6d 10 80       	push   $0x80106d70
8010331a:	50                   	push   %eax
8010331b:	e8 5a 0b 00 00       	call   80103e7a <safestrcpy>
  p->cwd = namei("/");
80103320:	c7 04 24 79 6d 10 80 	movl   $0x80106d79,(%esp)
80103327:	e8 e6 e8 ff ff       	call   80101c12 <namei>
8010332c:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010332f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103336:	e8 1f 09 00 00       	call   80103c5a <acquire>
  p->state = RUNNABLE;
8010333b:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103342:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103349:	e8 75 09 00 00       	call   80103cc3 <release>
}
8010334e:	83 c4 10             	add    $0x10,%esp
80103351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103354:	c9                   	leave  
80103355:	c3                   	ret    
    panic("userinit: out of memory?");
80103356:	83 ec 0c             	sub    $0xc,%esp
80103359:	68 57 6d 10 80       	push   $0x80106d57
8010335e:	e8 f2 cf ff ff       	call   80100355 <panic>

80103363 <growproc>:
{
80103363:	f3 0f 1e fb          	endbr32 
80103367:	55                   	push   %ebp
80103368:	89 e5                	mov    %esp,%ebp
8010336a:	56                   	push   %esi
8010336b:	53                   	push   %ebx
8010336c:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010336f:	e8 dd fe ff ff       	call   80103251 <myproc>
80103374:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103376:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103378:	85 f6                	test   %esi,%esi
8010337a:	7f 1b                	jg     80103397 <growproc+0x34>
  } else if(n < 0){
8010337c:	78 36                	js     801033b4 <growproc+0x51>
  curproc->sz = sz;
8010337e:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(curproc->pgdir));  // Invalidate TLB.
80103380:	8b 43 04             	mov    0x4(%ebx),%eax
80103383:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80103388:	0f 22 d8             	mov    %eax,%cr3
  return 0;
8010338b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103390:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103393:	5b                   	pop    %ebx
80103394:	5e                   	pop    %esi
80103395:	5d                   	pop    %ebp
80103396:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103397:	83 ec 04             	sub    $0x4,%esp
8010339a:	01 c6                	add    %eax,%esi
8010339c:	56                   	push   %esi
8010339d:	50                   	push   %eax
8010339e:	ff 73 04             	pushl  0x4(%ebx)
801033a1:	e8 68 30 00 00       	call   8010640e <allocuvm>
801033a6:	83 c4 10             	add    $0x10,%esp
801033a9:	85 c0                	test   %eax,%eax
801033ab:	75 d1                	jne    8010337e <growproc+0x1b>
      return -1;
801033ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033b2:	eb dc                	jmp    80103390 <growproc+0x2d>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801033b4:	83 ec 04             	sub    $0x4,%esp
801033b7:	01 c6                	add    %eax,%esi
801033b9:	56                   	push   %esi
801033ba:	50                   	push   %eax
801033bb:	ff 73 04             	pushl  0x4(%ebx)
801033be:	e8 b7 2f 00 00       	call   8010637a <deallocuvm>
801033c3:	83 c4 10             	add    $0x10,%esp
801033c6:	85 c0                	test   %eax,%eax
801033c8:	75 b4                	jne    8010337e <growproc+0x1b>
      return -1;
801033ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033cf:	eb bf                	jmp    80103390 <growproc+0x2d>

801033d1 <fork>:
{
801033d1:	f3 0f 1e fb          	endbr32 
801033d5:	55                   	push   %ebp
801033d6:	89 e5                	mov    %esp,%ebp
801033d8:	57                   	push   %edi
801033d9:	56                   	push   %esi
801033da:	53                   	push   %ebx
801033db:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801033de:	e8 6e fe ff ff       	call   80103251 <myproc>
801033e3:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801033e5:	e8 a8 fc ff ff       	call   80103092 <allocproc>
801033ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801033ed:	85 c0                	test   %eax,%eax
801033ef:	0f 84 de 00 00 00    	je     801034d3 <fork+0x102>
801033f5:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801033f7:	83 ec 08             	sub    $0x8,%esp
801033fa:	ff 33                	pushl  (%ebx)
801033fc:	ff 73 04             	pushl  0x4(%ebx)
801033ff:	e8 33 32 00 00       	call   80106637 <copyuvm>
80103404:	89 47 04             	mov    %eax,0x4(%edi)
80103407:	83 c4 10             	add    $0x10,%esp
8010340a:	85 c0                	test   %eax,%eax
8010340c:	74 2a                	je     80103438 <fork+0x67>
  np->sz = curproc->sz;
8010340e:	8b 03                	mov    (%ebx),%eax
80103410:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103413:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103415:	89 c8                	mov    %ecx,%eax
80103417:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010341a:	8b 73 18             	mov    0x18(%ebx),%esi
8010341d:	8b 79 18             	mov    0x18(%ecx),%edi
80103420:	b9 13 00 00 00       	mov    $0x13,%ecx
80103425:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103427:	8b 40 18             	mov    0x18(%eax),%eax
8010342a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103431:	be 00 00 00 00       	mov    $0x0,%esi
80103436:	eb 3a                	jmp    80103472 <fork+0xa1>
    kfree(np->kstack);
80103438:	83 ec 0c             	sub    $0xc,%esp
8010343b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010343e:	ff 73 08             	pushl  0x8(%ebx)
80103441:	e8 8f eb ff ff       	call   80101fd5 <kfree>
    np->kstack = 0;
80103446:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010344d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103454:	83 c4 10             	add    $0x10,%esp
80103457:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010345c:	eb 6b                	jmp    801034c9 <fork+0xf8>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010345e:	83 ec 0c             	sub    $0xc,%esp
80103461:	50                   	push   %eax
80103462:	e8 1f d8 ff ff       	call   80100c86 <filedup>
80103467:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010346a:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
8010346e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
80103471:	46                   	inc    %esi
80103472:	83 fe 0f             	cmp    $0xf,%esi
80103475:	7f 0a                	jg     80103481 <fork+0xb0>
    if(curproc->ofile[i])
80103477:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010347b:	85 c0                	test   %eax,%eax
8010347d:	75 df                	jne    8010345e <fork+0x8d>
8010347f:	eb f0                	jmp    80103471 <fork+0xa0>
  np->cwd = idup(curproc->cwd);
80103481:	83 ec 0c             	sub    $0xc,%esp
80103484:	ff 73 68             	pushl  0x68(%ebx)
80103487:	e8 c8 e0 ff ff       	call   80101554 <idup>
8010348c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010348f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103492:	83 c3 6c             	add    $0x6c,%ebx
80103495:	8d 47 6c             	lea    0x6c(%edi),%eax
80103498:	83 c4 0c             	add    $0xc,%esp
8010349b:	6a 10                	push   $0x10
8010349d:	53                   	push   %ebx
8010349e:	50                   	push   %eax
8010349f:	e8 d6 09 00 00       	call   80103e7a <safestrcpy>
  pid = np->pid;
801034a4:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801034a7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034ae:	e8 a7 07 00 00       	call   80103c5a <acquire>
  np->state = RUNNABLE;
801034b3:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801034ba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034c1:	e8 fd 07 00 00       	call   80103cc3 <release>
  return pid;
801034c6:	83 c4 10             	add    $0x10,%esp
}
801034c9:	89 d8                	mov    %ebx,%eax
801034cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034ce:	5b                   	pop    %ebx
801034cf:	5e                   	pop    %esi
801034d0:	5f                   	pop    %edi
801034d1:	5d                   	pop    %ebp
801034d2:	c3                   	ret    
    return -1;
801034d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801034d8:	eb ef                	jmp    801034c9 <fork+0xf8>

801034da <scheduler>:
{
801034da:	f3 0f 1e fb          	endbr32 
801034de:	55                   	push   %ebp
801034df:	89 e5                	mov    %esp,%ebp
801034e1:	56                   	push   %esi
801034e2:	53                   	push   %ebx
  struct cpu *c = mycpu();
801034e3:	e8 cd fc ff ff       	call   801031b5 <mycpu>
801034e8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801034ea:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801034f1:	00 00 00 
801034f4:	eb 5a                	jmp    80103550 <scheduler+0x76>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801034f6:	83 eb 80             	sub    $0xffffff80,%ebx
801034f9:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801034ff:	73 3f                	jae    80103540 <scheduler+0x66>
      if(p->state != RUNNABLE)
80103501:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103505:	75 ef                	jne    801034f6 <scheduler+0x1c>
      c->proc = p;
80103507:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010350d:	83 ec 0c             	sub    $0xc,%esp
80103510:	53                   	push   %ebx
80103511:	e8 41 2c 00 00       	call   80106157 <switchuvm>
      p->state = RUNNING;
80103516:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
8010351d:	83 c4 08             	add    $0x8,%esp
80103520:	ff 73 1c             	pushl  0x1c(%ebx)
80103523:	8d 46 04             	lea    0x4(%esi),%eax
80103526:	50                   	push   %eax
80103527:	e8 a4 09 00 00       	call   80103ed0 <swtch>
      switchkvm();
8010352c:	e8 14 2c 00 00       	call   80106145 <switchkvm>
      c->proc = 0;
80103531:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103538:	00 00 00 
8010353b:	83 c4 10             	add    $0x10,%esp
8010353e:	eb b6                	jmp    801034f6 <scheduler+0x1c>
    release(&ptable.lock);
80103540:	83 ec 0c             	sub    $0xc,%esp
80103543:	68 20 2d 11 80       	push   $0x80112d20
80103548:	e8 76 07 00 00       	call   80103cc3 <release>
    sti();
8010354d:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103550:	fb                   	sti    
    acquire(&ptable.lock);
80103551:	83 ec 0c             	sub    $0xc,%esp
80103554:	68 20 2d 11 80       	push   $0x80112d20
80103559:	e8 fc 06 00 00       	call   80103c5a <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010355e:	83 c4 10             	add    $0x10,%esp
80103561:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103566:	eb 91                	jmp    801034f9 <scheduler+0x1f>

80103568 <sched>:
{
80103568:	f3 0f 1e fb          	endbr32 
8010356c:	55                   	push   %ebp
8010356d:	89 e5                	mov    %esp,%ebp
8010356f:	56                   	push   %esi
80103570:	53                   	push   %ebx
  struct proc *p = myproc();
80103571:	e8 db fc ff ff       	call   80103251 <myproc>
80103576:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103578:	83 ec 0c             	sub    $0xc,%esp
8010357b:	68 20 2d 11 80       	push   $0x80112d20
80103580:	e8 91 06 00 00       	call   80103c16 <holding>
80103585:	83 c4 10             	add    $0x10,%esp
80103588:	85 c0                	test   %eax,%eax
8010358a:	74 4f                	je     801035db <sched+0x73>
  if(mycpu()->ncli != 1)
8010358c:	e8 24 fc ff ff       	call   801031b5 <mycpu>
80103591:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103598:	75 4e                	jne    801035e8 <sched+0x80>
  if(p->state == RUNNING)
8010359a:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
8010359e:	74 55                	je     801035f5 <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035a0:	9c                   	pushf  
801035a1:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035a2:	f6 c4 02             	test   $0x2,%ah
801035a5:	75 5b                	jne    80103602 <sched+0x9a>
  intena = mycpu()->intena;
801035a7:	e8 09 fc ff ff       	call   801031b5 <mycpu>
801035ac:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801035b2:	e8 fe fb ff ff       	call   801031b5 <mycpu>
801035b7:	83 ec 08             	sub    $0x8,%esp
801035ba:	ff 70 04             	pushl  0x4(%eax)
801035bd:	83 c3 1c             	add    $0x1c,%ebx
801035c0:	53                   	push   %ebx
801035c1:	e8 0a 09 00 00       	call   80103ed0 <swtch>
  mycpu()->intena = intena;
801035c6:	e8 ea fb ff ff       	call   801031b5 <mycpu>
801035cb:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801035d1:	83 c4 10             	add    $0x10,%esp
801035d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035d7:	5b                   	pop    %ebx
801035d8:	5e                   	pop    %esi
801035d9:	5d                   	pop    %ebp
801035da:	c3                   	ret    
    panic("sched ptable.lock");
801035db:	83 ec 0c             	sub    $0xc,%esp
801035de:	68 7b 6d 10 80       	push   $0x80106d7b
801035e3:	e8 6d cd ff ff       	call   80100355 <panic>
    panic("sched locks");
801035e8:	83 ec 0c             	sub    $0xc,%esp
801035eb:	68 8d 6d 10 80       	push   $0x80106d8d
801035f0:	e8 60 cd ff ff       	call   80100355 <panic>
    panic("sched running");
801035f5:	83 ec 0c             	sub    $0xc,%esp
801035f8:	68 99 6d 10 80       	push   $0x80106d99
801035fd:	e8 53 cd ff ff       	call   80100355 <panic>
    panic("sched interruptible");
80103602:	83 ec 0c             	sub    $0xc,%esp
80103605:	68 a7 6d 10 80       	push   $0x80106da7
8010360a:	e8 46 cd ff ff       	call   80100355 <panic>

8010360f <exit>:
{
8010360f:	f3 0f 1e fb          	endbr32 
80103613:	55                   	push   %ebp
80103614:	89 e5                	mov    %esp,%ebp
80103616:	56                   	push   %esi
80103617:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103618:	e8 34 fc ff ff       	call   80103251 <myproc>
8010361d:	89 c6                	mov    %eax,%esi
  curproc->exit_status = status; // Guardamos el estado de salida en la estructura del proceso
8010361f:	8b 45 08             	mov    0x8(%ebp),%eax
80103622:	89 46 7c             	mov    %eax,0x7c(%esi)
  if(curproc == initproc)
80103625:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
8010362b:	74 07                	je     80103634 <exit+0x25>
  for(fd = 0; fd < NOFILE; fd++){
8010362d:	bb 00 00 00 00       	mov    $0x0,%ebx
80103632:	eb 22                	jmp    80103656 <exit+0x47>
    panic("init exiting");
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	68 bb 6d 10 80       	push   $0x80106dbb
8010363c:	e8 14 cd ff ff       	call   80100355 <panic>
      fileclose(curproc->ofile[fd]);
80103641:	83 ec 0c             	sub    $0xc,%esp
80103644:	50                   	push   %eax
80103645:	e8 83 d6 ff ff       	call   80100ccd <fileclose>
      curproc->ofile[fd] = 0;
8010364a:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
80103651:	00 
80103652:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103655:	43                   	inc    %ebx
80103656:	83 fb 0f             	cmp    $0xf,%ebx
80103659:	7f 0a                	jg     80103665 <exit+0x56>
    if(curproc->ofile[fd]){
8010365b:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
8010365f:	85 c0                	test   %eax,%eax
80103661:	75 de                	jne    80103641 <exit+0x32>
80103663:	eb f0                	jmp    80103655 <exit+0x46>
  begin_op();
80103665:	e8 69 f1 ff ff       	call   801027d3 <begin_op>
  iput(curproc->cwd);
8010366a:	83 ec 0c             	sub    $0xc,%esp
8010366d:	ff 76 68             	pushl  0x68(%esi)
80103670:	e8 1e e0 ff ff       	call   80101693 <iput>
  end_op();
80103675:	e8 d9 f1 ff ff       	call   80102853 <end_op>
  curproc->cwd = 0;
8010367a:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103681:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103688:	e8 cd 05 00 00       	call   80103c5a <acquire>
  wakeup1(curproc->parent);
8010368d:	8b 46 14             	mov    0x14(%esi),%eax
80103690:	e8 d6 f9 ff ff       	call   8010306b <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103695:	83 c4 10             	add    $0x10,%esp
80103698:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010369d:	eb 03                	jmp    801036a2 <exit+0x93>
8010369f:	83 eb 80             	sub    $0xffffff80,%ebx
801036a2:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801036a8:	73 1a                	jae    801036c4 <exit+0xb5>
    if(p->parent == curproc){
801036aa:	39 73 14             	cmp    %esi,0x14(%ebx)
801036ad:	75 f0                	jne    8010369f <exit+0x90>
      p->parent = initproc;
801036af:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801036b4:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801036b7:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801036bb:	75 e2                	jne    8010369f <exit+0x90>
        wakeup1(initproc);
801036bd:	e8 a9 f9 ff ff       	call   8010306b <wakeup1>
801036c2:	eb db                	jmp    8010369f <exit+0x90>
  deallocuvm(curproc->pgdir, KERNBASE, 0);
801036c4:	83 ec 04             	sub    $0x4,%esp
801036c7:	6a 00                	push   $0x0
801036c9:	68 00 00 00 80       	push   $0x80000000
801036ce:	ff 76 04             	pushl  0x4(%esi)
801036d1:	e8 a4 2c 00 00       	call   8010637a <deallocuvm>
  curproc->state = ZOMBIE;
801036d6:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801036dd:	e8 86 fe ff ff       	call   80103568 <sched>
  panic("zombie exit");
801036e2:	c7 04 24 c8 6d 10 80 	movl   $0x80106dc8,(%esp)
801036e9:	e8 67 cc ff ff       	call   80100355 <panic>

801036ee <yield>:
{
801036ee:	f3 0f 1e fb          	endbr32 
801036f2:	55                   	push   %ebp
801036f3:	89 e5                	mov    %esp,%ebp
801036f5:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801036f8:	68 20 2d 11 80       	push   $0x80112d20
801036fd:	e8 58 05 00 00       	call   80103c5a <acquire>
  myproc()->state = RUNNABLE;
80103702:	e8 4a fb ff ff       	call   80103251 <myproc>
80103707:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010370e:	e8 55 fe ff ff       	call   80103568 <sched>
  release(&ptable.lock);
80103713:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010371a:	e8 a4 05 00 00       	call   80103cc3 <release>
}
8010371f:	83 c4 10             	add    $0x10,%esp
80103722:	c9                   	leave  
80103723:	c3                   	ret    

80103724 <sleep>:
{
80103724:	f3 0f 1e fb          	endbr32 
80103728:	55                   	push   %ebp
80103729:	89 e5                	mov    %esp,%ebp
8010372b:	56                   	push   %esi
8010372c:	53                   	push   %ebx
8010372d:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103730:	e8 1c fb ff ff       	call   80103251 <myproc>
  if(p == 0)
80103735:	85 c0                	test   %eax,%eax
80103737:	74 66                	je     8010379f <sleep+0x7b>
80103739:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
8010373b:	85 f6                	test   %esi,%esi
8010373d:	74 6d                	je     801037ac <sleep+0x88>
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010373f:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103745:	74 18                	je     8010375f <sleep+0x3b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103747:	83 ec 0c             	sub    $0xc,%esp
8010374a:	68 20 2d 11 80       	push   $0x80112d20
8010374f:	e8 06 05 00 00       	call   80103c5a <acquire>
    release(lk);
80103754:	89 34 24             	mov    %esi,(%esp)
80103757:	e8 67 05 00 00       	call   80103cc3 <release>
8010375c:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
8010375f:	8b 45 08             	mov    0x8(%ebp),%eax
80103762:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
80103765:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010376c:	e8 f7 fd ff ff       	call   80103568 <sched>
  p->chan = 0;
80103771:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
80103778:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010377e:	74 18                	je     80103798 <sleep+0x74>
    release(&ptable.lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
80103783:	68 20 2d 11 80       	push   $0x80112d20
80103788:	e8 36 05 00 00       	call   80103cc3 <release>
    acquire(lk);
8010378d:	89 34 24             	mov    %esi,(%esp)
80103790:	e8 c5 04 00 00       	call   80103c5a <acquire>
80103795:	83 c4 10             	add    $0x10,%esp
}
80103798:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010379b:	5b                   	pop    %ebx
8010379c:	5e                   	pop    %esi
8010379d:	5d                   	pop    %ebp
8010379e:	c3                   	ret    
    panic("sleep");
8010379f:	83 ec 0c             	sub    $0xc,%esp
801037a2:	68 d4 6d 10 80       	push   $0x80106dd4
801037a7:	e8 a9 cb ff ff       	call   80100355 <panic>
    panic("sleep without lk");
801037ac:	83 ec 0c             	sub    $0xc,%esp
801037af:	68 da 6d 10 80       	push   $0x80106dda
801037b4:	e8 9c cb ff ff       	call   80100355 <panic>

801037b9 <wait>:
{
801037b9:	f3 0f 1e fb          	endbr32 
801037bd:	55                   	push   %ebp
801037be:	89 e5                	mov    %esp,%ebp
801037c0:	56                   	push   %esi
801037c1:	53                   	push   %ebx
  struct proc *curproc = myproc();
801037c2:	e8 8a fa ff ff       	call   80103251 <myproc>
801037c7:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801037c9:	83 ec 0c             	sub    $0xc,%esp
801037cc:	68 20 2d 11 80       	push   $0x80112d20
801037d1:	e8 84 04 00 00       	call   80103c5a <acquire>
801037d6:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801037d9:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037de:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801037e3:	eb 65                	jmp    8010384a <wait+0x91>
        pid = p->pid;
801037e5:	8b 73 10             	mov    0x10(%ebx),%esi
        *status = p->exit_status; // Guardamos el estado de salida del proceso hijo cuando este termina
801037e8:	8b 53 7c             	mov    0x7c(%ebx),%edx
801037eb:	8b 45 08             	mov    0x8(%ebp),%eax
801037ee:	89 10                	mov    %edx,(%eax)
        kfree(p->kstack);
801037f0:	83 ec 0c             	sub    $0xc,%esp
801037f3:	ff 73 08             	pushl  0x8(%ebx)
801037f6:	e8 da e7 ff ff       	call   80101fd5 <kfree>
        p->kstack = 0;
801037fb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir, 0); // User zone deleted before
80103802:	83 c4 08             	add    $0x8,%esp
80103805:	6a 00                	push   $0x0
80103807:	ff 73 04             	pushl  0x4(%ebx)
8010380a:	e8 ef 2c 00 00       	call   801064fe <freevm>
        p->pid = 0;
8010380f:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103816:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010381d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103821:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103828:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010382f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103836:	e8 88 04 00 00       	call   80103cc3 <release>
        return pid;
8010383b:	83 c4 10             	add    $0x10,%esp
}
8010383e:	89 f0                	mov    %esi,%eax
80103840:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103843:	5b                   	pop    %ebx
80103844:	5e                   	pop    %esi
80103845:	5d                   	pop    %ebp
80103846:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103847:	83 eb 80             	sub    $0xffffff80,%ebx
8010384a:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103850:	73 12                	jae    80103864 <wait+0xab>
      if(p->parent != curproc)
80103852:	39 73 14             	cmp    %esi,0x14(%ebx)
80103855:	75 f0                	jne    80103847 <wait+0x8e>
      if(p->state == ZOMBIE){
80103857:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010385b:	74 88                	je     801037e5 <wait+0x2c>
      havekids = 1;
8010385d:	b8 01 00 00 00       	mov    $0x1,%eax
80103862:	eb e3                	jmp    80103847 <wait+0x8e>
    if(!havekids || curproc->killed){
80103864:	85 c0                	test   %eax,%eax
80103866:	74 06                	je     8010386e <wait+0xb5>
80103868:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
8010386c:	74 17                	je     80103885 <wait+0xcc>
      release(&ptable.lock);
8010386e:	83 ec 0c             	sub    $0xc,%esp
80103871:	68 20 2d 11 80       	push   $0x80112d20
80103876:	e8 48 04 00 00       	call   80103cc3 <release>
      return -1;
8010387b:	83 c4 10             	add    $0x10,%esp
8010387e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103883:	eb b9                	jmp    8010383e <wait+0x85>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103885:	83 ec 08             	sub    $0x8,%esp
80103888:	68 20 2d 11 80       	push   $0x80112d20
8010388d:	56                   	push   %esi
8010388e:	e8 91 fe ff ff       	call   80103724 <sleep>
    havekids = 0;
80103893:	83 c4 10             	add    $0x10,%esp
80103896:	e9 3e ff ff ff       	jmp    801037d9 <wait+0x20>

8010389b <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010389b:	f3 0f 1e fb          	endbr32 
8010389f:	55                   	push   %ebp
801038a0:	89 e5                	mov    %esp,%ebp
801038a2:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801038a5:	68 20 2d 11 80       	push   $0x80112d20
801038aa:	e8 ab 03 00 00       	call   80103c5a <acquire>
  wakeup1(chan);
801038af:	8b 45 08             	mov    0x8(%ebp),%eax
801038b2:	e8 b4 f7 ff ff       	call   8010306b <wakeup1>
  release(&ptable.lock);
801038b7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038be:	e8 00 04 00 00       	call   80103cc3 <release>
}
801038c3:	83 c4 10             	add    $0x10,%esp
801038c6:	c9                   	leave  
801038c7:	c3                   	ret    

801038c8 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801038c8:	f3 0f 1e fb          	endbr32 
801038cc:	55                   	push   %ebp
801038cd:	89 e5                	mov    %esp,%ebp
801038cf:	53                   	push   %ebx
801038d0:	83 ec 10             	sub    $0x10,%esp
801038d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801038d6:	68 20 2d 11 80       	push   $0x80112d20
801038db:	e8 7a 03 00 00       	call   80103c5a <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038e0:	83 c4 10             	add    $0x10,%esp
801038e3:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801038e8:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801038ed:	73 3a                	jae    80103929 <kill+0x61>
    if(p->pid == pid){
801038ef:	39 58 10             	cmp    %ebx,0x10(%eax)
801038f2:	74 05                	je     801038f9 <kill+0x31>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038f4:	83 e8 80             	sub    $0xffffff80,%eax
801038f7:	eb ef                	jmp    801038e8 <kill+0x20>
      p->killed = 1;
801038f9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103900:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103904:	74 1a                	je     80103920 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103906:	83 ec 0c             	sub    $0xc,%esp
80103909:	68 20 2d 11 80       	push   $0x80112d20
8010390e:	e8 b0 03 00 00       	call   80103cc3 <release>
      return 0;
80103913:	83 c4 10             	add    $0x10,%esp
80103916:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010391b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010391e:	c9                   	leave  
8010391f:	c3                   	ret    
        p->state = RUNNABLE;
80103920:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103927:	eb dd                	jmp    80103906 <kill+0x3e>
  release(&ptable.lock);
80103929:	83 ec 0c             	sub    $0xc,%esp
8010392c:	68 20 2d 11 80       	push   $0x80112d20
80103931:	e8 8d 03 00 00       	call   80103cc3 <release>
  return -1;
80103936:	83 c4 10             	add    $0x10,%esp
80103939:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010393e:	eb db                	jmp    8010391b <kill+0x53>

80103940 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103940:	f3 0f 1e fb          	endbr32 
80103944:	55                   	push   %ebp
80103945:	89 e5                	mov    %esp,%ebp
80103947:	56                   	push   %esi
80103948:	53                   	push   %ebx
80103949:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010394c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103951:	eb 33                	jmp    80103986 <procdump+0x46>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103953:	b8 eb 6d 10 80       	mov    $0x80106deb,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103958:	8d 53 6c             	lea    0x6c(%ebx),%edx
8010395b:	52                   	push   %edx
8010395c:	50                   	push   %eax
8010395d:	ff 73 10             	pushl  0x10(%ebx)
80103960:	68 ef 6d 10 80       	push   $0x80106def
80103965:	e8 93 cc ff ff       	call   801005fd <cprintf>
    if(p->state == SLEEPING){
8010396a:	83 c4 10             	add    $0x10,%esp
8010396d:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103971:	74 39                	je     801039ac <procdump+0x6c>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103973:	83 ec 0c             	sub    $0xc,%esp
80103976:	68 eb 71 10 80       	push   $0x801071eb
8010397b:	e8 7d cc ff ff       	call   801005fd <cprintf>
80103980:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103983:	83 eb 80             	sub    $0xffffff80,%ebx
80103986:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
8010398c:	73 5f                	jae    801039ed <procdump+0xad>
    if(p->state == UNUSED)
8010398e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103991:	85 c0                	test   %eax,%eax
80103993:	74 ee                	je     80103983 <procdump+0x43>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103995:	83 f8 05             	cmp    $0x5,%eax
80103998:	77 b9                	ja     80103953 <procdump+0x13>
8010399a:	8b 04 85 4c 6e 10 80 	mov    -0x7fef91b4(,%eax,4),%eax
801039a1:	85 c0                	test   %eax,%eax
801039a3:	75 b3                	jne    80103958 <procdump+0x18>
      state = "???";
801039a5:	b8 eb 6d 10 80       	mov    $0x80106deb,%eax
801039aa:	eb ac                	jmp    80103958 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801039ac:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039af:	8b 40 0c             	mov    0xc(%eax),%eax
801039b2:	83 c0 08             	add    $0x8,%eax
801039b5:	83 ec 08             	sub    $0x8,%esp
801039b8:	8d 55 d0             	lea    -0x30(%ebp),%edx
801039bb:	52                   	push   %edx
801039bc:	50                   	push   %eax
801039bd:	e8 6c 01 00 00       	call   80103b2e <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801039c2:	83 c4 10             	add    $0x10,%esp
801039c5:	be 00 00 00 00       	mov    $0x0,%esi
801039ca:	eb 12                	jmp    801039de <procdump+0x9e>
        cprintf(" %p", pc[i]);
801039cc:	83 ec 08             	sub    $0x8,%esp
801039cf:	50                   	push   %eax
801039d0:	68 41 68 10 80       	push   $0x80106841
801039d5:	e8 23 cc ff ff       	call   801005fd <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801039da:	46                   	inc    %esi
801039db:	83 c4 10             	add    $0x10,%esp
801039de:	83 fe 09             	cmp    $0x9,%esi
801039e1:	7f 90                	jg     80103973 <procdump+0x33>
801039e3:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
801039e7:	85 c0                	test   %eax,%eax
801039e9:	75 e1                	jne    801039cc <procdump+0x8c>
801039eb:	eb 86                	jmp    80103973 <procdump+0x33>
  }
}
801039ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039f0:	5b                   	pop    %ebx
801039f1:	5e                   	pop    %esi
801039f2:	5d                   	pop    %ebp
801039f3:	c3                   	ret    

801039f4 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801039f4:	f3 0f 1e fb          	endbr32 
801039f8:	55                   	push   %ebp
801039f9:	89 e5                	mov    %esp,%ebp
801039fb:	53                   	push   %ebx
801039fc:	83 ec 0c             	sub    $0xc,%esp
801039ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103a02:	68 64 6e 10 80       	push   $0x80106e64
80103a07:	8d 43 04             	lea    0x4(%ebx),%eax
80103a0a:	50                   	push   %eax
80103a0b:	e8 ff 00 00 00       	call   80103b0f <initlock>
  lk->name = name;
80103a10:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a13:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103a16:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103a1c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103a23:	83 c4 10             	add    $0x10,%esp
80103a26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a29:	c9                   	leave  
80103a2a:	c3                   	ret    

80103a2b <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103a2b:	f3 0f 1e fb          	endbr32 
80103a2f:	55                   	push   %ebp
80103a30:	89 e5                	mov    %esp,%ebp
80103a32:	56                   	push   %esi
80103a33:	53                   	push   %ebx
80103a34:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103a37:	8d 73 04             	lea    0x4(%ebx),%esi
80103a3a:	83 ec 0c             	sub    $0xc,%esp
80103a3d:	56                   	push   %esi
80103a3e:	e8 17 02 00 00       	call   80103c5a <acquire>
  while (lk->locked) {
80103a43:	83 c4 10             	add    $0x10,%esp
80103a46:	83 3b 00             	cmpl   $0x0,(%ebx)
80103a49:	74 0f                	je     80103a5a <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80103a4b:	83 ec 08             	sub    $0x8,%esp
80103a4e:	56                   	push   %esi
80103a4f:	53                   	push   %ebx
80103a50:	e8 cf fc ff ff       	call   80103724 <sleep>
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	eb ec                	jmp    80103a46 <acquiresleep+0x1b>
  }
  lk->locked = 1;
80103a5a:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103a60:	e8 ec f7 ff ff       	call   80103251 <myproc>
80103a65:	8b 40 10             	mov    0x10(%eax),%eax
80103a68:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103a6b:	83 ec 0c             	sub    $0xc,%esp
80103a6e:	56                   	push   %esi
80103a6f:	e8 4f 02 00 00       	call   80103cc3 <release>
}
80103a74:	83 c4 10             	add    $0x10,%esp
80103a77:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a7a:	5b                   	pop    %ebx
80103a7b:	5e                   	pop    %esi
80103a7c:	5d                   	pop    %ebp
80103a7d:	c3                   	ret    

80103a7e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103a7e:	f3 0f 1e fb          	endbr32 
80103a82:	55                   	push   %ebp
80103a83:	89 e5                	mov    %esp,%ebp
80103a85:	56                   	push   %esi
80103a86:	53                   	push   %ebx
80103a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103a8a:	8d 73 04             	lea    0x4(%ebx),%esi
80103a8d:	83 ec 0c             	sub    $0xc,%esp
80103a90:	56                   	push   %esi
80103a91:	e8 c4 01 00 00       	call   80103c5a <acquire>
  lk->locked = 0;
80103a96:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103a9c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103aa3:	89 1c 24             	mov    %ebx,(%esp)
80103aa6:	e8 f0 fd ff ff       	call   8010389b <wakeup>
  release(&lk->lk);
80103aab:	89 34 24             	mov    %esi,(%esp)
80103aae:	e8 10 02 00 00       	call   80103cc3 <release>
}
80103ab3:	83 c4 10             	add    $0x10,%esp
80103ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ab9:	5b                   	pop    %ebx
80103aba:	5e                   	pop    %esi
80103abb:	5d                   	pop    %ebp
80103abc:	c3                   	ret    

80103abd <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103abd:	f3 0f 1e fb          	endbr32 
80103ac1:	55                   	push   %ebp
80103ac2:	89 e5                	mov    %esp,%ebp
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103ac9:	8d 73 04             	lea    0x4(%ebx),%esi
80103acc:	83 ec 0c             	sub    $0xc,%esp
80103acf:	56                   	push   %esi
80103ad0:	e8 85 01 00 00       	call   80103c5a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103ad5:	83 c4 10             	add    $0x10,%esp
80103ad8:	83 3b 00             	cmpl   $0x0,(%ebx)
80103adb:	75 17                	jne    80103af4 <holdingsleep+0x37>
80103add:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103ae2:	83 ec 0c             	sub    $0xc,%esp
80103ae5:	56                   	push   %esi
80103ae6:	e8 d8 01 00 00       	call   80103cc3 <release>
  return r;
}
80103aeb:	89 d8                	mov    %ebx,%eax
80103aed:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103af0:	5b                   	pop    %ebx
80103af1:	5e                   	pop    %esi
80103af2:	5d                   	pop    %ebp
80103af3:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103af4:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103af7:	e8 55 f7 ff ff       	call   80103251 <myproc>
80103afc:	3b 58 10             	cmp    0x10(%eax),%ebx
80103aff:	74 07                	je     80103b08 <holdingsleep+0x4b>
80103b01:	bb 00 00 00 00       	mov    $0x0,%ebx
80103b06:	eb da                	jmp    80103ae2 <holdingsleep+0x25>
80103b08:	bb 01 00 00 00       	mov    $0x1,%ebx
80103b0d:	eb d3                	jmp    80103ae2 <holdingsleep+0x25>

80103b0f <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103b0f:	f3 0f 1e fb          	endbr32 
80103b13:	55                   	push   %ebp
80103b14:	89 e5                	mov    %esp,%ebp
80103b16:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103b19:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b1c:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103b1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103b25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103b2c:	5d                   	pop    %ebp
80103b2d:	c3                   	ret    

80103b2e <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103b2e:	f3 0f 1e fb          	endbr32 
80103b32:	55                   	push   %ebp
80103b33:	89 e5                	mov    %esp,%ebp
80103b35:	53                   	push   %ebx
80103b36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103b39:	8b 45 08             	mov    0x8(%ebp),%eax
80103b3c:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103b3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103b44:	83 f8 09             	cmp    $0x9,%eax
80103b47:	7f 21                	jg     80103b6a <getcallerpcs+0x3c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103b49:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103b4f:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103b55:	77 13                	ja     80103b6a <getcallerpcs+0x3c>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103b57:	8b 5a 04             	mov    0x4(%edx),%ebx
80103b5a:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103b5d:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103b5f:	40                   	inc    %eax
80103b60:	eb e2                	jmp    80103b44 <getcallerpcs+0x16>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103b62:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103b69:	40                   	inc    %eax
80103b6a:	83 f8 09             	cmp    $0x9,%eax
80103b6d:	7e f3                	jle    80103b62 <getcallerpcs+0x34>
}
80103b6f:	5b                   	pop    %ebx
80103b70:	5d                   	pop    %ebp
80103b71:	c3                   	ret    

80103b72 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103b72:	f3 0f 1e fb          	endbr32 
80103b76:	55                   	push   %ebp
80103b77:	89 e5                	mov    %esp,%ebp
80103b79:	53                   	push   %ebx
80103b7a:	83 ec 04             	sub    $0x4,%esp
80103b7d:	9c                   	pushf  
80103b7e:	5b                   	pop    %ebx
  asm volatile("cli");
80103b7f:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103b80:	e8 30 f6 ff ff       	call   801031b5 <mycpu>
80103b85:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103b8c:	74 11                	je     80103b9f <pushcli+0x2d>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103b8e:	e8 22 f6 ff ff       	call   801031b5 <mycpu>
80103b93:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103b99:	83 c4 04             	add    $0x4,%esp
80103b9c:	5b                   	pop    %ebx
80103b9d:	5d                   	pop    %ebp
80103b9e:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103b9f:	e8 11 f6 ff ff       	call   801031b5 <mycpu>
80103ba4:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103baa:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103bb0:	eb dc                	jmp    80103b8e <pushcli+0x1c>

80103bb2 <popcli>:

void
popcli(void)
{
80103bb2:	f3 0f 1e fb          	endbr32 
80103bb6:	55                   	push   %ebp
80103bb7:	89 e5                	mov    %esp,%ebp
80103bb9:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bbc:	9c                   	pushf  
80103bbd:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103bbe:	f6 c4 02             	test   $0x2,%ah
80103bc1:	75 28                	jne    80103beb <popcli+0x39>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103bc3:	e8 ed f5 ff ff       	call   801031b5 <mycpu>
80103bc8:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103bce:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103bd1:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103bd7:	85 d2                	test   %edx,%edx
80103bd9:	78 1d                	js     80103bf8 <popcli+0x46>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103bdb:	e8 d5 f5 ff ff       	call   801031b5 <mycpu>
80103be0:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103be7:	74 1c                	je     80103c05 <popcli+0x53>
    sti();
}
80103be9:	c9                   	leave  
80103bea:	c3                   	ret    
    panic("popcli - interruptible");
80103beb:	83 ec 0c             	sub    $0xc,%esp
80103bee:	68 6f 6e 10 80       	push   $0x80106e6f
80103bf3:	e8 5d c7 ff ff       	call   80100355 <panic>
    panic("popcli");
80103bf8:	83 ec 0c             	sub    $0xc,%esp
80103bfb:	68 86 6e 10 80       	push   $0x80106e86
80103c00:	e8 50 c7 ff ff       	call   80100355 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c05:	e8 ab f5 ff ff       	call   801031b5 <mycpu>
80103c0a:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103c11:	74 d6                	je     80103be9 <popcli+0x37>
  asm volatile("sti");
80103c13:	fb                   	sti    
}
80103c14:	eb d3                	jmp    80103be9 <popcli+0x37>

80103c16 <holding>:
{
80103c16:	f3 0f 1e fb          	endbr32 
80103c1a:	55                   	push   %ebp
80103c1b:	89 e5                	mov    %esp,%ebp
80103c1d:	53                   	push   %ebx
80103c1e:	83 ec 04             	sub    $0x4,%esp
80103c21:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103c24:	e8 49 ff ff ff       	call   80103b72 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103c29:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c2c:	75 12                	jne    80103c40 <holding+0x2a>
80103c2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103c33:	e8 7a ff ff ff       	call   80103bb2 <popcli>
}
80103c38:	89 d8                	mov    %ebx,%eax
80103c3a:	83 c4 04             	add    $0x4,%esp
80103c3d:	5b                   	pop    %ebx
80103c3e:	5d                   	pop    %ebp
80103c3f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103c40:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103c43:	e8 6d f5 ff ff       	call   801031b5 <mycpu>
80103c48:	39 c3                	cmp    %eax,%ebx
80103c4a:	74 07                	je     80103c53 <holding+0x3d>
80103c4c:	bb 00 00 00 00       	mov    $0x0,%ebx
80103c51:	eb e0                	jmp    80103c33 <holding+0x1d>
80103c53:	bb 01 00 00 00       	mov    $0x1,%ebx
80103c58:	eb d9                	jmp    80103c33 <holding+0x1d>

80103c5a <acquire>:
{
80103c5a:	f3 0f 1e fb          	endbr32 
80103c5e:	55                   	push   %ebp
80103c5f:	89 e5                	mov    %esp,%ebp
80103c61:	53                   	push   %ebx
80103c62:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103c65:	e8 08 ff ff ff       	call   80103b72 <pushcli>
  if(holding(lk))
80103c6a:	83 ec 0c             	sub    $0xc,%esp
80103c6d:	ff 75 08             	pushl  0x8(%ebp)
80103c70:	e8 a1 ff ff ff       	call   80103c16 <holding>
80103c75:	83 c4 10             	add    $0x10,%esp
80103c78:	85 c0                	test   %eax,%eax
80103c7a:	75 3a                	jne    80103cb6 <acquire+0x5c>
  while(xchg(&lk->locked, 1) != 0)
80103c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103c7f:	b8 01 00 00 00       	mov    $0x1,%eax
80103c84:	f0 87 02             	lock xchg %eax,(%edx)
80103c87:	85 c0                	test   %eax,%eax
80103c89:	75 f1                	jne    80103c7c <acquire+0x22>
  __sync_synchronize();
80103c8b:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103c90:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c93:	e8 1d f5 ff ff       	call   801031b5 <mycpu>
80103c98:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103c9b:	8b 45 08             	mov    0x8(%ebp),%eax
80103c9e:	83 c0 0c             	add    $0xc,%eax
80103ca1:	83 ec 08             	sub    $0x8,%esp
80103ca4:	50                   	push   %eax
80103ca5:	8d 45 08             	lea    0x8(%ebp),%eax
80103ca8:	50                   	push   %eax
80103ca9:	e8 80 fe ff ff       	call   80103b2e <getcallerpcs>
}
80103cae:	83 c4 10             	add    $0x10,%esp
80103cb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cb4:	c9                   	leave  
80103cb5:	c3                   	ret    
    panic("acquire");
80103cb6:	83 ec 0c             	sub    $0xc,%esp
80103cb9:	68 8d 6e 10 80       	push   $0x80106e8d
80103cbe:	e8 92 c6 ff ff       	call   80100355 <panic>

80103cc3 <release>:
{
80103cc3:	f3 0f 1e fb          	endbr32 
80103cc7:	55                   	push   %ebp
80103cc8:	89 e5                	mov    %esp,%ebp
80103cca:	53                   	push   %ebx
80103ccb:	83 ec 10             	sub    $0x10,%esp
80103cce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103cd1:	53                   	push   %ebx
80103cd2:	e8 3f ff ff ff       	call   80103c16 <holding>
80103cd7:	83 c4 10             	add    $0x10,%esp
80103cda:	85 c0                	test   %eax,%eax
80103cdc:	74 23                	je     80103d01 <release+0x3e>
  lk->pcs[0] = 0;
80103cde:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103ce5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103cec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103cf1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103cf7:	e8 b6 fe ff ff       	call   80103bb2 <popcli>
}
80103cfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cff:	c9                   	leave  
80103d00:	c3                   	ret    
    panic("release");
80103d01:	83 ec 0c             	sub    $0xc,%esp
80103d04:	68 95 6e 10 80       	push   $0x80106e95
80103d09:	e8 47 c6 ff ff       	call   80100355 <panic>

80103d0e <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103d0e:	f3 0f 1e fb          	endbr32 
80103d12:	55                   	push   %ebp
80103d13:	89 e5                	mov    %esp,%ebp
80103d15:	57                   	push   %edi
80103d16:	53                   	push   %ebx
80103d17:	8b 55 08             	mov    0x8(%ebp),%edx
80103d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80103d1d:	f6 c2 03             	test   $0x3,%dl
80103d20:	75 29                	jne    80103d4b <memset+0x3d>
80103d22:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103d26:	75 23                	jne    80103d4b <memset+0x3d>
    c &= 0xFF;
80103d28:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103d2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103d2e:	c1 e9 02             	shr    $0x2,%ecx
80103d31:	c1 e0 18             	shl    $0x18,%eax
80103d34:	89 fb                	mov    %edi,%ebx
80103d36:	c1 e3 10             	shl    $0x10,%ebx
80103d39:	09 d8                	or     %ebx,%eax
80103d3b:	89 fb                	mov    %edi,%ebx
80103d3d:	c1 e3 08             	shl    $0x8,%ebx
80103d40:	09 d8                	or     %ebx,%eax
80103d42:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103d44:	89 d7                	mov    %edx,%edi
80103d46:	fc                   	cld    
80103d47:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103d49:	eb 08                	jmp    80103d53 <memset+0x45>
  asm volatile("cld; rep stosb" :
80103d4b:	89 d7                	mov    %edx,%edi
80103d4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103d50:	fc                   	cld    
80103d51:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103d53:	89 d0                	mov    %edx,%eax
80103d55:	5b                   	pop    %ebx
80103d56:	5f                   	pop    %edi
80103d57:	5d                   	pop    %ebp
80103d58:	c3                   	ret    

80103d59 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103d59:	f3 0f 1e fb          	endbr32 
80103d5d:	55                   	push   %ebp
80103d5e:	89 e5                	mov    %esp,%ebp
80103d60:	56                   	push   %esi
80103d61:	53                   	push   %ebx
80103d62:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103d65:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d68:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103d6b:	8d 70 ff             	lea    -0x1(%eax),%esi
80103d6e:	85 c0                	test   %eax,%eax
80103d70:	74 16                	je     80103d88 <memcmp+0x2f>
    if(*s1 != *s2)
80103d72:	8a 01                	mov    (%ecx),%al
80103d74:	8a 1a                	mov    (%edx),%bl
80103d76:	38 d8                	cmp    %bl,%al
80103d78:	75 06                	jne    80103d80 <memcmp+0x27>
      return *s1 - *s2;
    s1++, s2++;
80103d7a:	41                   	inc    %ecx
80103d7b:	42                   	inc    %edx
  while(n-- > 0){
80103d7c:	89 f0                	mov    %esi,%eax
80103d7e:	eb eb                	jmp    80103d6b <memcmp+0x12>
      return *s1 - *s2;
80103d80:	0f b6 c0             	movzbl %al,%eax
80103d83:	0f b6 db             	movzbl %bl,%ebx
80103d86:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103d88:	5b                   	pop    %ebx
80103d89:	5e                   	pop    %esi
80103d8a:	5d                   	pop    %ebp
80103d8b:	c3                   	ret    

80103d8c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103d8c:	f3 0f 1e fb          	endbr32 
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
80103d95:	8b 75 08             	mov    0x8(%ebp),%esi
80103d98:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103d9e:	39 f2                	cmp    %esi,%edx
80103da0:	73 34                	jae    80103dd6 <memmove+0x4a>
80103da2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103da5:	39 f1                	cmp    %esi,%ecx
80103da7:	76 31                	jbe    80103dda <memmove+0x4e>
    s += n;
    d += n;
80103da9:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103dac:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103daf:	85 c0                	test   %eax,%eax
80103db1:	74 1d                	je     80103dd0 <memmove+0x44>
      *--d = *--s;
80103db3:	49                   	dec    %ecx
80103db4:	4a                   	dec    %edx
80103db5:	8a 01                	mov    (%ecx),%al
80103db7:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103db9:	89 d8                	mov    %ebx,%eax
80103dbb:	eb ef                	jmp    80103dac <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103dbd:	8a 02                	mov    (%edx),%al
80103dbf:	88 01                	mov    %al,(%ecx)
80103dc1:	8d 49 01             	lea    0x1(%ecx),%ecx
80103dc4:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103dc7:	89 d8                	mov    %ebx,%eax
80103dc9:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103dcc:	85 c0                	test   %eax,%eax
80103dce:	75 ed                	jne    80103dbd <memmove+0x31>

  return dst;
}
80103dd0:	89 f0                	mov    %esi,%eax
80103dd2:	5b                   	pop    %ebx
80103dd3:	5e                   	pop    %esi
80103dd4:	5d                   	pop    %ebp
80103dd5:	c3                   	ret    
80103dd6:	89 f1                	mov    %esi,%ecx
80103dd8:	eb ef                	jmp    80103dc9 <memmove+0x3d>
80103dda:	89 f1                	mov    %esi,%ecx
80103ddc:	eb eb                	jmp    80103dc9 <memmove+0x3d>

80103dde <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103dde:	f3 0f 1e fb          	endbr32 
80103de2:	55                   	push   %ebp
80103de3:	89 e5                	mov    %esp,%ebp
80103de5:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103de8:	ff 75 10             	pushl  0x10(%ebp)
80103deb:	ff 75 0c             	pushl  0xc(%ebp)
80103dee:	ff 75 08             	pushl  0x8(%ebp)
80103df1:	e8 96 ff ff ff       	call   80103d8c <memmove>
}
80103df6:	c9                   	leave  
80103df7:	c3                   	ret    

80103df8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103df8:	f3 0f 1e fb          	endbr32 
80103dfc:	55                   	push   %ebp
80103dfd:	89 e5                	mov    %esp,%ebp
80103dff:	53                   	push   %ebx
80103e00:	8b 55 08             	mov    0x8(%ebp),%edx
80103e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103e06:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103e09:	eb 03                	jmp    80103e0e <strncmp+0x16>
    n--, p++, q++;
80103e0b:	48                   	dec    %eax
80103e0c:	42                   	inc    %edx
80103e0d:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
80103e0e:	85 c0                	test   %eax,%eax
80103e10:	74 0a                	je     80103e1c <strncmp+0x24>
80103e12:	8a 1a                	mov    (%edx),%bl
80103e14:	84 db                	test   %bl,%bl
80103e16:	74 04                	je     80103e1c <strncmp+0x24>
80103e18:	3a 19                	cmp    (%ecx),%bl
80103e1a:	74 ef                	je     80103e0b <strncmp+0x13>
  if(n == 0)
80103e1c:	85 c0                	test   %eax,%eax
80103e1e:	74 0b                	je     80103e2b <strncmp+0x33>
    return 0;
  return (uchar)*p - (uchar)*q;
80103e20:	0f b6 02             	movzbl (%edx),%eax
80103e23:	0f b6 11             	movzbl (%ecx),%edx
80103e26:	29 d0                	sub    %edx,%eax
}
80103e28:	5b                   	pop    %ebx
80103e29:	5d                   	pop    %ebp
80103e2a:	c3                   	ret    
    return 0;
80103e2b:	b8 00 00 00 00       	mov    $0x0,%eax
80103e30:	eb f6                	jmp    80103e28 <strncmp+0x30>

80103e32 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103e32:	f3 0f 1e fb          	endbr32 
80103e36:	55                   	push   %ebp
80103e37:	89 e5                	mov    %esp,%ebp
80103e39:	57                   	push   %edi
80103e3a:	56                   	push   %esi
80103e3b:	53                   	push   %ebx
80103e3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103e42:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103e45:	89 c1                	mov    %eax,%ecx
80103e47:	eb 04                	jmp    80103e4d <strncpy+0x1b>
80103e49:	89 fb                	mov    %edi,%ebx
80103e4b:	89 f1                	mov    %esi,%ecx
80103e4d:	89 d6                	mov    %edx,%esi
80103e4f:	4a                   	dec    %edx
80103e50:	85 f6                	test   %esi,%esi
80103e52:	7e 1a                	jle    80103e6e <strncpy+0x3c>
80103e54:	8d 7b 01             	lea    0x1(%ebx),%edi
80103e57:	8d 71 01             	lea    0x1(%ecx),%esi
80103e5a:	8a 1b                	mov    (%ebx),%bl
80103e5c:	88 19                	mov    %bl,(%ecx)
80103e5e:	84 db                	test   %bl,%bl
80103e60:	75 e7                	jne    80103e49 <strncpy+0x17>
80103e62:	89 f1                	mov    %esi,%ecx
80103e64:	eb 08                	jmp    80103e6e <strncpy+0x3c>
    ;
  while(n-- > 0)
    *s++ = 0;
80103e66:	c6 01 00             	movb   $0x0,(%ecx)
  while(n-- > 0)
80103e69:	89 da                	mov    %ebx,%edx
    *s++ = 0;
80103e6b:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
80103e6e:	8d 5a ff             	lea    -0x1(%edx),%ebx
80103e71:	85 d2                	test   %edx,%edx
80103e73:	7f f1                	jg     80103e66 <strncpy+0x34>
  return os;
}
80103e75:	5b                   	pop    %ebx
80103e76:	5e                   	pop    %esi
80103e77:	5f                   	pop    %edi
80103e78:	5d                   	pop    %ebp
80103e79:	c3                   	ret    

80103e7a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103e7a:	f3 0f 1e fb          	endbr32 
80103e7e:	55                   	push   %ebp
80103e7f:	89 e5                	mov    %esp,%ebp
80103e81:	57                   	push   %edi
80103e82:	56                   	push   %esi
80103e83:	53                   	push   %ebx
80103e84:	8b 45 08             	mov    0x8(%ebp),%eax
80103e87:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103e8a:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80103e8d:	85 d2                	test   %edx,%edx
80103e8f:	7e 20                	jle    80103eb1 <safestrcpy+0x37>
80103e91:	89 c1                	mov    %eax,%ecx
80103e93:	eb 04                	jmp    80103e99 <safestrcpy+0x1f>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103e95:	89 fb                	mov    %edi,%ebx
80103e97:	89 f1                	mov    %esi,%ecx
80103e99:	4a                   	dec    %edx
80103e9a:	85 d2                	test   %edx,%edx
80103e9c:	7e 10                	jle    80103eae <safestrcpy+0x34>
80103e9e:	8d 7b 01             	lea    0x1(%ebx),%edi
80103ea1:	8d 71 01             	lea    0x1(%ecx),%esi
80103ea4:	8a 1b                	mov    (%ebx),%bl
80103ea6:	88 19                	mov    %bl,(%ecx)
80103ea8:	84 db                	test   %bl,%bl
80103eaa:	75 e9                	jne    80103e95 <safestrcpy+0x1b>
80103eac:	89 f1                	mov    %esi,%ecx
    ;
  *s = 0;
80103eae:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80103eb1:	5b                   	pop    %ebx
80103eb2:	5e                   	pop    %esi
80103eb3:	5f                   	pop    %edi
80103eb4:	5d                   	pop    %ebp
80103eb5:	c3                   	ret    

80103eb6 <strlen>:

int
strlen(const char *s)
{
80103eb6:	f3 0f 1e fb          	endbr32 
80103eba:	55                   	push   %ebp
80103ebb:	89 e5                	mov    %esp,%ebp
80103ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103ec0:	b8 00 00 00 00       	mov    $0x0,%eax
80103ec5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103ec9:	74 03                	je     80103ece <strlen+0x18>
80103ecb:	40                   	inc    %eax
80103ecc:	eb f7                	jmp    80103ec5 <strlen+0xf>
    ;
  return n;
}
80103ece:	5d                   	pop    %ebp
80103ecf:	c3                   	ret    

80103ed0 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103ed0:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103ed4:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80103ed8:	55                   	push   %ebp
  pushl %ebx
80103ed9:	53                   	push   %ebx
  pushl %esi
80103eda:	56                   	push   %esi
  pushl %edi
80103edb:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103edc:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103ede:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80103ee0:	5f                   	pop    %edi
  popl %esi
80103ee1:	5e                   	pop    %esi
  popl %ebx
80103ee2:	5b                   	pop    %ebx
  popl %ebp
80103ee3:	5d                   	pop    %ebp
  ret
80103ee4:	c3                   	ret    

80103ee5 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103ee5:	f3 0f 1e fb          	endbr32 
80103ee9:	55                   	push   %ebp
80103eea:	89 e5                	mov    %esp,%ebp
80103eec:	53                   	push   %ebx
80103eed:	83 ec 04             	sub    $0x4,%esp
80103ef0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103ef3:	e8 59 f3 ff ff       	call   80103251 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103ef8:	8b 00                	mov    (%eax),%eax
80103efa:	39 d8                	cmp    %ebx,%eax
80103efc:	76 19                	jbe    80103f17 <fetchint+0x32>
80103efe:	8d 53 04             	lea    0x4(%ebx),%edx
80103f01:	39 d0                	cmp    %edx,%eax
80103f03:	72 19                	jb     80103f1e <fetchint+0x39>
    return -1;
  *ip = *(int*)(addr);
80103f05:	8b 13                	mov    (%ebx),%edx
80103f07:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f0a:	89 10                	mov    %edx,(%eax)
  return 0;
80103f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f11:	83 c4 04             	add    $0x4,%esp
80103f14:	5b                   	pop    %ebx
80103f15:	5d                   	pop    %ebp
80103f16:	c3                   	ret    
    return -1;
80103f17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f1c:	eb f3                	jmp    80103f11 <fetchint+0x2c>
80103f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f23:	eb ec                	jmp    80103f11 <fetchint+0x2c>

80103f25 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103f25:	f3 0f 1e fb          	endbr32 
80103f29:	55                   	push   %ebp
80103f2a:	89 e5                	mov    %esp,%ebp
80103f2c:	53                   	push   %ebx
80103f2d:	83 ec 04             	sub    $0x4,%esp
80103f30:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103f33:	e8 19 f3 ff ff       	call   80103251 <myproc>

  if(addr >= curproc->sz)
80103f38:	39 18                	cmp    %ebx,(%eax)
80103f3a:	76 24                	jbe    80103f60 <fetchstr+0x3b>
    return -1;
  *pp = (char*)addr;
80103f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f3f:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80103f41:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80103f43:	89 d8                	mov    %ebx,%eax
80103f45:	39 d0                	cmp    %edx,%eax
80103f47:	73 0c                	jae    80103f55 <fetchstr+0x30>
    if(*s == 0)
80103f49:	80 38 00             	cmpb   $0x0,(%eax)
80103f4c:	74 03                	je     80103f51 <fetchstr+0x2c>
  for(s = *pp; s < ep; s++){
80103f4e:	40                   	inc    %eax
80103f4f:	eb f4                	jmp    80103f45 <fetchstr+0x20>
      return s - *pp;
80103f51:	29 d8                	sub    %ebx,%eax
80103f53:	eb 05                	jmp    80103f5a <fetchstr+0x35>
  }
  return -1;
80103f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f5a:	83 c4 04             	add    $0x4,%esp
80103f5d:	5b                   	pop    %ebx
80103f5e:	5d                   	pop    %ebp
80103f5f:	c3                   	ret    
    return -1;
80103f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f65:	eb f3                	jmp    80103f5a <fetchstr+0x35>

80103f67 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80103f67:	f3 0f 1e fb          	endbr32 
80103f6b:	55                   	push   %ebp
80103f6c:	89 e5                	mov    %esp,%ebp
80103f6e:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80103f71:	e8 db f2 ff ff       	call   80103251 <myproc>
80103f76:	8b 50 18             	mov    0x18(%eax),%edx
80103f79:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7c:	c1 e0 02             	shl    $0x2,%eax
80103f7f:	03 42 44             	add    0x44(%edx),%eax
80103f82:	83 ec 08             	sub    $0x8,%esp
80103f85:	ff 75 0c             	pushl  0xc(%ebp)
80103f88:	83 c0 04             	add    $0x4,%eax
80103f8b:	50                   	push   %eax
80103f8c:	e8 54 ff ff ff       	call   80103ee5 <fetchint>
}
80103f91:	c9                   	leave  
80103f92:	c3                   	ret    

80103f93 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, void **pp, int size)
{
80103f93:	f3 0f 1e fb          	endbr32 
80103f97:	55                   	push   %ebp
80103f98:	89 e5                	mov    %esp,%ebp
80103f9a:	56                   	push   %esi
80103f9b:	53                   	push   %ebx
80103f9c:	83 ec 10             	sub    $0x10,%esp
80103f9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80103fa2:	e8 aa f2 ff ff       	call   80103251 <myproc>
80103fa7:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80103fa9:	83 ec 08             	sub    $0x8,%esp
80103fac:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103faf:	50                   	push   %eax
80103fb0:	ff 75 08             	pushl  0x8(%ebp)
80103fb3:	e8 af ff ff ff       	call   80103f67 <argint>
80103fb8:	83 c4 10             	add    $0x10,%esp
80103fbb:	85 c0                	test   %eax,%eax
80103fbd:	78 24                	js     80103fe3 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80103fbf:	85 db                	test   %ebx,%ebx
80103fc1:	78 27                	js     80103fea <argptr+0x57>
80103fc3:	8b 16                	mov    (%esi),%edx
80103fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fc8:	39 c2                	cmp    %eax,%edx
80103fca:	76 25                	jbe    80103ff1 <argptr+0x5e>
80103fcc:	01 c3                	add    %eax,%ebx
80103fce:	39 da                	cmp    %ebx,%edx
80103fd0:	72 26                	jb     80103ff8 <argptr+0x65>
    return -1;
  *pp = (void*)i;
80103fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fd5:	89 02                	mov    %eax,(%edx)
  return 0;
80103fd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103fdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fdf:	5b                   	pop    %ebx
80103fe0:	5e                   	pop    %esi
80103fe1:	5d                   	pop    %ebp
80103fe2:	c3                   	ret    
    return -1;
80103fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fe8:	eb f2                	jmp    80103fdc <argptr+0x49>
    return -1;
80103fea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fef:	eb eb                	jmp    80103fdc <argptr+0x49>
80103ff1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ff6:	eb e4                	jmp    80103fdc <argptr+0x49>
80103ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ffd:	eb dd                	jmp    80103fdc <argptr+0x49>

80103fff <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80103fff:	f3 0f 1e fb          	endbr32 
80104003:	55                   	push   %ebp
80104004:	89 e5                	mov    %esp,%ebp
80104006:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104009:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010400c:	50                   	push   %eax
8010400d:	ff 75 08             	pushl  0x8(%ebp)
80104010:	e8 52 ff ff ff       	call   80103f67 <argint>
80104015:	83 c4 10             	add    $0x10,%esp
80104018:	85 c0                	test   %eax,%eax
8010401a:	78 13                	js     8010402f <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010401c:	83 ec 08             	sub    $0x8,%esp
8010401f:	ff 75 0c             	pushl  0xc(%ebp)
80104022:	ff 75 f4             	pushl  -0xc(%ebp)
80104025:	e8 fb fe ff ff       	call   80103f25 <fetchstr>
8010402a:	83 c4 10             	add    $0x10,%esp
}
8010402d:	c9                   	leave  
8010402e:	c3                   	ret    
    return -1;
8010402f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104034:	eb f7                	jmp    8010402d <argstr+0x2e>

80104036 <syscall>:
[SYS_dup2]    sys_dup2,
};

void
syscall(void)
{
80104036:	f3 0f 1e fb          	endbr32 
8010403a:	55                   	push   %ebp
8010403b:	89 e5                	mov    %esp,%ebp
8010403d:	53                   	push   %ebx
8010403e:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104041:	e8 0b f2 ff ff       	call   80103251 <myproc>
80104046:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104048:	8b 40 18             	mov    0x18(%eax),%eax
8010404b:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010404e:	8d 50 ff             	lea    -0x1(%eax),%edx
80104051:	83 fa 16             	cmp    $0x16,%edx
80104054:	77 17                	ja     8010406d <syscall+0x37>
80104056:	8b 14 85 c0 6e 10 80 	mov    -0x7fef9140(,%eax,4),%edx
8010405d:	85 d2                	test   %edx,%edx
8010405f:	74 0c                	je     8010406d <syscall+0x37>
    curproc->tf->eax = syscalls[num]();
80104061:	ff d2                	call   *%edx
80104063:	89 c2                	mov    %eax,%edx
80104065:	8b 43 18             	mov    0x18(%ebx),%eax
80104068:	89 50 1c             	mov    %edx,0x1c(%eax)
8010406b:	eb 1f                	jmp    8010408c <syscall+0x56>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010406d:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104070:	50                   	push   %eax
80104071:	52                   	push   %edx
80104072:	ff 73 10             	pushl  0x10(%ebx)
80104075:	68 9d 6e 10 80       	push   $0x80106e9d
8010407a:	e8 7e c5 ff ff       	call   801005fd <cprintf>
    curproc->tf->eax = -1;
8010407f:	8b 43 18             	mov    0x18(%ebx),%eax
80104082:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104089:	83 c4 10             	add    $0x10,%esp
  }
}
8010408c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010408f:	c9                   	leave  
80104090:	c3                   	ret    

80104091 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104091:	55                   	push   %ebp
80104092:	89 e5                	mov    %esp,%ebp
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 18             	sub    $0x18,%esp
80104099:	89 d6                	mov    %edx,%esi
8010409b:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010409d:	8d 55 f4             	lea    -0xc(%ebp),%edx
801040a0:	52                   	push   %edx
801040a1:	50                   	push   %eax
801040a2:	e8 c0 fe ff ff       	call   80103f67 <argint>
801040a7:	83 c4 10             	add    $0x10,%esp
801040aa:	85 c0                	test   %eax,%eax
801040ac:	78 35                	js     801040e3 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801040ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801040b2:	77 28                	ja     801040dc <argfd+0x4b>
801040b4:	e8 98 f1 ff ff       	call   80103251 <myproc>
801040b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040bc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801040c0:	85 c0                	test   %eax,%eax
801040c2:	74 18                	je     801040dc <argfd+0x4b>
    return -1;
  if(pfd)
801040c4:	85 f6                	test   %esi,%esi
801040c6:	74 02                	je     801040ca <argfd+0x39>
    *pfd = fd;
801040c8:	89 16                	mov    %edx,(%esi)
  if(pf)
801040ca:	85 db                	test   %ebx,%ebx
801040cc:	74 1c                	je     801040ea <argfd+0x59>
    *pf = f;
801040ce:	89 03                	mov    %eax,(%ebx)
  return 0;
801040d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801040d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040d8:	5b                   	pop    %ebx
801040d9:	5e                   	pop    %esi
801040da:	5d                   	pop    %ebp
801040db:	c3                   	ret    
    return -1;
801040dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040e1:	eb f2                	jmp    801040d5 <argfd+0x44>
    return -1;
801040e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040e8:	eb eb                	jmp    801040d5 <argfd+0x44>
  return 0;
801040ea:	b8 00 00 00 00       	mov    $0x0,%eax
801040ef:	eb e4                	jmp    801040d5 <argfd+0x44>

801040f1 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801040f1:	55                   	push   %ebp
801040f2:	89 e5                	mov    %esp,%ebp
801040f4:	53                   	push   %ebx
801040f5:	83 ec 04             	sub    $0x4,%esp
801040f8:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
801040fa:	e8 52 f1 ff ff       	call   80103251 <myproc>
801040ff:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
80104101:	b8 00 00 00 00       	mov    $0x0,%eax
80104106:	83 f8 0f             	cmp    $0xf,%eax
80104109:	7f 10                	jg     8010411b <fdalloc+0x2a>
    if(curproc->ofile[fd] == 0){
8010410b:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
80104110:	74 03                	je     80104115 <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
80104112:	40                   	inc    %eax
80104113:	eb f1                	jmp    80104106 <fdalloc+0x15>
      curproc->ofile[fd] = f;
80104115:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80104119:	eb 05                	jmp    80104120 <fdalloc+0x2f>
    }
  }
  return -1;
8010411b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104120:	83 c4 04             	add    $0x4,%esp
80104123:	5b                   	pop    %ebx
80104124:	5d                   	pop    %ebp
80104125:	c3                   	ret    

80104126 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80104126:	55                   	push   %ebp
80104127:	89 e5                	mov    %esp,%ebp
80104129:	56                   	push   %esi
8010412a:	53                   	push   %ebx
8010412b:	83 ec 10             	sub    $0x10,%esp
8010412e:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104130:	b8 20 00 00 00       	mov    $0x20,%eax
80104135:	89 c6                	mov    %eax,%esi
80104137:	39 43 58             	cmp    %eax,0x58(%ebx)
8010413a:	76 2e                	jbe    8010416a <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010413c:	6a 10                	push   $0x10
8010413e:	50                   	push   %eax
8010413f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104142:	50                   	push   %eax
80104143:	53                   	push   %ebx
80104144:	e8 3e d6 ff ff       	call   80101787 <readi>
80104149:	83 c4 10             	add    $0x10,%esp
8010414c:	83 f8 10             	cmp    $0x10,%eax
8010414f:	75 0c                	jne    8010415d <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104151:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
80104156:	75 1e                	jne    80104176 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104158:	8d 46 10             	lea    0x10(%esi),%eax
8010415b:	eb d8                	jmp    80104135 <isdirempty+0xf>
      panic("isdirempty: readi");
8010415d:	83 ec 0c             	sub    $0xc,%esp
80104160:	68 20 6f 10 80       	push   $0x80106f20
80104165:	e8 eb c1 ff ff       	call   80100355 <panic>
      return 0;
  }
  return 1;
8010416a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010416f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104172:	5b                   	pop    %ebx
80104173:	5e                   	pop    %esi
80104174:	5d                   	pop    %ebp
80104175:	c3                   	ret    
      return 0;
80104176:	b8 00 00 00 00       	mov    $0x0,%eax
8010417b:	eb f2                	jmp    8010416f <isdirempty+0x49>

8010417d <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
8010417d:	55                   	push   %ebp
8010417e:	89 e5                	mov    %esp,%ebp
80104180:	57                   	push   %edi
80104181:	56                   	push   %esi
80104182:	53                   	push   %ebx
80104183:	83 ec 44             	sub    $0x44,%esp
80104186:	89 d7                	mov    %edx,%edi
80104188:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
8010418b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010418e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104191:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104194:	52                   	push   %edx
80104195:	50                   	push   %eax
80104196:	e8 93 da ff ff       	call   80101c2e <nameiparent>
8010419b:	89 c6                	mov    %eax,%esi
8010419d:	83 c4 10             	add    $0x10,%esp
801041a0:	85 c0                	test   %eax,%eax
801041a2:	0f 84 32 01 00 00    	je     801042da <create+0x15d>
    return 0;
  ilock(dp);
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	50                   	push   %eax
801041ac:	e8 d5 d3 ff ff       	call   80101586 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801041b1:	83 c4 0c             	add    $0xc,%esp
801041b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801041b7:	50                   	push   %eax
801041b8:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801041bb:	50                   	push   %eax
801041bc:	56                   	push   %esi
801041bd:	e8 1a d8 ff ff       	call   801019dc <dirlookup>
801041c2:	89 c3                	mov    %eax,%ebx
801041c4:	83 c4 10             	add    $0x10,%esp
801041c7:	85 c0                	test   %eax,%eax
801041c9:	74 3c                	je     80104207 <create+0x8a>
    iunlockput(dp);
801041cb:	83 ec 0c             	sub    $0xc,%esp
801041ce:	56                   	push   %esi
801041cf:	e8 61 d5 ff ff       	call   80101735 <iunlockput>
    ilock(ip);
801041d4:	89 1c 24             	mov    %ebx,(%esp)
801041d7:	e8 aa d3 ff ff       	call   80101586 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801041dc:	83 c4 10             	add    $0x10,%esp
801041df:	66 83 ff 02          	cmp    $0x2,%di
801041e3:	75 07                	jne    801041ec <create+0x6f>
801041e5:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801041ea:	74 11                	je     801041fd <create+0x80>
      return ip;
    iunlockput(ip);
801041ec:	83 ec 0c             	sub    $0xc,%esp
801041ef:	53                   	push   %ebx
801041f0:	e8 40 d5 ff ff       	call   80101735 <iunlockput>
    return 0;
801041f5:	83 c4 10             	add    $0x10,%esp
801041f8:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801041fd:	89 d8                	mov    %ebx,%eax
801041ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104202:	5b                   	pop    %ebx
80104203:	5e                   	pop    %esi
80104204:	5f                   	pop    %edi
80104205:	5d                   	pop    %ebp
80104206:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104207:	83 ec 08             	sub    $0x8,%esp
8010420a:	0f bf c7             	movswl %di,%eax
8010420d:	50                   	push   %eax
8010420e:	ff 36                	pushl  (%esi)
80104210:	e8 6d d1 ff ff       	call   80101382 <ialloc>
80104215:	89 c3                	mov    %eax,%ebx
80104217:	83 c4 10             	add    $0x10,%esp
8010421a:	85 c0                	test   %eax,%eax
8010421c:	74 53                	je     80104271 <create+0xf4>
  ilock(ip);
8010421e:	83 ec 0c             	sub    $0xc,%esp
80104221:	50                   	push   %eax
80104222:	e8 5f d3 ff ff       	call   80101586 <ilock>
  ip->major = major;
80104227:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010422a:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010422e:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104231:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104235:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
8010423b:	89 1c 24             	mov    %ebx,(%esp)
8010423e:	e8 e2 d1 ff ff       	call   80101425 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104243:	83 c4 10             	add    $0x10,%esp
80104246:	66 83 ff 01          	cmp    $0x1,%di
8010424a:	74 32                	je     8010427e <create+0x101>
  if(dirlink(dp, name, ip->inum) < 0)
8010424c:	83 ec 04             	sub    $0x4,%esp
8010424f:	ff 73 04             	pushl  0x4(%ebx)
80104252:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104255:	50                   	push   %eax
80104256:	56                   	push   %esi
80104257:	e8 01 d9 ff ff       	call   80101b5d <dirlink>
8010425c:	83 c4 10             	add    $0x10,%esp
8010425f:	85 c0                	test   %eax,%eax
80104261:	78 6a                	js     801042cd <create+0x150>
  iunlockput(dp);
80104263:	83 ec 0c             	sub    $0xc,%esp
80104266:	56                   	push   %esi
80104267:	e8 c9 d4 ff ff       	call   80101735 <iunlockput>
  return ip;
8010426c:	83 c4 10             	add    $0x10,%esp
8010426f:	eb 8c                	jmp    801041fd <create+0x80>
    panic("create: ialloc");
80104271:	83 ec 0c             	sub    $0xc,%esp
80104274:	68 32 6f 10 80       	push   $0x80106f32
80104279:	e8 d7 c0 ff ff       	call   80100355 <panic>
    dp->nlink++;  // for ".."
8010427e:	66 8b 46 56          	mov    0x56(%esi),%ax
80104282:	40                   	inc    %eax
80104283:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104287:	83 ec 0c             	sub    $0xc,%esp
8010428a:	56                   	push   %esi
8010428b:	e8 95 d1 ff ff       	call   80101425 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104290:	83 c4 0c             	add    $0xc,%esp
80104293:	ff 73 04             	pushl  0x4(%ebx)
80104296:	68 42 6f 10 80       	push   $0x80106f42
8010429b:	53                   	push   %ebx
8010429c:	e8 bc d8 ff ff       	call   80101b5d <dirlink>
801042a1:	83 c4 10             	add    $0x10,%esp
801042a4:	85 c0                	test   %eax,%eax
801042a6:	78 18                	js     801042c0 <create+0x143>
801042a8:	83 ec 04             	sub    $0x4,%esp
801042ab:	ff 76 04             	pushl  0x4(%esi)
801042ae:	68 41 6f 10 80       	push   $0x80106f41
801042b3:	53                   	push   %ebx
801042b4:	e8 a4 d8 ff ff       	call   80101b5d <dirlink>
801042b9:	83 c4 10             	add    $0x10,%esp
801042bc:	85 c0                	test   %eax,%eax
801042be:	79 8c                	jns    8010424c <create+0xcf>
      panic("create dots");
801042c0:	83 ec 0c             	sub    $0xc,%esp
801042c3:	68 44 6f 10 80       	push   $0x80106f44
801042c8:	e8 88 c0 ff ff       	call   80100355 <panic>
    panic("create: dirlink");
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	68 50 6f 10 80       	push   $0x80106f50
801042d5:	e8 7b c0 ff ff       	call   80100355 <panic>
    return 0;
801042da:	89 c3                	mov    %eax,%ebx
801042dc:	e9 1c ff ff ff       	jmp    801041fd <create+0x80>

801042e1 <sys_dup>:
{
801042e1:	f3 0f 1e fb          	endbr32 
801042e5:	55                   	push   %ebp
801042e6:	89 e5                	mov    %esp,%ebp
801042e8:	53                   	push   %ebx
801042e9:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
801042ec:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801042ef:	ba 00 00 00 00       	mov    $0x0,%edx
801042f4:	b8 00 00 00 00       	mov    $0x0,%eax
801042f9:	e8 93 fd ff ff       	call   80104091 <argfd>
801042fe:	85 c0                	test   %eax,%eax
80104300:	78 23                	js     80104325 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
80104302:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104305:	e8 e7 fd ff ff       	call   801040f1 <fdalloc>
8010430a:	89 c3                	mov    %eax,%ebx
8010430c:	85 c0                	test   %eax,%eax
8010430e:	78 1c                	js     8010432c <sys_dup+0x4b>
  filedup(f);
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	ff 75 f4             	pushl  -0xc(%ebp)
80104316:	e8 6b c9 ff ff       	call   80100c86 <filedup>
  return fd;
8010431b:	83 c4 10             	add    $0x10,%esp
}
8010431e:	89 d8                	mov    %ebx,%eax
80104320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104323:	c9                   	leave  
80104324:	c3                   	ret    
    return -1;
80104325:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010432a:	eb f2                	jmp    8010431e <sys_dup+0x3d>
    return -1;
8010432c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104331:	eb eb                	jmp    8010431e <sys_dup+0x3d>

80104333 <sys_dup2>:
sys_dup2(void){
80104333:	f3 0f 1e fb          	endbr32 
80104337:	55                   	push   %ebp
80104338:	89 e5                	mov    %esp,%ebp
8010433a:	53                   	push   %ebx
8010433b:	83 ec 14             	sub    $0x14,%esp
  struct proc *curproc = myproc(); 
8010433e:	e8 0e ef ff ff       	call   80103251 <myproc>
80104343:	89 c3                	mov    %eax,%ebx
  if(argfd(0, &oldfd, &oldf) < 0) // Obtenemos el descriptor de fichero y el fichero (file *) a partir del argumento 0.
80104345:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104348:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010434b:	b8 00 00 00 00       	mov    $0x0,%eax
80104350:	e8 3c fd ff ff       	call   80104091 <argfd>
80104355:	85 c0                	test   %eax,%eax
80104357:	78 5f                	js     801043b8 <sys_dup2+0x85>
  if(argint(1, &newfd)<0) // Obtenemos el nuevo descriptor de fichero a partir del argumento 1.
80104359:	83 ec 08             	sub    $0x8,%esp
8010435c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010435f:	50                   	push   %eax
80104360:	6a 01                	push   $0x1
80104362:	e8 00 fc ff ff       	call   80103f67 <argint>
80104367:	83 c4 10             	add    $0x10,%esp
8010436a:	85 c0                	test   %eax,%eax
8010436c:	78 51                	js     801043bf <sys_dup2+0x8c>
  if(oldfd == newfd) // Si los descriptores de fichero son iguales, no es necesario duplicar.
8010436e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104371:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104374:	39 c2                	cmp    %eax,%edx
80104376:	74 3b                	je     801043b3 <sys_dup2+0x80>
  if(oldfd < 0 || oldfd >= NOFILE || newfd < 0 || newfd >= NOFILE) // Comprobamos que los descriptores de fichero están dentro de los límites válidos.
80104378:	83 fa 0f             	cmp    $0xf,%edx
8010437b:	77 49                	ja     801043c6 <sys_dup2+0x93>
8010437d:	85 c0                	test   %eax,%eax
8010437f:	78 4c                	js     801043cd <sys_dup2+0x9a>
80104381:	83 f8 0f             	cmp    $0xf,%eax
80104384:	7f 4e                	jg     801043d4 <sys_dup2+0xa1>
  newf=curproc->ofile[newfd]; // Obtenemos el fichero (file *) correspondiente al nuevo descriptor.
80104386:	8b 44 83 28          	mov    0x28(%ebx,%eax,4),%eax
  if(newf!=NULL) //Si el nuevo descriptor de fichero está en uso, cierra el fichero.
8010438a:	85 c0                	test   %eax,%eax
8010438c:	74 0c                	je     8010439a <sys_dup2+0x67>
    fileclose(newf);
8010438e:	83 ec 0c             	sub    $0xc,%esp
80104391:	50                   	push   %eax
80104392:	e8 36 c9 ff ff       	call   80100ccd <fileclose>
80104397:	83 c4 10             	add    $0x10,%esp
  curproc->ofile[newfd] = oldf; // Asignamos el fichero del descriptor antiguo al nuevo descriptor.
8010439a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010439d:	8b 55 ec             	mov    -0x14(%ebp),%edx
801043a0:	89 44 93 28          	mov    %eax,0x28(%ebx,%edx,4)
  filedup(oldf); // Incrementa el contador de referencias del fichero.
801043a4:	83 ec 0c             	sub    $0xc,%esp
801043a7:	50                   	push   %eax
801043a8:	e8 d9 c8 ff ff       	call   80100c86 <filedup>
  return newfd;
801043ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043b0:	83 c4 10             	add    $0x10,%esp
}
801043b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b6:	c9                   	leave  
801043b7:	c3                   	ret    
    return -1;
801043b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043bd:	eb f4                	jmp    801043b3 <sys_dup2+0x80>
    return -1;
801043bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043c4:	eb ed                	jmp    801043b3 <sys_dup2+0x80>
    return -1;
801043c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043cb:	eb e6                	jmp    801043b3 <sys_dup2+0x80>
801043cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043d2:	eb df                	jmp    801043b3 <sys_dup2+0x80>
801043d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043d9:	eb d8                	jmp    801043b3 <sys_dup2+0x80>

801043db <sys_read>:
{
801043db:	f3 0f 1e fb          	endbr32 
801043df:	55                   	push   %ebp
801043e0:	89 e5                	mov    %esp,%ebp
801043e2:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
801043e5:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043e8:	ba 00 00 00 00       	mov    $0x0,%edx
801043ed:	b8 00 00 00 00       	mov    $0x0,%eax
801043f2:	e8 9a fc ff ff       	call   80104091 <argfd>
801043f7:	85 c0                	test   %eax,%eax
801043f9:	78 43                	js     8010443e <sys_read+0x63>
801043fb:	83 ec 08             	sub    $0x8,%esp
801043fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104401:	50                   	push   %eax
80104402:	6a 02                	push   $0x2
80104404:	e8 5e fb ff ff       	call   80103f67 <argint>
80104409:	83 c4 10             	add    $0x10,%esp
8010440c:	85 c0                	test   %eax,%eax
8010440e:	78 2e                	js     8010443e <sys_read+0x63>
80104410:	83 ec 04             	sub    $0x4,%esp
80104413:	ff 75 f0             	pushl  -0x10(%ebp)
80104416:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104419:	50                   	push   %eax
8010441a:	6a 01                	push   $0x1
8010441c:	e8 72 fb ff ff       	call   80103f93 <argptr>
80104421:	83 c4 10             	add    $0x10,%esp
80104424:	85 c0                	test   %eax,%eax
80104426:	78 16                	js     8010443e <sys_read+0x63>
  return fileread(f, p, n);
80104428:	83 ec 04             	sub    $0x4,%esp
8010442b:	ff 75 f0             	pushl  -0x10(%ebp)
8010442e:	ff 75 ec             	pushl  -0x14(%ebp)
80104431:	ff 75 f4             	pushl  -0xc(%ebp)
80104434:	e8 95 c9 ff ff       	call   80100dce <fileread>
80104439:	83 c4 10             	add    $0x10,%esp
}
8010443c:	c9                   	leave  
8010443d:	c3                   	ret    
    return -1;
8010443e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104443:	eb f7                	jmp    8010443c <sys_read+0x61>

80104445 <sys_write>:
{
80104445:	f3 0f 1e fb          	endbr32 
80104449:	55                   	push   %ebp
8010444a:	89 e5                	mov    %esp,%ebp
8010444c:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
8010444f:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104452:	ba 00 00 00 00       	mov    $0x0,%edx
80104457:	b8 00 00 00 00       	mov    $0x0,%eax
8010445c:	e8 30 fc ff ff       	call   80104091 <argfd>
80104461:	85 c0                	test   %eax,%eax
80104463:	78 43                	js     801044a8 <sys_write+0x63>
80104465:	83 ec 08             	sub    $0x8,%esp
80104468:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010446b:	50                   	push   %eax
8010446c:	6a 02                	push   $0x2
8010446e:	e8 f4 fa ff ff       	call   80103f67 <argint>
80104473:	83 c4 10             	add    $0x10,%esp
80104476:	85 c0                	test   %eax,%eax
80104478:	78 2e                	js     801044a8 <sys_write+0x63>
8010447a:	83 ec 04             	sub    $0x4,%esp
8010447d:	ff 75 f0             	pushl  -0x10(%ebp)
80104480:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104483:	50                   	push   %eax
80104484:	6a 01                	push   $0x1
80104486:	e8 08 fb ff ff       	call   80103f93 <argptr>
8010448b:	83 c4 10             	add    $0x10,%esp
8010448e:	85 c0                	test   %eax,%eax
80104490:	78 16                	js     801044a8 <sys_write+0x63>
  return filewrite(f, p, n);
80104492:	83 ec 04             	sub    $0x4,%esp
80104495:	ff 75 f0             	pushl  -0x10(%ebp)
80104498:	ff 75 ec             	pushl  -0x14(%ebp)
8010449b:	ff 75 f4             	pushl  -0xc(%ebp)
8010449e:	e8 b4 c9 ff ff       	call   80100e57 <filewrite>
801044a3:	83 c4 10             	add    $0x10,%esp
}
801044a6:	c9                   	leave  
801044a7:	c3                   	ret    
    return -1;
801044a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044ad:	eb f7                	jmp    801044a6 <sys_write+0x61>

801044af <sys_close>:
{
801044af:	f3 0f 1e fb          	endbr32 
801044b3:	55                   	push   %ebp
801044b4:	89 e5                	mov    %esp,%ebp
801044b6:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801044b9:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801044bc:	8d 55 f4             	lea    -0xc(%ebp),%edx
801044bf:	b8 00 00 00 00       	mov    $0x0,%eax
801044c4:	e8 c8 fb ff ff       	call   80104091 <argfd>
801044c9:	85 c0                	test   %eax,%eax
801044cb:	78 25                	js     801044f2 <sys_close+0x43>
  myproc()->ofile[fd] = 0;
801044cd:	e8 7f ed ff ff       	call   80103251 <myproc>
801044d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044d5:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801044dc:	00 
  fileclose(f);
801044dd:	83 ec 0c             	sub    $0xc,%esp
801044e0:	ff 75 f0             	pushl  -0x10(%ebp)
801044e3:	e8 e5 c7 ff ff       	call   80100ccd <fileclose>
  return 0;
801044e8:	83 c4 10             	add    $0x10,%esp
801044eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044f0:	c9                   	leave  
801044f1:	c3                   	ret    
    return -1;
801044f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044f7:	eb f7                	jmp    801044f0 <sys_close+0x41>

801044f9 <sys_fstat>:
{
801044f9:	f3 0f 1e fb          	endbr32 
801044fd:	55                   	push   %ebp
801044fe:	89 e5                	mov    %esp,%ebp
80104500:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104503:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104506:	ba 00 00 00 00       	mov    $0x0,%edx
8010450b:	b8 00 00 00 00       	mov    $0x0,%eax
80104510:	e8 7c fb ff ff       	call   80104091 <argfd>
80104515:	85 c0                	test   %eax,%eax
80104517:	78 2a                	js     80104543 <sys_fstat+0x4a>
80104519:	83 ec 04             	sub    $0x4,%esp
8010451c:	6a 14                	push   $0x14
8010451e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104521:	50                   	push   %eax
80104522:	6a 01                	push   $0x1
80104524:	e8 6a fa ff ff       	call   80103f93 <argptr>
80104529:	83 c4 10             	add    $0x10,%esp
8010452c:	85 c0                	test   %eax,%eax
8010452e:	78 13                	js     80104543 <sys_fstat+0x4a>
  return filestat(f, st);
80104530:	83 ec 08             	sub    $0x8,%esp
80104533:	ff 75 f0             	pushl  -0x10(%ebp)
80104536:	ff 75 f4             	pushl  -0xc(%ebp)
80104539:	e8 45 c8 ff ff       	call   80100d83 <filestat>
8010453e:	83 c4 10             	add    $0x10,%esp
}
80104541:	c9                   	leave  
80104542:	c3                   	ret    
    return -1;
80104543:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104548:	eb f7                	jmp    80104541 <sys_fstat+0x48>

8010454a <sys_link>:
{
8010454a:	f3 0f 1e fb          	endbr32 
8010454e:	55                   	push   %ebp
8010454f:	89 e5                	mov    %esp,%ebp
80104551:	56                   	push   %esi
80104552:	53                   	push   %ebx
80104553:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104556:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104559:	50                   	push   %eax
8010455a:	6a 00                	push   $0x0
8010455c:	e8 9e fa ff ff       	call   80103fff <argstr>
80104561:	83 c4 10             	add    $0x10,%esp
80104564:	85 c0                	test   %eax,%eax
80104566:	0f 88 d1 00 00 00    	js     8010463d <sys_link+0xf3>
8010456c:	83 ec 08             	sub    $0x8,%esp
8010456f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104572:	50                   	push   %eax
80104573:	6a 01                	push   $0x1
80104575:	e8 85 fa ff ff       	call   80103fff <argstr>
8010457a:	83 c4 10             	add    $0x10,%esp
8010457d:	85 c0                	test   %eax,%eax
8010457f:	0f 88 b8 00 00 00    	js     8010463d <sys_link+0xf3>
  begin_op();
80104585:	e8 49 e2 ff ff       	call   801027d3 <begin_op>
  if((ip = namei(old)) == 0){
8010458a:	83 ec 0c             	sub    $0xc,%esp
8010458d:	ff 75 e0             	pushl  -0x20(%ebp)
80104590:	e8 7d d6 ff ff       	call   80101c12 <namei>
80104595:	89 c3                	mov    %eax,%ebx
80104597:	83 c4 10             	add    $0x10,%esp
8010459a:	85 c0                	test   %eax,%eax
8010459c:	0f 84 a2 00 00 00    	je     80104644 <sys_link+0xfa>
  ilock(ip);
801045a2:	83 ec 0c             	sub    $0xc,%esp
801045a5:	50                   	push   %eax
801045a6:	e8 db cf ff ff       	call   80101586 <ilock>
  if(ip->type == T_DIR){
801045ab:	83 c4 10             	add    $0x10,%esp
801045ae:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801045b3:	0f 84 97 00 00 00    	je     80104650 <sys_link+0x106>
  ip->nlink++;
801045b9:	66 8b 43 56          	mov    0x56(%ebx),%ax
801045bd:	40                   	inc    %eax
801045be:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801045c2:	83 ec 0c             	sub    $0xc,%esp
801045c5:	53                   	push   %ebx
801045c6:	e8 5a ce ff ff       	call   80101425 <iupdate>
  iunlock(ip);
801045cb:	89 1c 24             	mov    %ebx,(%esp)
801045ce:	e8 77 d0 ff ff       	call   8010164a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801045d3:	83 c4 08             	add    $0x8,%esp
801045d6:	8d 45 ea             	lea    -0x16(%ebp),%eax
801045d9:	50                   	push   %eax
801045da:	ff 75 e4             	pushl  -0x1c(%ebp)
801045dd:	e8 4c d6 ff ff       	call   80101c2e <nameiparent>
801045e2:	89 c6                	mov    %eax,%esi
801045e4:	83 c4 10             	add    $0x10,%esp
801045e7:	85 c0                	test   %eax,%eax
801045e9:	0f 84 85 00 00 00    	je     80104674 <sys_link+0x12a>
  ilock(dp);
801045ef:	83 ec 0c             	sub    $0xc,%esp
801045f2:	50                   	push   %eax
801045f3:	e8 8e cf ff ff       	call   80101586 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801045f8:	83 c4 10             	add    $0x10,%esp
801045fb:	8b 03                	mov    (%ebx),%eax
801045fd:	39 06                	cmp    %eax,(%esi)
801045ff:	75 67                	jne    80104668 <sys_link+0x11e>
80104601:	83 ec 04             	sub    $0x4,%esp
80104604:	ff 73 04             	pushl  0x4(%ebx)
80104607:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010460a:	50                   	push   %eax
8010460b:	56                   	push   %esi
8010460c:	e8 4c d5 ff ff       	call   80101b5d <dirlink>
80104611:	83 c4 10             	add    $0x10,%esp
80104614:	85 c0                	test   %eax,%eax
80104616:	78 50                	js     80104668 <sys_link+0x11e>
  iunlockput(dp);
80104618:	83 ec 0c             	sub    $0xc,%esp
8010461b:	56                   	push   %esi
8010461c:	e8 14 d1 ff ff       	call   80101735 <iunlockput>
  iput(ip);
80104621:	89 1c 24             	mov    %ebx,(%esp)
80104624:	e8 6a d0 ff ff       	call   80101693 <iput>
  end_op();
80104629:	e8 25 e2 ff ff       	call   80102853 <end_op>
  return 0;
8010462e:	83 c4 10             	add    $0x10,%esp
80104631:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104636:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104639:	5b                   	pop    %ebx
8010463a:	5e                   	pop    %esi
8010463b:	5d                   	pop    %ebp
8010463c:	c3                   	ret    
    return -1;
8010463d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104642:	eb f2                	jmp    80104636 <sys_link+0xec>
    end_op();
80104644:	e8 0a e2 ff ff       	call   80102853 <end_op>
    return -1;
80104649:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010464e:	eb e6                	jmp    80104636 <sys_link+0xec>
    iunlockput(ip);
80104650:	83 ec 0c             	sub    $0xc,%esp
80104653:	53                   	push   %ebx
80104654:	e8 dc d0 ff ff       	call   80101735 <iunlockput>
    end_op();
80104659:	e8 f5 e1 ff ff       	call   80102853 <end_op>
    return -1;
8010465e:	83 c4 10             	add    $0x10,%esp
80104661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104666:	eb ce                	jmp    80104636 <sys_link+0xec>
    iunlockput(dp);
80104668:	83 ec 0c             	sub    $0xc,%esp
8010466b:	56                   	push   %esi
8010466c:	e8 c4 d0 ff ff       	call   80101735 <iunlockput>
    goto bad;
80104671:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104674:	83 ec 0c             	sub    $0xc,%esp
80104677:	53                   	push   %ebx
80104678:	e8 09 cf ff ff       	call   80101586 <ilock>
  ip->nlink--;
8010467d:	66 8b 43 56          	mov    0x56(%ebx),%ax
80104681:	48                   	dec    %eax
80104682:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104686:	89 1c 24             	mov    %ebx,(%esp)
80104689:	e8 97 cd ff ff       	call   80101425 <iupdate>
  iunlockput(ip);
8010468e:	89 1c 24             	mov    %ebx,(%esp)
80104691:	e8 9f d0 ff ff       	call   80101735 <iunlockput>
  end_op();
80104696:	e8 b8 e1 ff ff       	call   80102853 <end_op>
  return -1;
8010469b:	83 c4 10             	add    $0x10,%esp
8010469e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a3:	eb 91                	jmp    80104636 <sys_link+0xec>

801046a5 <sys_unlink>:
{
801046a5:	f3 0f 1e fb          	endbr32 
801046a9:	55                   	push   %ebp
801046aa:	89 e5                	mov    %esp,%ebp
801046ac:	57                   	push   %edi
801046ad:	56                   	push   %esi
801046ae:	53                   	push   %ebx
801046af:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801046b2:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801046b5:	50                   	push   %eax
801046b6:	6a 00                	push   $0x0
801046b8:	e8 42 f9 ff ff       	call   80103fff <argstr>
801046bd:	83 c4 10             	add    $0x10,%esp
801046c0:	85 c0                	test   %eax,%eax
801046c2:	0f 88 7f 01 00 00    	js     80104847 <sys_unlink+0x1a2>
  begin_op();
801046c8:	e8 06 e1 ff ff       	call   801027d3 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801046cd:	83 ec 08             	sub    $0x8,%esp
801046d0:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046d3:	50                   	push   %eax
801046d4:	ff 75 c4             	pushl  -0x3c(%ebp)
801046d7:	e8 52 d5 ff ff       	call   80101c2e <nameiparent>
801046dc:	89 c6                	mov    %eax,%esi
801046de:	83 c4 10             	add    $0x10,%esp
801046e1:	85 c0                	test   %eax,%eax
801046e3:	0f 84 eb 00 00 00    	je     801047d4 <sys_unlink+0x12f>
  ilock(dp);
801046e9:	83 ec 0c             	sub    $0xc,%esp
801046ec:	50                   	push   %eax
801046ed:	e8 94 ce ff ff       	call   80101586 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801046f2:	83 c4 08             	add    $0x8,%esp
801046f5:	68 42 6f 10 80       	push   $0x80106f42
801046fa:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046fd:	50                   	push   %eax
801046fe:	e8 c0 d2 ff ff       	call   801019c3 <namecmp>
80104703:	83 c4 10             	add    $0x10,%esp
80104706:	85 c0                	test   %eax,%eax
80104708:	0f 84 fa 00 00 00    	je     80104808 <sys_unlink+0x163>
8010470e:	83 ec 08             	sub    $0x8,%esp
80104711:	68 41 6f 10 80       	push   $0x80106f41
80104716:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104719:	50                   	push   %eax
8010471a:	e8 a4 d2 ff ff       	call   801019c3 <namecmp>
8010471f:	83 c4 10             	add    $0x10,%esp
80104722:	85 c0                	test   %eax,%eax
80104724:	0f 84 de 00 00 00    	je     80104808 <sys_unlink+0x163>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010472a:	83 ec 04             	sub    $0x4,%esp
8010472d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104730:	50                   	push   %eax
80104731:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104734:	50                   	push   %eax
80104735:	56                   	push   %esi
80104736:	e8 a1 d2 ff ff       	call   801019dc <dirlookup>
8010473b:	89 c3                	mov    %eax,%ebx
8010473d:	83 c4 10             	add    $0x10,%esp
80104740:	85 c0                	test   %eax,%eax
80104742:	0f 84 c0 00 00 00    	je     80104808 <sys_unlink+0x163>
  ilock(ip);
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	50                   	push   %eax
8010474c:	e8 35 ce ff ff       	call   80101586 <ilock>
  if(ip->nlink < 1)
80104751:	83 c4 10             	add    $0x10,%esp
80104754:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104759:	0f 8e 81 00 00 00    	jle    801047e0 <sys_unlink+0x13b>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010475f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104764:	0f 84 83 00 00 00    	je     801047ed <sys_unlink+0x148>
  memset(&de, 0, sizeof(de));
8010476a:	83 ec 04             	sub    $0x4,%esp
8010476d:	6a 10                	push   $0x10
8010476f:	6a 00                	push   $0x0
80104771:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104774:	57                   	push   %edi
80104775:	e8 94 f5 ff ff       	call   80103d0e <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010477a:	6a 10                	push   $0x10
8010477c:	ff 75 c0             	pushl  -0x40(%ebp)
8010477f:	57                   	push   %edi
80104780:	56                   	push   %esi
80104781:	e8 05 d1 ff ff       	call   8010188b <writei>
80104786:	83 c4 20             	add    $0x20,%esp
80104789:	83 f8 10             	cmp    $0x10,%eax
8010478c:	0f 85 8e 00 00 00    	jne    80104820 <sys_unlink+0x17b>
  if(ip->type == T_DIR){
80104792:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104797:	0f 84 90 00 00 00    	je     8010482d <sys_unlink+0x188>
  iunlockput(dp);
8010479d:	83 ec 0c             	sub    $0xc,%esp
801047a0:	56                   	push   %esi
801047a1:	e8 8f cf ff ff       	call   80101735 <iunlockput>
  ip->nlink--;
801047a6:	66 8b 43 56          	mov    0x56(%ebx),%ax
801047aa:	48                   	dec    %eax
801047ab:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801047af:	89 1c 24             	mov    %ebx,(%esp)
801047b2:	e8 6e cc ff ff       	call   80101425 <iupdate>
  iunlockput(ip);
801047b7:	89 1c 24             	mov    %ebx,(%esp)
801047ba:	e8 76 cf ff ff       	call   80101735 <iunlockput>
  end_op();
801047bf:	e8 8f e0 ff ff       	call   80102853 <end_op>
  return 0;
801047c4:	83 c4 10             	add    $0x10,%esp
801047c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047cf:	5b                   	pop    %ebx
801047d0:	5e                   	pop    %esi
801047d1:	5f                   	pop    %edi
801047d2:	5d                   	pop    %ebp
801047d3:	c3                   	ret    
    end_op();
801047d4:	e8 7a e0 ff ff       	call   80102853 <end_op>
    return -1;
801047d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047de:	eb ec                	jmp    801047cc <sys_unlink+0x127>
    panic("unlink: nlink < 1");
801047e0:	83 ec 0c             	sub    $0xc,%esp
801047e3:	68 60 6f 10 80       	push   $0x80106f60
801047e8:	e8 68 bb ff ff       	call   80100355 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801047ed:	89 d8                	mov    %ebx,%eax
801047ef:	e8 32 f9 ff ff       	call   80104126 <isdirempty>
801047f4:	85 c0                	test   %eax,%eax
801047f6:	0f 85 6e ff ff ff    	jne    8010476a <sys_unlink+0xc5>
    iunlockput(ip);
801047fc:	83 ec 0c             	sub    $0xc,%esp
801047ff:	53                   	push   %ebx
80104800:	e8 30 cf ff ff       	call   80101735 <iunlockput>
    goto bad;
80104805:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	56                   	push   %esi
8010480c:	e8 24 cf ff ff       	call   80101735 <iunlockput>
  end_op();
80104811:	e8 3d e0 ff ff       	call   80102853 <end_op>
  return -1;
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010481e:	eb ac                	jmp    801047cc <sys_unlink+0x127>
    panic("unlink: writei");
80104820:	83 ec 0c             	sub    $0xc,%esp
80104823:	68 72 6f 10 80       	push   $0x80106f72
80104828:	e8 28 bb ff ff       	call   80100355 <panic>
    dp->nlink--;
8010482d:	66 8b 46 56          	mov    0x56(%esi),%ax
80104831:	48                   	dec    %eax
80104832:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104836:	83 ec 0c             	sub    $0xc,%esp
80104839:	56                   	push   %esi
8010483a:	e8 e6 cb ff ff       	call   80101425 <iupdate>
8010483f:	83 c4 10             	add    $0x10,%esp
80104842:	e9 56 ff ff ff       	jmp    8010479d <sys_unlink+0xf8>
    return -1;
80104847:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010484c:	e9 7b ff ff ff       	jmp    801047cc <sys_unlink+0x127>

80104851 <sys_open>:

int
sys_open(void)
{
80104851:	f3 0f 1e fb          	endbr32 
80104855:	55                   	push   %ebp
80104856:	89 e5                	mov    %esp,%ebp
80104858:	57                   	push   %edi
80104859:	56                   	push   %esi
8010485a:	53                   	push   %ebx
8010485b:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010485e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104861:	50                   	push   %eax
80104862:	6a 00                	push   $0x0
80104864:	e8 96 f7 ff ff       	call   80103fff <argstr>
80104869:	83 c4 10             	add    $0x10,%esp
8010486c:	85 c0                	test   %eax,%eax
8010486e:	0f 88 a0 00 00 00    	js     80104914 <sys_open+0xc3>
80104874:	83 ec 08             	sub    $0x8,%esp
80104877:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010487a:	50                   	push   %eax
8010487b:	6a 01                	push   $0x1
8010487d:	e8 e5 f6 ff ff       	call   80103f67 <argint>
80104882:	83 c4 10             	add    $0x10,%esp
80104885:	85 c0                	test   %eax,%eax
80104887:	0f 88 87 00 00 00    	js     80104914 <sys_open+0xc3>
    return -1;

  begin_op();
8010488d:	e8 41 df ff ff       	call   801027d3 <begin_op>

  if(omode & O_CREATE){
80104892:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104896:	0f 84 8b 00 00 00    	je     80104927 <sys_open+0xd6>
    ip = create(path, T_FILE, 0, 0);
8010489c:	83 ec 0c             	sub    $0xc,%esp
8010489f:	6a 00                	push   $0x0
801048a1:	b9 00 00 00 00       	mov    $0x0,%ecx
801048a6:	ba 02 00 00 00       	mov    $0x2,%edx
801048ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048ae:	e8 ca f8 ff ff       	call   8010417d <create>
801048b3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801048b5:	83 c4 10             	add    $0x10,%esp
801048b8:	85 c0                	test   %eax,%eax
801048ba:	74 5f                	je     8010491b <sys_open+0xca>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801048bc:	e8 60 c3 ff ff       	call   80100c21 <filealloc>
801048c1:	89 c3                	mov    %eax,%ebx
801048c3:	85 c0                	test   %eax,%eax
801048c5:	0f 84 b5 00 00 00    	je     80104980 <sys_open+0x12f>
801048cb:	e8 21 f8 ff ff       	call   801040f1 <fdalloc>
801048d0:	89 c7                	mov    %eax,%edi
801048d2:	85 c0                	test   %eax,%eax
801048d4:	0f 88 a6 00 00 00    	js     80104980 <sys_open+0x12f>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801048da:	83 ec 0c             	sub    $0xc,%esp
801048dd:	56                   	push   %esi
801048de:	e8 67 cd ff ff       	call   8010164a <iunlock>
  end_op();
801048e3:	e8 6b df ff ff       	call   80102853 <end_op>

  f->type = FD_INODE;
801048e8:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
801048ee:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
801048f1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
801048f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048fb:	83 c4 10             	add    $0x10,%esp
801048fe:	a8 01                	test   $0x1,%al
80104900:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104904:	a8 03                	test   $0x3,%al
80104906:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
8010490a:	89 f8                	mov    %edi,%eax
8010490c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010490f:	5b                   	pop    %ebx
80104910:	5e                   	pop    %esi
80104911:	5f                   	pop    %edi
80104912:	5d                   	pop    %ebp
80104913:	c3                   	ret    
    return -1;
80104914:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104919:	eb ef                	jmp    8010490a <sys_open+0xb9>
      end_op();
8010491b:	e8 33 df ff ff       	call   80102853 <end_op>
      return -1;
80104920:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104925:	eb e3                	jmp    8010490a <sys_open+0xb9>
    if((ip = namei(path)) == 0){
80104927:	83 ec 0c             	sub    $0xc,%esp
8010492a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010492d:	e8 e0 d2 ff ff       	call   80101c12 <namei>
80104932:	89 c6                	mov    %eax,%esi
80104934:	83 c4 10             	add    $0x10,%esp
80104937:	85 c0                	test   %eax,%eax
80104939:	74 39                	je     80104974 <sys_open+0x123>
    ilock(ip);
8010493b:	83 ec 0c             	sub    $0xc,%esp
8010493e:	50                   	push   %eax
8010493f:	e8 42 cc ff ff       	call   80101586 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104944:	83 c4 10             	add    $0x10,%esp
80104947:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
8010494c:	0f 85 6a ff ff ff    	jne    801048bc <sys_open+0x6b>
80104952:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104956:	0f 84 60 ff ff ff    	je     801048bc <sys_open+0x6b>
      iunlockput(ip);
8010495c:	83 ec 0c             	sub    $0xc,%esp
8010495f:	56                   	push   %esi
80104960:	e8 d0 cd ff ff       	call   80101735 <iunlockput>
      end_op();
80104965:	e8 e9 de ff ff       	call   80102853 <end_op>
      return -1;
8010496a:	83 c4 10             	add    $0x10,%esp
8010496d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104972:	eb 96                	jmp    8010490a <sys_open+0xb9>
      end_op();
80104974:	e8 da de ff ff       	call   80102853 <end_op>
      return -1;
80104979:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010497e:	eb 8a                	jmp    8010490a <sys_open+0xb9>
    if(f)
80104980:	85 db                	test   %ebx,%ebx
80104982:	74 0c                	je     80104990 <sys_open+0x13f>
      fileclose(f);
80104984:	83 ec 0c             	sub    $0xc,%esp
80104987:	53                   	push   %ebx
80104988:	e8 40 c3 ff ff       	call   80100ccd <fileclose>
8010498d:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104990:	83 ec 0c             	sub    $0xc,%esp
80104993:	56                   	push   %esi
80104994:	e8 9c cd ff ff       	call   80101735 <iunlockput>
    end_op();
80104999:	e8 b5 de ff ff       	call   80102853 <end_op>
    return -1;
8010499e:	83 c4 10             	add    $0x10,%esp
801049a1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049a6:	e9 5f ff ff ff       	jmp    8010490a <sys_open+0xb9>

801049ab <sys_mkdir>:

int
sys_mkdir(void)
{
801049ab:	f3 0f 1e fb          	endbr32 
801049af:	55                   	push   %ebp
801049b0:	89 e5                	mov    %esp,%ebp
801049b2:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801049b5:	e8 19 de ff ff       	call   801027d3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801049ba:	83 ec 08             	sub    $0x8,%esp
801049bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049c0:	50                   	push   %eax
801049c1:	6a 00                	push   $0x0
801049c3:	e8 37 f6 ff ff       	call   80103fff <argstr>
801049c8:	83 c4 10             	add    $0x10,%esp
801049cb:	85 c0                	test   %eax,%eax
801049cd:	78 36                	js     80104a05 <sys_mkdir+0x5a>
801049cf:	83 ec 0c             	sub    $0xc,%esp
801049d2:	6a 00                	push   $0x0
801049d4:	b9 00 00 00 00       	mov    $0x0,%ecx
801049d9:	ba 01 00 00 00       	mov    $0x1,%edx
801049de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e1:	e8 97 f7 ff ff       	call   8010417d <create>
801049e6:	83 c4 10             	add    $0x10,%esp
801049e9:	85 c0                	test   %eax,%eax
801049eb:	74 18                	je     80104a05 <sys_mkdir+0x5a>
    end_op();
    return -1;
  }
  iunlockput(ip);
801049ed:	83 ec 0c             	sub    $0xc,%esp
801049f0:	50                   	push   %eax
801049f1:	e8 3f cd ff ff       	call   80101735 <iunlockput>
  end_op();
801049f6:	e8 58 de ff ff       	call   80102853 <end_op>
  return 0;
801049fb:	83 c4 10             	add    $0x10,%esp
801049fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a03:	c9                   	leave  
80104a04:	c3                   	ret    
    end_op();
80104a05:	e8 49 de ff ff       	call   80102853 <end_op>
    return -1;
80104a0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a0f:	eb f2                	jmp    80104a03 <sys_mkdir+0x58>

80104a11 <sys_mknod>:

int
sys_mknod(void)
{
80104a11:	f3 0f 1e fb          	endbr32 
80104a15:	55                   	push   %ebp
80104a16:	89 e5                	mov    %esp,%ebp
80104a18:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104a1b:	e8 b3 dd ff ff       	call   801027d3 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104a20:	83 ec 08             	sub    $0x8,%esp
80104a23:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a26:	50                   	push   %eax
80104a27:	6a 00                	push   $0x0
80104a29:	e8 d1 f5 ff ff       	call   80103fff <argstr>
80104a2e:	83 c4 10             	add    $0x10,%esp
80104a31:	85 c0                	test   %eax,%eax
80104a33:	78 62                	js     80104a97 <sys_mknod+0x86>
     argint(1, &major) < 0 ||
80104a35:	83 ec 08             	sub    $0x8,%esp
80104a38:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a3b:	50                   	push   %eax
80104a3c:	6a 01                	push   $0x1
80104a3e:	e8 24 f5 ff ff       	call   80103f67 <argint>
  if((argstr(0, &path)) < 0 ||
80104a43:	83 c4 10             	add    $0x10,%esp
80104a46:	85 c0                	test   %eax,%eax
80104a48:	78 4d                	js     80104a97 <sys_mknod+0x86>
     argint(2, &minor) < 0 ||
80104a4a:	83 ec 08             	sub    $0x8,%esp
80104a4d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104a50:	50                   	push   %eax
80104a51:	6a 02                	push   $0x2
80104a53:	e8 0f f5 ff ff       	call   80103f67 <argint>
     argint(1, &major) < 0 ||
80104a58:	83 c4 10             	add    $0x10,%esp
80104a5b:	85 c0                	test   %eax,%eax
80104a5d:	78 38                	js     80104a97 <sys_mknod+0x86>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104a5f:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104a63:	83 ec 0c             	sub    $0xc,%esp
80104a66:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104a6a:	50                   	push   %eax
80104a6b:	ba 03 00 00 00       	mov    $0x3,%edx
80104a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a73:	e8 05 f7 ff ff       	call   8010417d <create>
     argint(2, &minor) < 0 ||
80104a78:	83 c4 10             	add    $0x10,%esp
80104a7b:	85 c0                	test   %eax,%eax
80104a7d:	74 18                	je     80104a97 <sys_mknod+0x86>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a7f:	83 ec 0c             	sub    $0xc,%esp
80104a82:	50                   	push   %eax
80104a83:	e8 ad cc ff ff       	call   80101735 <iunlockput>
  end_op();
80104a88:	e8 c6 dd ff ff       	call   80102853 <end_op>
  return 0;
80104a8d:	83 c4 10             	add    $0x10,%esp
80104a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a95:	c9                   	leave  
80104a96:	c3                   	ret    
    end_op();
80104a97:	e8 b7 dd ff ff       	call   80102853 <end_op>
    return -1;
80104a9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa1:	eb f2                	jmp    80104a95 <sys_mknod+0x84>

80104aa3 <sys_chdir>:

int
sys_chdir(void)
{
80104aa3:	f3 0f 1e fb          	endbr32 
80104aa7:	55                   	push   %ebp
80104aa8:	89 e5                	mov    %esp,%ebp
80104aaa:	56                   	push   %esi
80104aab:	53                   	push   %ebx
80104aac:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104aaf:	e8 9d e7 ff ff       	call   80103251 <myproc>
80104ab4:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104ab6:	e8 18 dd ff ff       	call   801027d3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104abb:	83 ec 08             	sub    $0x8,%esp
80104abe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ac1:	50                   	push   %eax
80104ac2:	6a 00                	push   $0x0
80104ac4:	e8 36 f5 ff ff       	call   80103fff <argstr>
80104ac9:	83 c4 10             	add    $0x10,%esp
80104acc:	85 c0                	test   %eax,%eax
80104ace:	78 52                	js     80104b22 <sys_chdir+0x7f>
80104ad0:	83 ec 0c             	sub    $0xc,%esp
80104ad3:	ff 75 f4             	pushl  -0xc(%ebp)
80104ad6:	e8 37 d1 ff ff       	call   80101c12 <namei>
80104adb:	89 c3                	mov    %eax,%ebx
80104add:	83 c4 10             	add    $0x10,%esp
80104ae0:	85 c0                	test   %eax,%eax
80104ae2:	74 3e                	je     80104b22 <sys_chdir+0x7f>
    end_op();
    return -1;
  }
  ilock(ip);
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	50                   	push   %eax
80104ae8:	e8 99 ca ff ff       	call   80101586 <ilock>
  if(ip->type != T_DIR){
80104aed:	83 c4 10             	add    $0x10,%esp
80104af0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104af5:	75 37                	jne    80104b2e <sys_chdir+0x8b>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104af7:	83 ec 0c             	sub    $0xc,%esp
80104afa:	53                   	push   %ebx
80104afb:	e8 4a cb ff ff       	call   8010164a <iunlock>
  iput(curproc->cwd);
80104b00:	83 c4 04             	add    $0x4,%esp
80104b03:	ff 76 68             	pushl  0x68(%esi)
80104b06:	e8 88 cb ff ff       	call   80101693 <iput>
  end_op();
80104b0b:	e8 43 dd ff ff       	call   80102853 <end_op>
  curproc->cwd = ip;
80104b10:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104b13:	83 c4 10             	add    $0x10,%esp
80104b16:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b1e:	5b                   	pop    %ebx
80104b1f:	5e                   	pop    %esi
80104b20:	5d                   	pop    %ebp
80104b21:	c3                   	ret    
    end_op();
80104b22:	e8 2c dd ff ff       	call   80102853 <end_op>
    return -1;
80104b27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b2c:	eb ed                	jmp    80104b1b <sys_chdir+0x78>
    iunlockput(ip);
80104b2e:	83 ec 0c             	sub    $0xc,%esp
80104b31:	53                   	push   %ebx
80104b32:	e8 fe cb ff ff       	call   80101735 <iunlockput>
    end_op();
80104b37:	e8 17 dd ff ff       	call   80102853 <end_op>
    return -1;
80104b3c:	83 c4 10             	add    $0x10,%esp
80104b3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b44:	eb d5                	jmp    80104b1b <sys_chdir+0x78>

80104b46 <sys_exec>:

int
sys_exec(void)
{
80104b46:	f3 0f 1e fb          	endbr32 
80104b4a:	55                   	push   %ebp
80104b4b:	89 e5                	mov    %esp,%ebp
80104b4d:	53                   	push   %ebx
80104b4e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104b54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b57:	50                   	push   %eax
80104b58:	6a 00                	push   $0x0
80104b5a:	e8 a0 f4 ff ff       	call   80103fff <argstr>
80104b5f:	83 c4 10             	add    $0x10,%esp
80104b62:	85 c0                	test   %eax,%eax
80104b64:	78 38                	js     80104b9e <sys_exec+0x58>
80104b66:	83 ec 08             	sub    $0x8,%esp
80104b69:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104b6f:	50                   	push   %eax
80104b70:	6a 01                	push   $0x1
80104b72:	e8 f0 f3 ff ff       	call   80103f67 <argint>
80104b77:	83 c4 10             	add    $0x10,%esp
80104b7a:	85 c0                	test   %eax,%eax
80104b7c:	78 20                	js     80104b9e <sys_exec+0x58>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104b7e:	83 ec 04             	sub    $0x4,%esp
80104b81:	68 80 00 00 00       	push   $0x80
80104b86:	6a 00                	push   $0x0
80104b88:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b8e:	50                   	push   %eax
80104b8f:	e8 7a f1 ff ff       	call   80103d0e <memset>
80104b94:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104b97:	bb 00 00 00 00       	mov    $0x0,%ebx
80104b9c:	eb 2a                	jmp    80104bc8 <sys_exec+0x82>
    return -1;
80104b9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba3:	eb 76                	jmp    80104c1b <sys_exec+0xd5>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104ba5:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104bac:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104bb0:	83 ec 08             	sub    $0x8,%esp
80104bb3:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104bb9:	50                   	push   %eax
80104bba:	ff 75 f4             	pushl  -0xc(%ebp)
80104bbd:	e8 fd bc ff ff       	call   801008bf <exec>
80104bc2:	83 c4 10             	add    $0x10,%esp
80104bc5:	eb 54                	jmp    80104c1b <sys_exec+0xd5>
  for(i=0;; i++){
80104bc7:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80104bc8:	83 fb 1f             	cmp    $0x1f,%ebx
80104bcb:	77 49                	ja     80104c16 <sys_exec+0xd0>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104bcd:	83 ec 08             	sub    $0x8,%esp
80104bd0:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104bd6:	50                   	push   %eax
80104bd7:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104bdd:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104be0:	50                   	push   %eax
80104be1:	e8 ff f2 ff ff       	call   80103ee5 <fetchint>
80104be6:	83 c4 10             	add    $0x10,%esp
80104be9:	85 c0                	test   %eax,%eax
80104beb:	78 33                	js     80104c20 <sys_exec+0xda>
    if(uarg == 0){
80104bed:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104bf3:	85 c0                	test   %eax,%eax
80104bf5:	74 ae                	je     80104ba5 <sys_exec+0x5f>
    if(fetchstr(uarg, &argv[i]) < 0)
80104bf7:	83 ec 08             	sub    $0x8,%esp
80104bfa:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104c01:	52                   	push   %edx
80104c02:	50                   	push   %eax
80104c03:	e8 1d f3 ff ff       	call   80103f25 <fetchstr>
80104c08:	83 c4 10             	add    $0x10,%esp
80104c0b:	85 c0                	test   %eax,%eax
80104c0d:	79 b8                	jns    80104bc7 <sys_exec+0x81>
      return -1;
80104c0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c14:	eb 05                	jmp    80104c1b <sys_exec+0xd5>
      return -1;
80104c16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c1e:	c9                   	leave  
80104c1f:	c3                   	ret    
      return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c25:	eb f4                	jmp    80104c1b <sys_exec+0xd5>

80104c27 <sys_pipe>:

int
sys_pipe(void)
{
80104c27:	f3 0f 1e fb          	endbr32 
80104c2b:	55                   	push   %ebp
80104c2c:	89 e5                	mov    %esp,%ebp
80104c2e:	53                   	push   %ebx
80104c2f:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104c32:	6a 08                	push   $0x8
80104c34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c37:	50                   	push   %eax
80104c38:	6a 00                	push   $0x0
80104c3a:	e8 54 f3 ff ff       	call   80103f93 <argptr>
80104c3f:	83 c4 10             	add    $0x10,%esp
80104c42:	85 c0                	test   %eax,%eax
80104c44:	78 79                	js     80104cbf <sys_pipe+0x98>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104c46:	83 ec 08             	sub    $0x8,%esp
80104c49:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c4c:	50                   	push   %eax
80104c4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c50:	50                   	push   %eax
80104c51:	e8 10 e1 ff ff       	call   80102d66 <pipealloc>
80104c56:	83 c4 10             	add    $0x10,%esp
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	78 69                	js     80104cc6 <sys_pipe+0x9f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c60:	e8 8c f4 ff ff       	call   801040f1 <fdalloc>
80104c65:	89 c3                	mov    %eax,%ebx
80104c67:	85 c0                	test   %eax,%eax
80104c69:	78 21                	js     80104c8c <sys_pipe+0x65>
80104c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c6e:	e8 7e f4 ff ff       	call   801040f1 <fdalloc>
80104c73:	85 c0                	test   %eax,%eax
80104c75:	78 15                	js     80104c8c <sys_pipe+0x65>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c7a:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104c7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c7f:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104c82:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c8a:	c9                   	leave  
80104c8b:	c3                   	ret    
    if(fd0 >= 0)
80104c8c:	85 db                	test   %ebx,%ebx
80104c8e:	79 20                	jns    80104cb0 <sys_pipe+0x89>
    fileclose(rf);
80104c90:	83 ec 0c             	sub    $0xc,%esp
80104c93:	ff 75 f0             	pushl  -0x10(%ebp)
80104c96:	e8 32 c0 ff ff       	call   80100ccd <fileclose>
    fileclose(wf);
80104c9b:	83 c4 04             	add    $0x4,%esp
80104c9e:	ff 75 ec             	pushl  -0x14(%ebp)
80104ca1:	e8 27 c0 ff ff       	call   80100ccd <fileclose>
    return -1;
80104ca6:	83 c4 10             	add    $0x10,%esp
80104ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cae:	eb d7                	jmp    80104c87 <sys_pipe+0x60>
      myproc()->ofile[fd0] = 0;
80104cb0:	e8 9c e5 ff ff       	call   80103251 <myproc>
80104cb5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104cbc:	00 
80104cbd:	eb d1                	jmp    80104c90 <sys_pipe+0x69>
    return -1;
80104cbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc4:	eb c1                	jmp    80104c87 <sys_pipe+0x60>
    return -1;
80104cc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ccb:	eb ba                	jmp    80104c87 <sys_pipe+0x60>

80104ccd <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104ccd:	f3 0f 1e fb          	endbr32 
80104cd1:	55                   	push   %ebp
80104cd2:	89 e5                	mov    %esp,%ebp
80104cd4:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104cd7:	e8 f5 e6 ff ff       	call   801033d1 <fork>
}
80104cdc:	c9                   	leave  
80104cdd:	c3                   	ret    

80104cde <sys_exit>:

int
sys_exit(void)
{
80104cde:	f3 0f 1e fb          	endbr32 
80104ce2:	55                   	push   %ebp
80104ce3:	89 e5                	mov    %esp,%ebp
80104ce5:	83 ec 20             	sub    $0x20,%esp
  int status;
  if(argint(0, &status)<0)
80104ce8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ceb:	50                   	push   %eax
80104cec:	6a 00                	push   $0x0
80104cee:	e8 74 f2 ff ff       	call   80103f67 <argint>
80104cf3:	83 c4 10             	add    $0x10,%esp
80104cf6:	85 c0                	test   %eax,%eax
80104cf8:	78 19                	js     80104d13 <sys_exit+0x35>
    return -1;
  exit(status<<8);
80104cfa:	83 ec 0c             	sub    $0xc,%esp
80104cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d00:	c1 e0 08             	shl    $0x8,%eax
80104d03:	50                   	push   %eax
80104d04:	e8 06 e9 ff ff       	call   8010360f <exit>
  return 0;  // not reached
80104d09:	83 c4 10             	add    $0x10,%esp
80104d0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d11:	c9                   	leave  
80104d12:	c3                   	ret    
    return -1;
80104d13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d18:	eb f7                	jmp    80104d11 <sys_exit+0x33>

80104d1a <sys_wait>:

int
sys_wait(void)
{
80104d1a:	f3 0f 1e fb          	endbr32 
80104d1e:	55                   	push   %ebp
80104d1f:	89 e5                	mov    %esp,%ebp
80104d21:	83 ec 1c             	sub    $0x1c,%esp
  int * status;
  if (argptr(0, (void **)&status, sizeof(int)) < 0)
80104d24:	6a 04                	push   $0x4
80104d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d29:	50                   	push   %eax
80104d2a:	6a 00                	push   $0x0
80104d2c:	e8 62 f2 ff ff       	call   80103f93 <argptr>
80104d31:	83 c4 10             	add    $0x10,%esp
80104d34:	85 c0                	test   %eax,%eax
80104d36:	78 10                	js     80104d48 <sys_wait+0x2e>
    return -1;
  return wait(status);
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	ff 75 f4             	pushl  -0xc(%ebp)
80104d3e:	e8 76 ea ff ff       	call   801037b9 <wait>
80104d43:	83 c4 10             	add    $0x10,%esp
}
80104d46:	c9                   	leave  
80104d47:	c3                   	ret    
    return -1;
80104d48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d4d:	eb f7                	jmp    80104d46 <sys_wait+0x2c>

80104d4f <sys_kill>:

int
sys_kill(void)
{
80104d4f:	f3 0f 1e fb          	endbr32 
80104d53:	55                   	push   %ebp
80104d54:	89 e5                	mov    %esp,%ebp
80104d56:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104d59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d5c:	50                   	push   %eax
80104d5d:	6a 00                	push   $0x0
80104d5f:	e8 03 f2 ff ff       	call   80103f67 <argint>
80104d64:	83 c4 10             	add    $0x10,%esp
80104d67:	85 c0                	test   %eax,%eax
80104d69:	78 10                	js     80104d7b <sys_kill+0x2c>
    return -1;
  return kill(pid);
80104d6b:	83 ec 0c             	sub    $0xc,%esp
80104d6e:	ff 75 f4             	pushl  -0xc(%ebp)
80104d71:	e8 52 eb ff ff       	call   801038c8 <kill>
80104d76:	83 c4 10             	add    $0x10,%esp
}
80104d79:	c9                   	leave  
80104d7a:	c3                   	ret    
    return -1;
80104d7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d80:	eb f7                	jmp    80104d79 <sys_kill+0x2a>

80104d82 <sys_getpid>:

int
sys_getpid(void)
{
80104d82:	f3 0f 1e fb          	endbr32 
80104d86:	55                   	push   %ebp
80104d87:	89 e5                	mov    %esp,%ebp
80104d89:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104d8c:	e8 c0 e4 ff ff       	call   80103251 <myproc>
80104d91:	8b 40 10             	mov    0x10(%eax),%eax
}
80104d94:	c9                   	leave  
80104d95:	c3                   	ret    

80104d96 <sys_sbrk>:

int
sys_sbrk(void)
{
80104d96:	f3 0f 1e fb          	endbr32 
80104d9a:	55                   	push   %ebp
80104d9b:	89 e5                	mov    %esp,%ebp
80104d9d:	53                   	push   %ebx
80104d9e:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104da1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104da4:	50                   	push   %eax
80104da5:	6a 00                	push   $0x0
80104da7:	e8 bb f1 ff ff       	call   80103f67 <argint>
80104dac:	83 c4 10             	add    $0x10,%esp
80104daf:	85 c0                	test   %eax,%eax
80104db1:	78 20                	js     80104dd3 <sys_sbrk+0x3d>
    return -1;
  addr = myproc()->sz;
80104db3:	e8 99 e4 ff ff       	call   80103251 <myproc>
80104db8:	8b 18                	mov    (%eax),%ebx

  if(n > 0){
80104dba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104dbe:	7f 07                	jg     80104dc7 <sys_sbrk+0x31>
    myproc()->sz += n; // Si es mayor que 0 se aumenta el tamaño del proceso pero no se llama a growproc (allocuvm)
  }

  return addr;
}
80104dc0:	89 d8                	mov    %ebx,%eax
80104dc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc5:	c9                   	leave  
80104dc6:	c3                   	ret    
    myproc()->sz += n; // Si es mayor que 0 se aumenta el tamaño del proceso pero no se llama a growproc (allocuvm)
80104dc7:	e8 85 e4 ff ff       	call   80103251 <myproc>
80104dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dcf:	01 10                	add    %edx,(%eax)
80104dd1:	eb ed                	jmp    80104dc0 <sys_sbrk+0x2a>
    return -1;
80104dd3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104dd8:	eb e6                	jmp    80104dc0 <sys_sbrk+0x2a>

80104dda <sys_sleep>:

int
sys_sleep(void)
{
80104dda:	f3 0f 1e fb          	endbr32 
80104dde:	55                   	push   %ebp
80104ddf:	89 e5                	mov    %esp,%ebp
80104de1:	53                   	push   %ebx
80104de2:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104de5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104de8:	50                   	push   %eax
80104de9:	6a 00                	push   $0x0
80104deb:	e8 77 f1 ff ff       	call   80103f67 <argint>
80104df0:	83 c4 10             	add    $0x10,%esp
80104df3:	85 c0                	test   %eax,%eax
80104df5:	78 75                	js     80104e6c <sys_sleep+0x92>
    return -1;
  acquire(&tickslock);
80104df7:	83 ec 0c             	sub    $0xc,%esp
80104dfa:	68 60 4d 11 80       	push   $0x80114d60
80104dff:	e8 56 ee ff ff       	call   80103c5a <acquire>
  ticks0 = ticks;
80104e04:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80104e0a:	83 c4 10             	add    $0x10,%esp
80104e0d:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80104e12:	29 d8                	sub    %ebx,%eax
80104e14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104e17:	73 39                	jae    80104e52 <sys_sleep+0x78>
    if(myproc()->killed){
80104e19:	e8 33 e4 ff ff       	call   80103251 <myproc>
80104e1e:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e22:	75 17                	jne    80104e3b <sys_sleep+0x61>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104e24:	83 ec 08             	sub    $0x8,%esp
80104e27:	68 60 4d 11 80       	push   $0x80114d60
80104e2c:	68 a0 55 11 80       	push   $0x801155a0
80104e31:	e8 ee e8 ff ff       	call   80103724 <sleep>
80104e36:	83 c4 10             	add    $0x10,%esp
80104e39:	eb d2                	jmp    80104e0d <sys_sleep+0x33>
      release(&tickslock);
80104e3b:	83 ec 0c             	sub    $0xc,%esp
80104e3e:	68 60 4d 11 80       	push   $0x80114d60
80104e43:	e8 7b ee ff ff       	call   80103cc3 <release>
      return -1;
80104e48:	83 c4 10             	add    $0x10,%esp
80104e4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e50:	eb 15                	jmp    80104e67 <sys_sleep+0x8d>
  }
  release(&tickslock);
80104e52:	83 ec 0c             	sub    $0xc,%esp
80104e55:	68 60 4d 11 80       	push   $0x80114d60
80104e5a:	e8 64 ee ff ff       	call   80103cc3 <release>
  return 0;
80104e5f:	83 c4 10             	add    $0x10,%esp
80104e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e6a:	c9                   	leave  
80104e6b:	c3                   	ret    
    return -1;
80104e6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e71:	eb f4                	jmp    80104e67 <sys_sleep+0x8d>

80104e73 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104e73:	f3 0f 1e fb          	endbr32 
80104e77:	55                   	push   %ebp
80104e78:	89 e5                	mov    %esp,%ebp
80104e7a:	53                   	push   %ebx
80104e7b:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104e7e:	68 60 4d 11 80       	push   $0x80114d60
80104e83:	e8 d2 ed ff ff       	call   80103c5a <acquire>
  xticks = ticks;
80104e88:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
80104e8e:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80104e95:	e8 29 ee ff ff       	call   80103cc3 <release>
  return xticks;
}
80104e9a:	89 d8                	mov    %ebx,%eax
80104e9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e9f:	c9                   	leave  
80104ea0:	c3                   	ret    

80104ea1 <sys_date>:

int
sys_date(void){
80104ea1:	f3 0f 1e fb          	endbr32 
80104ea5:	55                   	push   %ebp
80104ea6:	89 e5                	mov    %esp,%ebp
80104ea8:	83 ec 1c             	sub    $0x1c,%esp

  struct rtcdate *d;
  
  if(argptr(0,(void **)&d,sizeof(struct rtcdate))<-1)
80104eab:	6a 18                	push   $0x18
80104ead:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eb0:	50                   	push   %eax
80104eb1:	6a 00                	push   $0x0
80104eb3:	e8 db f0 ff ff       	call   80103f93 <argptr>
80104eb8:	83 c4 10             	add    $0x10,%esp
80104ebb:	83 f8 ff             	cmp    $0xffffffff,%eax
80104ebe:	7c 15                	jl     80104ed5 <sys_date+0x34>
    return -1;
  cmostime(d);
80104ec0:	83 ec 0c             	sub    $0xc,%esp
80104ec3:	ff 75 f4             	pushl  -0xc(%ebp)
80104ec6:	e8 d2 d5 ff ff       	call   8010249d <cmostime>
  return 0;
80104ecb:	83 c4 10             	add    $0x10,%esp
80104ece:	b8 00 00 00 00       	mov    $0x0,%eax

}
80104ed3:	c9                   	leave  
80104ed4:	c3                   	ret    
    return -1;
80104ed5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eda:	eb f7                	jmp    80104ed3 <sys_date+0x32>

80104edc <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104edc:	1e                   	push   %ds
  pushl %es
80104edd:	06                   	push   %es
  pushl %fs
80104ede:	0f a0                	push   %fs
  pushl %gs
80104ee0:	0f a8                	push   %gs
  pushal
80104ee2:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104ee3:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104ee7:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104ee9:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104eeb:	54                   	push   %esp
  call trap
80104eec:	e8 e6 00 00 00       	call   80104fd7 <trap>
  addl $4, %esp
80104ef1:	83 c4 04             	add    $0x4,%esp

80104ef4 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104ef4:	61                   	popa   
  popl %gs
80104ef5:	0f a9                	pop    %gs
  popl %fs
80104ef7:	0f a1                	pop    %fs
  popl %es
80104ef9:	07                   	pop    %es
  popl %ds
80104efa:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104efb:	83 c4 08             	add    $0x8,%esp
  iret
80104efe:	cf                   	iret   

80104eff <tvinit>:
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);

void
tvinit(void)
{
80104eff:	f3 0f 1e fb          	endbr32 
80104f03:	55                   	push   %ebp
80104f04:	89 e5                	mov    %esp,%ebp
80104f06:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
80104f09:	b8 00 00 00 00       	mov    $0x0,%eax
80104f0e:	3d ff 00 00 00       	cmp    $0xff,%eax
80104f13:	7f 49                	jg     80104f5e <tvinit+0x5f>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104f15:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80104f1c:	66 89 0c c5 a0 4d 11 	mov    %cx,-0x7feeb260(,%eax,8)
80104f23:	80 
80104f24:	66 c7 04 c5 a2 4d 11 	movw   $0x8,-0x7feeb25e(,%eax,8)
80104f2b:	80 08 00 
80104f2e:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
80104f35:	00 
80104f36:	8a 14 c5 a5 4d 11 80 	mov    -0x7feeb25b(,%eax,8),%dl
80104f3d:	83 e2 f0             	and    $0xfffffff0,%edx
80104f40:	83 ca 0e             	or     $0xe,%edx
80104f43:	83 e2 8f             	and    $0xffffff8f,%edx
80104f46:	83 ca 80             	or     $0xffffff80,%edx
80104f49:	88 14 c5 a5 4d 11 80 	mov    %dl,-0x7feeb25b(,%eax,8)
80104f50:	c1 e9 10             	shr    $0x10,%ecx
80104f53:	66 89 0c c5 a6 4d 11 	mov    %cx,-0x7feeb25a(,%eax,8)
80104f5a:	80 
  for(i = 0; i < 256; i++)
80104f5b:	40                   	inc    %eax
80104f5c:	eb b0                	jmp    80104f0e <tvinit+0xf>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104f5e:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80104f64:	66 89 15 a0 4f 11 80 	mov    %dx,0x80114fa0
80104f6b:	66 c7 05 a2 4f 11 80 	movw   $0x8,0x80114fa2
80104f72:	08 00 
80104f74:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
80104f7b:	a0 a5 4f 11 80       	mov    0x80114fa5,%al
80104f80:	83 c8 0f             	or     $0xf,%eax
80104f83:	83 e0 ef             	and    $0xffffffef,%eax
80104f86:	83 c8 e0             	or     $0xffffffe0,%eax
80104f89:	a2 a5 4f 11 80       	mov    %al,0x80114fa5
80104f8e:	c1 ea 10             	shr    $0x10,%edx
80104f91:	66 89 15 a6 4f 11 80 	mov    %dx,0x80114fa6

  initlock(&tickslock, "time");
80104f98:	83 ec 08             	sub    $0x8,%esp
80104f9b:	68 81 6f 10 80       	push   $0x80106f81
80104fa0:	68 60 4d 11 80       	push   $0x80114d60
80104fa5:	e8 65 eb ff ff       	call   80103b0f <initlock>
}
80104faa:	83 c4 10             	add    $0x10,%esp
80104fad:	c9                   	leave  
80104fae:	c3                   	ret    

80104faf <idtinit>:

void
idtinit(void)
{
80104faf:	f3 0f 1e fb          	endbr32 
80104fb3:	55                   	push   %ebp
80104fb4:	89 e5                	mov    %esp,%ebp
80104fb6:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104fb9:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104fbf:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80104fc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104fc8:	c1 e8 10             	shr    $0x10,%eax
80104fcb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104fcf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104fd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104fd5:	c9                   	leave  
80104fd6:	c3                   	ret    

80104fd7 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104fd7:	f3 0f 1e fb          	endbr32 
80104fdb:	55                   	push   %ebp
80104fdc:	89 e5                	mov    %esp,%ebp
80104fde:	57                   	push   %edi
80104fdf:	56                   	push   %esi
80104fe0:	53                   	push   %ebx
80104fe1:	83 ec 1c             	sub    $0x1c,%esp
80104fe4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104fe7:	8b 43 30             	mov    0x30(%ebx),%eax
80104fea:	83 f8 40             	cmp    $0x40,%eax
80104fed:	74 14                	je     80105003 <trap+0x2c>
      exit(0);
    return;
  }
  uint dirPageErr;
  char *mem;
  switch(tf->trapno){
80104fef:	83 e8 0e             	sub    $0xe,%eax
80104ff2:	83 f8 31             	cmp    $0x31,%eax
80104ff5:	0f 87 82 02 00 00    	ja     8010527d <trap+0x2a6>
80104ffb:	3e ff 24 85 6c 70 10 	notrack jmp *-0x7fef8f94(,%eax,4)
80105002:	80 
    if(myproc()->killed)
80105003:	e8 49 e2 ff ff       	call   80103251 <myproc>
80105008:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010500c:	75 2b                	jne    80105039 <trap+0x62>
    myproc()->tf = tf;
8010500e:	e8 3e e2 ff ff       	call   80103251 <myproc>
80105013:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105016:	e8 1b f0 ff ff       	call   80104036 <syscall>
    if(myproc()->killed)
8010501b:	e8 31 e2 ff ff       	call   80103251 <myproc>
80105020:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105024:	0f 84 8c 00 00 00    	je     801050b6 <trap+0xdf>
      exit(0);
8010502a:	83 ec 0c             	sub    $0xc,%esp
8010502d:	6a 00                	push   $0x0
8010502f:	e8 db e5 ff ff       	call   8010360f <exit>
80105034:	83 c4 10             	add    $0x10,%esp
    return;
80105037:	eb 7d                	jmp    801050b6 <trap+0xdf>
      exit(0);
80105039:	83 ec 0c             	sub    $0xc,%esp
8010503c:	6a 00                	push   $0x0
8010503e:	e8 cc e5 ff ff       	call   8010360f <exit>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	eb c6                	jmp    8010500e <trap+0x37>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105048:	e8 cf e1 ff ff       	call   8010321c <cpuid>
8010504d:	85 c0                	test   %eax,%eax
8010504f:	74 6d                	je     801050be <trap+0xe7>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105051:	e8 86 d3 ff ff       	call   801023dc <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105056:	e8 f6 e1 ff ff       	call   80103251 <myproc>
8010505b:	85 c0                	test   %eax,%eax
8010505d:	74 1b                	je     8010507a <trap+0xa3>
8010505f:	e8 ed e1 ff ff       	call   80103251 <myproc>
80105064:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105068:	74 10                	je     8010507a <trap+0xa3>
8010506a:	8b 43 3c             	mov    0x3c(%ebx),%eax
8010506d:	83 e0 03             	and    $0x3,%eax
80105070:	66 83 f8 03          	cmp    $0x3,%ax
80105074:	0f 84 96 02 00 00    	je     80105310 <trap+0x339>
    exit(tf->trapno+1);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010507a:	e8 d2 e1 ff ff       	call   80103251 <myproc>
8010507f:	85 c0                	test   %eax,%eax
80105081:	74 0f                	je     80105092 <trap+0xbb>
80105083:	e8 c9 e1 ff ff       	call   80103251 <myproc>
80105088:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010508c:	0f 84 93 02 00 00    	je     80105325 <trap+0x34e>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105092:	e8 ba e1 ff ff       	call   80103251 <myproc>
80105097:	85 c0                	test   %eax,%eax
80105099:	74 1b                	je     801050b6 <trap+0xdf>
8010509b:	e8 b1 e1 ff ff       	call   80103251 <myproc>
801050a0:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801050a4:	74 10                	je     801050b6 <trap+0xdf>
801050a6:	8b 43 3c             	mov    0x3c(%ebx),%eax
801050a9:	83 e0 03             	and    $0x3,%eax
801050ac:	66 83 f8 03          	cmp    $0x3,%ax
801050b0:	0f 84 83 02 00 00    	je     80105339 <trap+0x362>
    exit(tf->trapno+1);
}
801050b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050b9:	5b                   	pop    %ebx
801050ba:	5e                   	pop    %esi
801050bb:	5f                   	pop    %edi
801050bc:	5d                   	pop    %ebp
801050bd:	c3                   	ret    
      acquire(&tickslock);
801050be:	83 ec 0c             	sub    $0xc,%esp
801050c1:	68 60 4d 11 80       	push   $0x80114d60
801050c6:	e8 8f eb ff ff       	call   80103c5a <acquire>
      ticks++;
801050cb:	ff 05 a0 55 11 80    	incl   0x801155a0
      wakeup(&ticks);
801050d1:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
801050d8:	e8 be e7 ff ff       	call   8010389b <wakeup>
      release(&tickslock);
801050dd:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801050e4:	e8 da eb ff ff       	call   80103cc3 <release>
801050e9:	83 c4 10             	add    $0x10,%esp
801050ec:	e9 60 ff ff ff       	jmp    80105051 <trap+0x7a>
    ideintr();
801050f1:	e8 a2 cc ff ff       	call   80101d98 <ideintr>
    lapiceoi();
801050f6:	e8 e1 d2 ff ff       	call   801023dc <lapiceoi>
    break;
801050fb:	e9 56 ff ff ff       	jmp    80105056 <trap+0x7f>
    kbdintr();
80105100:	e8 14 d1 ff ff       	call   80102219 <kbdintr>
    lapiceoi();
80105105:	e8 d2 d2 ff ff       	call   801023dc <lapiceoi>
    break;
8010510a:	e9 47 ff ff ff       	jmp    80105056 <trap+0x7f>
    uartintr();
8010510f:	e8 42 03 00 00       	call   80105456 <uartintr>
    lapiceoi();
80105114:	e8 c3 d2 ff ff       	call   801023dc <lapiceoi>
    break;
80105119:	e9 38 ff ff ff       	jmp    80105056 <trap+0x7f>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010511e:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80105121:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105124:	e8 f3 e0 ff ff       	call   8010321c <cpuid>
80105129:	57                   	push   %edi
8010512a:	0f b7 f6             	movzwl %si,%esi
8010512d:	56                   	push   %esi
8010512e:	50                   	push   %eax
8010512f:	68 8c 6f 10 80       	push   $0x80106f8c
80105134:	e8 c4 b4 ff ff       	call   801005fd <cprintf>
    lapiceoi();
80105139:	e8 9e d2 ff ff       	call   801023dc <lapiceoi>
    break;
8010513e:	83 c4 10             	add    $0x10,%esp
80105141:	e9 10 ff ff ff       	jmp    80105056 <trap+0x7f>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105146:	0f 20 d6             	mov    %cr2,%esi
      dirPageErr = PGROUNDDOWN(rcr2());
80105149:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
8010514f:	0f 20 d7             	mov    %cr2,%edi
      if(rcr2() >= myproc()->sz){ 
80105152:	e8 fa e0 ff ff       	call   80103251 <myproc>
80105157:	39 38                	cmp    %edi,(%eax)
80105159:	77 59                	ja     801051b4 <trap+0x1dd>
8010515b:	0f 20 d7             	mov    %cr2,%edi
        cprintf("pid %d %s: trap %d err %d on cpu %d "
8010515e:	8b 43 38             	mov    0x38(%ebx),%eax
80105161:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105164:	e8 b3 e0 ff ff       	call   8010321c <cpuid>
80105169:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010516c:	8b 4b 34             	mov    0x34(%ebx),%ecx
8010516f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80105172:	8b 73 30             	mov    0x30(%ebx),%esi
              myproc()->pid, myproc()->name, tf->trapno,
80105175:	e8 d7 e0 ff ff       	call   80103251 <myproc>
8010517a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010517d:	89 55 d8             	mov    %edx,-0x28(%ebp)
80105180:	e8 cc e0 ff ff       	call   80103251 <myproc>
        cprintf("pid %d %s: trap %d err %d on cpu %d "
80105185:	57                   	push   %edi
80105186:	ff 75 e4             	pushl  -0x1c(%ebp)
80105189:	ff 75 e0             	pushl  -0x20(%ebp)
8010518c:	ff 75 dc             	pushl  -0x24(%ebp)
8010518f:	56                   	push   %esi
80105190:	ff 75 d8             	pushl  -0x28(%ebp)
80105193:	ff 70 10             	pushl  0x10(%eax)
80105196:	68 b0 6f 10 80       	push   $0x80106fb0
8010519b:	e8 5d b4 ff ff       	call   801005fd <cprintf>
        myproc()->killed = 1;
801051a0:	83 c4 20             	add    $0x20,%esp
801051a3:	e8 a9 e0 ff ff       	call   80103251 <myproc>
801051a8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        break;
801051af:	e9 a2 fe ff ff       	jmp    80105056 <trap+0x7f>
      if(myproc() == 0){
801051b4:	e8 98 e0 ff ff       	call   80103251 <myproc>
801051b9:	85 c0                	test   %eax,%eax
801051bb:	74 74                	je     80105231 <trap+0x25a>
      mem = kalloc();
801051bd:	e8 3a cf ff ff       	call   801020fc <kalloc>
801051c2:	89 c7                	mov    %eax,%edi
      if(mem == 0){
801051c4:	85 c0                	test   %eax,%eax
801051c6:	0f 84 90 00 00 00    	je     8010525c <trap+0x285>
        memset(mem, 0, PGSIZE); //Inicializamos la página 0s para que no haya información residual
801051cc:	83 ec 04             	sub    $0x4,%esp
801051cf:	68 00 10 00 00       	push   $0x1000
801051d4:	6a 00                	push   $0x0
801051d6:	50                   	push   %eax
801051d7:	e8 32 eb ff ff       	call   80103d0e <memset>
        if(mappages(myproc()->pgdir, (char*)dirPageErr, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801051dc:	e8 70 e0 ff ff       	call   80103251 <myproc>
801051e1:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801051e8:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
801051ee:	52                   	push   %edx
801051ef:	68 00 10 00 00       	push   $0x1000
801051f4:	56                   	push   %esi
801051f5:	ff 70 04             	pushl  0x4(%eax)
801051f8:	e8 ce 0e 00 00       	call   801060cb <mappages>
801051fd:	83 c4 20             	add    $0x20,%esp
80105200:	85 c0                	test   %eax,%eax
80105202:	0f 89 4e fe ff ff    	jns    80105056 <trap+0x7f>
          cprintf("Out of memory (T_PGFLT) mappages\n");
80105208:	83 ec 0c             	sub    $0xc,%esp
8010520b:	68 48 70 10 80       	push   $0x80107048
80105210:	e8 e8 b3 ff ff       	call   801005fd <cprintf>
          kfree(mem);
80105215:	89 3c 24             	mov    %edi,(%esp)
80105218:	e8 b8 cd ff ff       	call   80101fd5 <kfree>
          myproc()->killed = 1;
8010521d:	e8 2f e0 ff ff       	call   80103251 <myproc>
80105222:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          break;
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	e9 25 fe ff ff       	jmp    80105056 <trap+0x7f>
80105231:	0f 20 d7             	mov    %cr2,%edi
          cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105234:	8b 73 38             	mov    0x38(%ebx),%esi
80105237:	e8 e0 df ff ff       	call   8010321c <cpuid>
8010523c:	83 ec 0c             	sub    $0xc,%esp
8010523f:	57                   	push   %edi
80105240:	56                   	push   %esi
80105241:	50                   	push   %eax
80105242:	ff 73 30             	pushl  0x30(%ebx)
80105245:	68 f4 6f 10 80       	push   $0x80106ff4
8010524a:	e8 ae b3 ff ff       	call   801005fd <cprintf>
        panic("trap");
8010524f:	83 c4 14             	add    $0x14,%esp
80105252:	68 86 6f 10 80       	push   $0x80106f86
80105257:	e8 f9 b0 ff ff       	call   80100355 <panic>
        cprintf("Out of memory (T_PGFLT) kalloc\n");
8010525c:	83 ec 0c             	sub    $0xc,%esp
8010525f:	68 28 70 10 80       	push   $0x80107028
80105264:	e8 94 b3 ff ff       	call   801005fd <cprintf>
        myproc()->killed = 1;
80105269:	e8 e3 df ff ff       	call   80103251 <myproc>
8010526e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        break;
80105275:	83 c4 10             	add    $0x10,%esp
80105278:	e9 d9 fd ff ff       	jmp    80105056 <trap+0x7f>
    if(myproc() == 0 || (tf->cs&3) == 0){
8010527d:	e8 cf df ff ff       	call   80103251 <myproc>
80105282:	85 c0                	test   %eax,%eax
80105284:	74 5f                	je     801052e5 <trap+0x30e>
80105286:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010528a:	74 59                	je     801052e5 <trap+0x30e>
8010528c:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010528f:	8b 43 38             	mov    0x38(%ebx),%eax
80105292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105295:	e8 82 df ff ff       	call   8010321c <cpuid>
8010529a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010529d:	8b 4b 34             	mov    0x34(%ebx),%ecx
801052a0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801052a3:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801052a6:	e8 a6 df ff ff       	call   80103251 <myproc>
801052ab:	8d 50 6c             	lea    0x6c(%eax),%edx
801052ae:	89 55 d8             	mov    %edx,-0x28(%ebp)
801052b1:	e8 9b df ff ff       	call   80103251 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801052b6:	57                   	push   %edi
801052b7:	ff 75 e4             	pushl  -0x1c(%ebp)
801052ba:	ff 75 e0             	pushl  -0x20(%ebp)
801052bd:	ff 75 dc             	pushl  -0x24(%ebp)
801052c0:	56                   	push   %esi
801052c1:	ff 75 d8             	pushl  -0x28(%ebp)
801052c4:	ff 70 10             	pushl  0x10(%eax)
801052c7:	68 b0 6f 10 80       	push   $0x80106fb0
801052cc:	e8 2c b3 ff ff       	call   801005fd <cprintf>
    myproc()->killed = 1;
801052d1:	83 c4 20             	add    $0x20,%esp
801052d4:	e8 78 df ff ff       	call   80103251 <myproc>
801052d9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801052e0:	e9 71 fd ff ff       	jmp    80105056 <trap+0x7f>
801052e5:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801052e8:	8b 73 38             	mov    0x38(%ebx),%esi
801052eb:	e8 2c df ff ff       	call   8010321c <cpuid>
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
801052f5:	50                   	push   %eax
801052f6:	ff 73 30             	pushl  0x30(%ebx)
801052f9:	68 f4 6f 10 80       	push   $0x80106ff4
801052fe:	e8 fa b2 ff ff       	call   801005fd <cprintf>
      panic("trap");
80105303:	83 c4 14             	add    $0x14,%esp
80105306:	68 86 6f 10 80       	push   $0x80106f86
8010530b:	e8 45 b0 ff ff       	call   80100355 <panic>
    exit(tf->trapno+1);
80105310:	8b 43 30             	mov    0x30(%ebx),%eax
80105313:	40                   	inc    %eax
80105314:	83 ec 0c             	sub    $0xc,%esp
80105317:	50                   	push   %eax
80105318:	e8 f2 e2 ff ff       	call   8010360f <exit>
8010531d:	83 c4 10             	add    $0x10,%esp
80105320:	e9 55 fd ff ff       	jmp    8010507a <trap+0xa3>
  if(myproc() && myproc()->state == RUNNING &&
80105325:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105329:	0f 85 63 fd ff ff    	jne    80105092 <trap+0xbb>
    yield();
8010532f:	e8 ba e3 ff ff       	call   801036ee <yield>
80105334:	e9 59 fd ff ff       	jmp    80105092 <trap+0xbb>
    exit(tf->trapno+1);
80105339:	8b 43 30             	mov    0x30(%ebx),%eax
8010533c:	40                   	inc    %eax
8010533d:	83 ec 0c             	sub    $0xc,%esp
80105340:	50                   	push   %eax
80105341:	e8 c9 e2 ff ff       	call   8010360f <exit>
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	e9 68 fd ff ff       	jmp    801050b6 <trap+0xdf>

8010534e <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
8010534e:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105352:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
80105359:	74 14                	je     8010536f <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010535b:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105360:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105361:	a8 01                	test   $0x1,%al
80105363:	74 10                	je     80105375 <uartgetc+0x27>
80105365:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010536a:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010536b:	0f b6 c0             	movzbl %al,%eax
8010536e:	c3                   	ret    
    return -1;
8010536f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105374:	c3                   	ret    
    return -1;
80105375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010537a:	c3                   	ret    

8010537b <uartputc>:
{
8010537b:	f3 0f 1e fb          	endbr32 
  if(!uart)
8010537f:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
80105386:	74 39                	je     801053c1 <uartputc+0x46>
{
80105388:	55                   	push   %ebp
80105389:	89 e5                	mov    %esp,%ebp
8010538b:	53                   	push   %ebx
8010538c:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010538f:	bb 00 00 00 00       	mov    $0x0,%ebx
80105394:	83 fb 7f             	cmp    $0x7f,%ebx
80105397:	7f 1a                	jg     801053b3 <uartputc+0x38>
80105399:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010539e:	ec                   	in     (%dx),%al
8010539f:	a8 20                	test   $0x20,%al
801053a1:	75 10                	jne    801053b3 <uartputc+0x38>
    microdelay(10);
801053a3:	83 ec 0c             	sub    $0xc,%esp
801053a6:	6a 0a                	push   $0xa
801053a8:	e8 54 d0 ff ff       	call   80102401 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801053ad:	43                   	inc    %ebx
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	eb e1                	jmp    80105394 <uartputc+0x19>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801053b3:	8b 45 08             	mov    0x8(%ebp),%eax
801053b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801053bb:	ee                   	out    %al,(%dx)
}
801053bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053bf:	c9                   	leave  
801053c0:	c3                   	ret    
801053c1:	c3                   	ret    

801053c2 <uartinit>:
{
801053c2:	f3 0f 1e fb          	endbr32 
801053c6:	55                   	push   %ebp
801053c7:	89 e5                	mov    %esp,%ebp
801053c9:	56                   	push   %esi
801053ca:	53                   	push   %ebx
801053cb:	b1 00                	mov    $0x0,%cl
801053cd:	ba fa 03 00 00       	mov    $0x3fa,%edx
801053d2:	88 c8                	mov    %cl,%al
801053d4:	ee                   	out    %al,(%dx)
801053d5:	be fb 03 00 00       	mov    $0x3fb,%esi
801053da:	b0 80                	mov    $0x80,%al
801053dc:	89 f2                	mov    %esi,%edx
801053de:	ee                   	out    %al,(%dx)
801053df:	b0 0c                	mov    $0xc,%al
801053e1:	ba f8 03 00 00       	mov    $0x3f8,%edx
801053e6:	ee                   	out    %al,(%dx)
801053e7:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801053ec:	88 c8                	mov    %cl,%al
801053ee:	89 da                	mov    %ebx,%edx
801053f0:	ee                   	out    %al,(%dx)
801053f1:	b0 03                	mov    $0x3,%al
801053f3:	89 f2                	mov    %esi,%edx
801053f5:	ee                   	out    %al,(%dx)
801053f6:	ba fc 03 00 00       	mov    $0x3fc,%edx
801053fb:	88 c8                	mov    %cl,%al
801053fd:	ee                   	out    %al,(%dx)
801053fe:	b0 01                	mov    $0x1,%al
80105400:	89 da                	mov    %ebx,%edx
80105402:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105403:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105408:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105409:	3c ff                	cmp    $0xff,%al
8010540b:	74 42                	je     8010544f <uartinit+0x8d>
  uart = 1;
8010540d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105414:	00 00 00 
80105417:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010541c:	ec                   	in     (%dx),%al
8010541d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105422:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105423:	83 ec 08             	sub    $0x8,%esp
80105426:	6a 00                	push   $0x0
80105428:	6a 04                	push   $0x4
8010542a:	e8 76 cb ff ff       	call   80101fa5 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
8010542f:	83 c4 10             	add    $0x10,%esp
80105432:	bb 34 71 10 80       	mov    $0x80107134,%ebx
80105437:	eb 10                	jmp    80105449 <uartinit+0x87>
    uartputc(*p);
80105439:	83 ec 0c             	sub    $0xc,%esp
8010543c:	0f be c0             	movsbl %al,%eax
8010543f:	50                   	push   %eax
80105440:	e8 36 ff ff ff       	call   8010537b <uartputc>
  for(p="xv6...\n"; *p; p++)
80105445:	43                   	inc    %ebx
80105446:	83 c4 10             	add    $0x10,%esp
80105449:	8a 03                	mov    (%ebx),%al
8010544b:	84 c0                	test   %al,%al
8010544d:	75 ea                	jne    80105439 <uartinit+0x77>
}
8010544f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105452:	5b                   	pop    %ebx
80105453:	5e                   	pop    %esi
80105454:	5d                   	pop    %ebp
80105455:	c3                   	ret    

80105456 <uartintr>:

void
uartintr(void)
{
80105456:	f3 0f 1e fb          	endbr32 
8010545a:	55                   	push   %ebp
8010545b:	89 e5                	mov    %esp,%ebp
8010545d:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105460:	68 4e 53 10 80       	push   $0x8010534e
80105465:	e8 bc b2 ff ff       	call   80100726 <consoleintr>
}
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	c9                   	leave  
8010546e:	c3                   	ret    

8010546f <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010546f:	6a 00                	push   $0x0
  pushl $0
80105471:	6a 00                	push   $0x0
  jmp alltraps
80105473:	e9 64 fa ff ff       	jmp    80104edc <alltraps>

80105478 <vector1>:
.globl vector1
vector1:
  pushl $0
80105478:	6a 00                	push   $0x0
  pushl $1
8010547a:	6a 01                	push   $0x1
  jmp alltraps
8010547c:	e9 5b fa ff ff       	jmp    80104edc <alltraps>

80105481 <vector2>:
.globl vector2
vector2:
  pushl $0
80105481:	6a 00                	push   $0x0
  pushl $2
80105483:	6a 02                	push   $0x2
  jmp alltraps
80105485:	e9 52 fa ff ff       	jmp    80104edc <alltraps>

8010548a <vector3>:
.globl vector3
vector3:
  pushl $0
8010548a:	6a 00                	push   $0x0
  pushl $3
8010548c:	6a 03                	push   $0x3
  jmp alltraps
8010548e:	e9 49 fa ff ff       	jmp    80104edc <alltraps>

80105493 <vector4>:
.globl vector4
vector4:
  pushl $0
80105493:	6a 00                	push   $0x0
  pushl $4
80105495:	6a 04                	push   $0x4
  jmp alltraps
80105497:	e9 40 fa ff ff       	jmp    80104edc <alltraps>

8010549c <vector5>:
.globl vector5
vector5:
  pushl $0
8010549c:	6a 00                	push   $0x0
  pushl $5
8010549e:	6a 05                	push   $0x5
  jmp alltraps
801054a0:	e9 37 fa ff ff       	jmp    80104edc <alltraps>

801054a5 <vector6>:
.globl vector6
vector6:
  pushl $0
801054a5:	6a 00                	push   $0x0
  pushl $6
801054a7:	6a 06                	push   $0x6
  jmp alltraps
801054a9:	e9 2e fa ff ff       	jmp    80104edc <alltraps>

801054ae <vector7>:
.globl vector7
vector7:
  pushl $0
801054ae:	6a 00                	push   $0x0
  pushl $7
801054b0:	6a 07                	push   $0x7
  jmp alltraps
801054b2:	e9 25 fa ff ff       	jmp    80104edc <alltraps>

801054b7 <vector8>:
.globl vector8
vector8:
  pushl $8
801054b7:	6a 08                	push   $0x8
  jmp alltraps
801054b9:	e9 1e fa ff ff       	jmp    80104edc <alltraps>

801054be <vector9>:
.globl vector9
vector9:
  pushl $0
801054be:	6a 00                	push   $0x0
  pushl $9
801054c0:	6a 09                	push   $0x9
  jmp alltraps
801054c2:	e9 15 fa ff ff       	jmp    80104edc <alltraps>

801054c7 <vector10>:
.globl vector10
vector10:
  pushl $10
801054c7:	6a 0a                	push   $0xa
  jmp alltraps
801054c9:	e9 0e fa ff ff       	jmp    80104edc <alltraps>

801054ce <vector11>:
.globl vector11
vector11:
  pushl $11
801054ce:	6a 0b                	push   $0xb
  jmp alltraps
801054d0:	e9 07 fa ff ff       	jmp    80104edc <alltraps>

801054d5 <vector12>:
.globl vector12
vector12:
  pushl $12
801054d5:	6a 0c                	push   $0xc
  jmp alltraps
801054d7:	e9 00 fa ff ff       	jmp    80104edc <alltraps>

801054dc <vector13>:
.globl vector13
vector13:
  pushl $13
801054dc:	6a 0d                	push   $0xd
  jmp alltraps
801054de:	e9 f9 f9 ff ff       	jmp    80104edc <alltraps>

801054e3 <vector14>:
.globl vector14
vector14:
  pushl $14
801054e3:	6a 0e                	push   $0xe
  jmp alltraps
801054e5:	e9 f2 f9 ff ff       	jmp    80104edc <alltraps>

801054ea <vector15>:
.globl vector15
vector15:
  pushl $0
801054ea:	6a 00                	push   $0x0
  pushl $15
801054ec:	6a 0f                	push   $0xf
  jmp alltraps
801054ee:	e9 e9 f9 ff ff       	jmp    80104edc <alltraps>

801054f3 <vector16>:
.globl vector16
vector16:
  pushl $0
801054f3:	6a 00                	push   $0x0
  pushl $16
801054f5:	6a 10                	push   $0x10
  jmp alltraps
801054f7:	e9 e0 f9 ff ff       	jmp    80104edc <alltraps>

801054fc <vector17>:
.globl vector17
vector17:
  pushl $17
801054fc:	6a 11                	push   $0x11
  jmp alltraps
801054fe:	e9 d9 f9 ff ff       	jmp    80104edc <alltraps>

80105503 <vector18>:
.globl vector18
vector18:
  pushl $0
80105503:	6a 00                	push   $0x0
  pushl $18
80105505:	6a 12                	push   $0x12
  jmp alltraps
80105507:	e9 d0 f9 ff ff       	jmp    80104edc <alltraps>

8010550c <vector19>:
.globl vector19
vector19:
  pushl $0
8010550c:	6a 00                	push   $0x0
  pushl $19
8010550e:	6a 13                	push   $0x13
  jmp alltraps
80105510:	e9 c7 f9 ff ff       	jmp    80104edc <alltraps>

80105515 <vector20>:
.globl vector20
vector20:
  pushl $0
80105515:	6a 00                	push   $0x0
  pushl $20
80105517:	6a 14                	push   $0x14
  jmp alltraps
80105519:	e9 be f9 ff ff       	jmp    80104edc <alltraps>

8010551e <vector21>:
.globl vector21
vector21:
  pushl $0
8010551e:	6a 00                	push   $0x0
  pushl $21
80105520:	6a 15                	push   $0x15
  jmp alltraps
80105522:	e9 b5 f9 ff ff       	jmp    80104edc <alltraps>

80105527 <vector22>:
.globl vector22
vector22:
  pushl $0
80105527:	6a 00                	push   $0x0
  pushl $22
80105529:	6a 16                	push   $0x16
  jmp alltraps
8010552b:	e9 ac f9 ff ff       	jmp    80104edc <alltraps>

80105530 <vector23>:
.globl vector23
vector23:
  pushl $0
80105530:	6a 00                	push   $0x0
  pushl $23
80105532:	6a 17                	push   $0x17
  jmp alltraps
80105534:	e9 a3 f9 ff ff       	jmp    80104edc <alltraps>

80105539 <vector24>:
.globl vector24
vector24:
  pushl $0
80105539:	6a 00                	push   $0x0
  pushl $24
8010553b:	6a 18                	push   $0x18
  jmp alltraps
8010553d:	e9 9a f9 ff ff       	jmp    80104edc <alltraps>

80105542 <vector25>:
.globl vector25
vector25:
  pushl $0
80105542:	6a 00                	push   $0x0
  pushl $25
80105544:	6a 19                	push   $0x19
  jmp alltraps
80105546:	e9 91 f9 ff ff       	jmp    80104edc <alltraps>

8010554b <vector26>:
.globl vector26
vector26:
  pushl $0
8010554b:	6a 00                	push   $0x0
  pushl $26
8010554d:	6a 1a                	push   $0x1a
  jmp alltraps
8010554f:	e9 88 f9 ff ff       	jmp    80104edc <alltraps>

80105554 <vector27>:
.globl vector27
vector27:
  pushl $0
80105554:	6a 00                	push   $0x0
  pushl $27
80105556:	6a 1b                	push   $0x1b
  jmp alltraps
80105558:	e9 7f f9 ff ff       	jmp    80104edc <alltraps>

8010555d <vector28>:
.globl vector28
vector28:
  pushl $0
8010555d:	6a 00                	push   $0x0
  pushl $28
8010555f:	6a 1c                	push   $0x1c
  jmp alltraps
80105561:	e9 76 f9 ff ff       	jmp    80104edc <alltraps>

80105566 <vector29>:
.globl vector29
vector29:
  pushl $0
80105566:	6a 00                	push   $0x0
  pushl $29
80105568:	6a 1d                	push   $0x1d
  jmp alltraps
8010556a:	e9 6d f9 ff ff       	jmp    80104edc <alltraps>

8010556f <vector30>:
.globl vector30
vector30:
  pushl $0
8010556f:	6a 00                	push   $0x0
  pushl $30
80105571:	6a 1e                	push   $0x1e
  jmp alltraps
80105573:	e9 64 f9 ff ff       	jmp    80104edc <alltraps>

80105578 <vector31>:
.globl vector31
vector31:
  pushl $0
80105578:	6a 00                	push   $0x0
  pushl $31
8010557a:	6a 1f                	push   $0x1f
  jmp alltraps
8010557c:	e9 5b f9 ff ff       	jmp    80104edc <alltraps>

80105581 <vector32>:
.globl vector32
vector32:
  pushl $0
80105581:	6a 00                	push   $0x0
  pushl $32
80105583:	6a 20                	push   $0x20
  jmp alltraps
80105585:	e9 52 f9 ff ff       	jmp    80104edc <alltraps>

8010558a <vector33>:
.globl vector33
vector33:
  pushl $0
8010558a:	6a 00                	push   $0x0
  pushl $33
8010558c:	6a 21                	push   $0x21
  jmp alltraps
8010558e:	e9 49 f9 ff ff       	jmp    80104edc <alltraps>

80105593 <vector34>:
.globl vector34
vector34:
  pushl $0
80105593:	6a 00                	push   $0x0
  pushl $34
80105595:	6a 22                	push   $0x22
  jmp alltraps
80105597:	e9 40 f9 ff ff       	jmp    80104edc <alltraps>

8010559c <vector35>:
.globl vector35
vector35:
  pushl $0
8010559c:	6a 00                	push   $0x0
  pushl $35
8010559e:	6a 23                	push   $0x23
  jmp alltraps
801055a0:	e9 37 f9 ff ff       	jmp    80104edc <alltraps>

801055a5 <vector36>:
.globl vector36
vector36:
  pushl $0
801055a5:	6a 00                	push   $0x0
  pushl $36
801055a7:	6a 24                	push   $0x24
  jmp alltraps
801055a9:	e9 2e f9 ff ff       	jmp    80104edc <alltraps>

801055ae <vector37>:
.globl vector37
vector37:
  pushl $0
801055ae:	6a 00                	push   $0x0
  pushl $37
801055b0:	6a 25                	push   $0x25
  jmp alltraps
801055b2:	e9 25 f9 ff ff       	jmp    80104edc <alltraps>

801055b7 <vector38>:
.globl vector38
vector38:
  pushl $0
801055b7:	6a 00                	push   $0x0
  pushl $38
801055b9:	6a 26                	push   $0x26
  jmp alltraps
801055bb:	e9 1c f9 ff ff       	jmp    80104edc <alltraps>

801055c0 <vector39>:
.globl vector39
vector39:
  pushl $0
801055c0:	6a 00                	push   $0x0
  pushl $39
801055c2:	6a 27                	push   $0x27
  jmp alltraps
801055c4:	e9 13 f9 ff ff       	jmp    80104edc <alltraps>

801055c9 <vector40>:
.globl vector40
vector40:
  pushl $0
801055c9:	6a 00                	push   $0x0
  pushl $40
801055cb:	6a 28                	push   $0x28
  jmp alltraps
801055cd:	e9 0a f9 ff ff       	jmp    80104edc <alltraps>

801055d2 <vector41>:
.globl vector41
vector41:
  pushl $0
801055d2:	6a 00                	push   $0x0
  pushl $41
801055d4:	6a 29                	push   $0x29
  jmp alltraps
801055d6:	e9 01 f9 ff ff       	jmp    80104edc <alltraps>

801055db <vector42>:
.globl vector42
vector42:
  pushl $0
801055db:	6a 00                	push   $0x0
  pushl $42
801055dd:	6a 2a                	push   $0x2a
  jmp alltraps
801055df:	e9 f8 f8 ff ff       	jmp    80104edc <alltraps>

801055e4 <vector43>:
.globl vector43
vector43:
  pushl $0
801055e4:	6a 00                	push   $0x0
  pushl $43
801055e6:	6a 2b                	push   $0x2b
  jmp alltraps
801055e8:	e9 ef f8 ff ff       	jmp    80104edc <alltraps>

801055ed <vector44>:
.globl vector44
vector44:
  pushl $0
801055ed:	6a 00                	push   $0x0
  pushl $44
801055ef:	6a 2c                	push   $0x2c
  jmp alltraps
801055f1:	e9 e6 f8 ff ff       	jmp    80104edc <alltraps>

801055f6 <vector45>:
.globl vector45
vector45:
  pushl $0
801055f6:	6a 00                	push   $0x0
  pushl $45
801055f8:	6a 2d                	push   $0x2d
  jmp alltraps
801055fa:	e9 dd f8 ff ff       	jmp    80104edc <alltraps>

801055ff <vector46>:
.globl vector46
vector46:
  pushl $0
801055ff:	6a 00                	push   $0x0
  pushl $46
80105601:	6a 2e                	push   $0x2e
  jmp alltraps
80105603:	e9 d4 f8 ff ff       	jmp    80104edc <alltraps>

80105608 <vector47>:
.globl vector47
vector47:
  pushl $0
80105608:	6a 00                	push   $0x0
  pushl $47
8010560a:	6a 2f                	push   $0x2f
  jmp alltraps
8010560c:	e9 cb f8 ff ff       	jmp    80104edc <alltraps>

80105611 <vector48>:
.globl vector48
vector48:
  pushl $0
80105611:	6a 00                	push   $0x0
  pushl $48
80105613:	6a 30                	push   $0x30
  jmp alltraps
80105615:	e9 c2 f8 ff ff       	jmp    80104edc <alltraps>

8010561a <vector49>:
.globl vector49
vector49:
  pushl $0
8010561a:	6a 00                	push   $0x0
  pushl $49
8010561c:	6a 31                	push   $0x31
  jmp alltraps
8010561e:	e9 b9 f8 ff ff       	jmp    80104edc <alltraps>

80105623 <vector50>:
.globl vector50
vector50:
  pushl $0
80105623:	6a 00                	push   $0x0
  pushl $50
80105625:	6a 32                	push   $0x32
  jmp alltraps
80105627:	e9 b0 f8 ff ff       	jmp    80104edc <alltraps>

8010562c <vector51>:
.globl vector51
vector51:
  pushl $0
8010562c:	6a 00                	push   $0x0
  pushl $51
8010562e:	6a 33                	push   $0x33
  jmp alltraps
80105630:	e9 a7 f8 ff ff       	jmp    80104edc <alltraps>

80105635 <vector52>:
.globl vector52
vector52:
  pushl $0
80105635:	6a 00                	push   $0x0
  pushl $52
80105637:	6a 34                	push   $0x34
  jmp alltraps
80105639:	e9 9e f8 ff ff       	jmp    80104edc <alltraps>

8010563e <vector53>:
.globl vector53
vector53:
  pushl $0
8010563e:	6a 00                	push   $0x0
  pushl $53
80105640:	6a 35                	push   $0x35
  jmp alltraps
80105642:	e9 95 f8 ff ff       	jmp    80104edc <alltraps>

80105647 <vector54>:
.globl vector54
vector54:
  pushl $0
80105647:	6a 00                	push   $0x0
  pushl $54
80105649:	6a 36                	push   $0x36
  jmp alltraps
8010564b:	e9 8c f8 ff ff       	jmp    80104edc <alltraps>

80105650 <vector55>:
.globl vector55
vector55:
  pushl $0
80105650:	6a 00                	push   $0x0
  pushl $55
80105652:	6a 37                	push   $0x37
  jmp alltraps
80105654:	e9 83 f8 ff ff       	jmp    80104edc <alltraps>

80105659 <vector56>:
.globl vector56
vector56:
  pushl $0
80105659:	6a 00                	push   $0x0
  pushl $56
8010565b:	6a 38                	push   $0x38
  jmp alltraps
8010565d:	e9 7a f8 ff ff       	jmp    80104edc <alltraps>

80105662 <vector57>:
.globl vector57
vector57:
  pushl $0
80105662:	6a 00                	push   $0x0
  pushl $57
80105664:	6a 39                	push   $0x39
  jmp alltraps
80105666:	e9 71 f8 ff ff       	jmp    80104edc <alltraps>

8010566b <vector58>:
.globl vector58
vector58:
  pushl $0
8010566b:	6a 00                	push   $0x0
  pushl $58
8010566d:	6a 3a                	push   $0x3a
  jmp alltraps
8010566f:	e9 68 f8 ff ff       	jmp    80104edc <alltraps>

80105674 <vector59>:
.globl vector59
vector59:
  pushl $0
80105674:	6a 00                	push   $0x0
  pushl $59
80105676:	6a 3b                	push   $0x3b
  jmp alltraps
80105678:	e9 5f f8 ff ff       	jmp    80104edc <alltraps>

8010567d <vector60>:
.globl vector60
vector60:
  pushl $0
8010567d:	6a 00                	push   $0x0
  pushl $60
8010567f:	6a 3c                	push   $0x3c
  jmp alltraps
80105681:	e9 56 f8 ff ff       	jmp    80104edc <alltraps>

80105686 <vector61>:
.globl vector61
vector61:
  pushl $0
80105686:	6a 00                	push   $0x0
  pushl $61
80105688:	6a 3d                	push   $0x3d
  jmp alltraps
8010568a:	e9 4d f8 ff ff       	jmp    80104edc <alltraps>

8010568f <vector62>:
.globl vector62
vector62:
  pushl $0
8010568f:	6a 00                	push   $0x0
  pushl $62
80105691:	6a 3e                	push   $0x3e
  jmp alltraps
80105693:	e9 44 f8 ff ff       	jmp    80104edc <alltraps>

80105698 <vector63>:
.globl vector63
vector63:
  pushl $0
80105698:	6a 00                	push   $0x0
  pushl $63
8010569a:	6a 3f                	push   $0x3f
  jmp alltraps
8010569c:	e9 3b f8 ff ff       	jmp    80104edc <alltraps>

801056a1 <vector64>:
.globl vector64
vector64:
  pushl $0
801056a1:	6a 00                	push   $0x0
  pushl $64
801056a3:	6a 40                	push   $0x40
  jmp alltraps
801056a5:	e9 32 f8 ff ff       	jmp    80104edc <alltraps>

801056aa <vector65>:
.globl vector65
vector65:
  pushl $0
801056aa:	6a 00                	push   $0x0
  pushl $65
801056ac:	6a 41                	push   $0x41
  jmp alltraps
801056ae:	e9 29 f8 ff ff       	jmp    80104edc <alltraps>

801056b3 <vector66>:
.globl vector66
vector66:
  pushl $0
801056b3:	6a 00                	push   $0x0
  pushl $66
801056b5:	6a 42                	push   $0x42
  jmp alltraps
801056b7:	e9 20 f8 ff ff       	jmp    80104edc <alltraps>

801056bc <vector67>:
.globl vector67
vector67:
  pushl $0
801056bc:	6a 00                	push   $0x0
  pushl $67
801056be:	6a 43                	push   $0x43
  jmp alltraps
801056c0:	e9 17 f8 ff ff       	jmp    80104edc <alltraps>

801056c5 <vector68>:
.globl vector68
vector68:
  pushl $0
801056c5:	6a 00                	push   $0x0
  pushl $68
801056c7:	6a 44                	push   $0x44
  jmp alltraps
801056c9:	e9 0e f8 ff ff       	jmp    80104edc <alltraps>

801056ce <vector69>:
.globl vector69
vector69:
  pushl $0
801056ce:	6a 00                	push   $0x0
  pushl $69
801056d0:	6a 45                	push   $0x45
  jmp alltraps
801056d2:	e9 05 f8 ff ff       	jmp    80104edc <alltraps>

801056d7 <vector70>:
.globl vector70
vector70:
  pushl $0
801056d7:	6a 00                	push   $0x0
  pushl $70
801056d9:	6a 46                	push   $0x46
  jmp alltraps
801056db:	e9 fc f7 ff ff       	jmp    80104edc <alltraps>

801056e0 <vector71>:
.globl vector71
vector71:
  pushl $0
801056e0:	6a 00                	push   $0x0
  pushl $71
801056e2:	6a 47                	push   $0x47
  jmp alltraps
801056e4:	e9 f3 f7 ff ff       	jmp    80104edc <alltraps>

801056e9 <vector72>:
.globl vector72
vector72:
  pushl $0
801056e9:	6a 00                	push   $0x0
  pushl $72
801056eb:	6a 48                	push   $0x48
  jmp alltraps
801056ed:	e9 ea f7 ff ff       	jmp    80104edc <alltraps>

801056f2 <vector73>:
.globl vector73
vector73:
  pushl $0
801056f2:	6a 00                	push   $0x0
  pushl $73
801056f4:	6a 49                	push   $0x49
  jmp alltraps
801056f6:	e9 e1 f7 ff ff       	jmp    80104edc <alltraps>

801056fb <vector74>:
.globl vector74
vector74:
  pushl $0
801056fb:	6a 00                	push   $0x0
  pushl $74
801056fd:	6a 4a                	push   $0x4a
  jmp alltraps
801056ff:	e9 d8 f7 ff ff       	jmp    80104edc <alltraps>

80105704 <vector75>:
.globl vector75
vector75:
  pushl $0
80105704:	6a 00                	push   $0x0
  pushl $75
80105706:	6a 4b                	push   $0x4b
  jmp alltraps
80105708:	e9 cf f7 ff ff       	jmp    80104edc <alltraps>

8010570d <vector76>:
.globl vector76
vector76:
  pushl $0
8010570d:	6a 00                	push   $0x0
  pushl $76
8010570f:	6a 4c                	push   $0x4c
  jmp alltraps
80105711:	e9 c6 f7 ff ff       	jmp    80104edc <alltraps>

80105716 <vector77>:
.globl vector77
vector77:
  pushl $0
80105716:	6a 00                	push   $0x0
  pushl $77
80105718:	6a 4d                	push   $0x4d
  jmp alltraps
8010571a:	e9 bd f7 ff ff       	jmp    80104edc <alltraps>

8010571f <vector78>:
.globl vector78
vector78:
  pushl $0
8010571f:	6a 00                	push   $0x0
  pushl $78
80105721:	6a 4e                	push   $0x4e
  jmp alltraps
80105723:	e9 b4 f7 ff ff       	jmp    80104edc <alltraps>

80105728 <vector79>:
.globl vector79
vector79:
  pushl $0
80105728:	6a 00                	push   $0x0
  pushl $79
8010572a:	6a 4f                	push   $0x4f
  jmp alltraps
8010572c:	e9 ab f7 ff ff       	jmp    80104edc <alltraps>

80105731 <vector80>:
.globl vector80
vector80:
  pushl $0
80105731:	6a 00                	push   $0x0
  pushl $80
80105733:	6a 50                	push   $0x50
  jmp alltraps
80105735:	e9 a2 f7 ff ff       	jmp    80104edc <alltraps>

8010573a <vector81>:
.globl vector81
vector81:
  pushl $0
8010573a:	6a 00                	push   $0x0
  pushl $81
8010573c:	6a 51                	push   $0x51
  jmp alltraps
8010573e:	e9 99 f7 ff ff       	jmp    80104edc <alltraps>

80105743 <vector82>:
.globl vector82
vector82:
  pushl $0
80105743:	6a 00                	push   $0x0
  pushl $82
80105745:	6a 52                	push   $0x52
  jmp alltraps
80105747:	e9 90 f7 ff ff       	jmp    80104edc <alltraps>

8010574c <vector83>:
.globl vector83
vector83:
  pushl $0
8010574c:	6a 00                	push   $0x0
  pushl $83
8010574e:	6a 53                	push   $0x53
  jmp alltraps
80105750:	e9 87 f7 ff ff       	jmp    80104edc <alltraps>

80105755 <vector84>:
.globl vector84
vector84:
  pushl $0
80105755:	6a 00                	push   $0x0
  pushl $84
80105757:	6a 54                	push   $0x54
  jmp alltraps
80105759:	e9 7e f7 ff ff       	jmp    80104edc <alltraps>

8010575e <vector85>:
.globl vector85
vector85:
  pushl $0
8010575e:	6a 00                	push   $0x0
  pushl $85
80105760:	6a 55                	push   $0x55
  jmp alltraps
80105762:	e9 75 f7 ff ff       	jmp    80104edc <alltraps>

80105767 <vector86>:
.globl vector86
vector86:
  pushl $0
80105767:	6a 00                	push   $0x0
  pushl $86
80105769:	6a 56                	push   $0x56
  jmp alltraps
8010576b:	e9 6c f7 ff ff       	jmp    80104edc <alltraps>

80105770 <vector87>:
.globl vector87
vector87:
  pushl $0
80105770:	6a 00                	push   $0x0
  pushl $87
80105772:	6a 57                	push   $0x57
  jmp alltraps
80105774:	e9 63 f7 ff ff       	jmp    80104edc <alltraps>

80105779 <vector88>:
.globl vector88
vector88:
  pushl $0
80105779:	6a 00                	push   $0x0
  pushl $88
8010577b:	6a 58                	push   $0x58
  jmp alltraps
8010577d:	e9 5a f7 ff ff       	jmp    80104edc <alltraps>

80105782 <vector89>:
.globl vector89
vector89:
  pushl $0
80105782:	6a 00                	push   $0x0
  pushl $89
80105784:	6a 59                	push   $0x59
  jmp alltraps
80105786:	e9 51 f7 ff ff       	jmp    80104edc <alltraps>

8010578b <vector90>:
.globl vector90
vector90:
  pushl $0
8010578b:	6a 00                	push   $0x0
  pushl $90
8010578d:	6a 5a                	push   $0x5a
  jmp alltraps
8010578f:	e9 48 f7 ff ff       	jmp    80104edc <alltraps>

80105794 <vector91>:
.globl vector91
vector91:
  pushl $0
80105794:	6a 00                	push   $0x0
  pushl $91
80105796:	6a 5b                	push   $0x5b
  jmp alltraps
80105798:	e9 3f f7 ff ff       	jmp    80104edc <alltraps>

8010579d <vector92>:
.globl vector92
vector92:
  pushl $0
8010579d:	6a 00                	push   $0x0
  pushl $92
8010579f:	6a 5c                	push   $0x5c
  jmp alltraps
801057a1:	e9 36 f7 ff ff       	jmp    80104edc <alltraps>

801057a6 <vector93>:
.globl vector93
vector93:
  pushl $0
801057a6:	6a 00                	push   $0x0
  pushl $93
801057a8:	6a 5d                	push   $0x5d
  jmp alltraps
801057aa:	e9 2d f7 ff ff       	jmp    80104edc <alltraps>

801057af <vector94>:
.globl vector94
vector94:
  pushl $0
801057af:	6a 00                	push   $0x0
  pushl $94
801057b1:	6a 5e                	push   $0x5e
  jmp alltraps
801057b3:	e9 24 f7 ff ff       	jmp    80104edc <alltraps>

801057b8 <vector95>:
.globl vector95
vector95:
  pushl $0
801057b8:	6a 00                	push   $0x0
  pushl $95
801057ba:	6a 5f                	push   $0x5f
  jmp alltraps
801057bc:	e9 1b f7 ff ff       	jmp    80104edc <alltraps>

801057c1 <vector96>:
.globl vector96
vector96:
  pushl $0
801057c1:	6a 00                	push   $0x0
  pushl $96
801057c3:	6a 60                	push   $0x60
  jmp alltraps
801057c5:	e9 12 f7 ff ff       	jmp    80104edc <alltraps>

801057ca <vector97>:
.globl vector97
vector97:
  pushl $0
801057ca:	6a 00                	push   $0x0
  pushl $97
801057cc:	6a 61                	push   $0x61
  jmp alltraps
801057ce:	e9 09 f7 ff ff       	jmp    80104edc <alltraps>

801057d3 <vector98>:
.globl vector98
vector98:
  pushl $0
801057d3:	6a 00                	push   $0x0
  pushl $98
801057d5:	6a 62                	push   $0x62
  jmp alltraps
801057d7:	e9 00 f7 ff ff       	jmp    80104edc <alltraps>

801057dc <vector99>:
.globl vector99
vector99:
  pushl $0
801057dc:	6a 00                	push   $0x0
  pushl $99
801057de:	6a 63                	push   $0x63
  jmp alltraps
801057e0:	e9 f7 f6 ff ff       	jmp    80104edc <alltraps>

801057e5 <vector100>:
.globl vector100
vector100:
  pushl $0
801057e5:	6a 00                	push   $0x0
  pushl $100
801057e7:	6a 64                	push   $0x64
  jmp alltraps
801057e9:	e9 ee f6 ff ff       	jmp    80104edc <alltraps>

801057ee <vector101>:
.globl vector101
vector101:
  pushl $0
801057ee:	6a 00                	push   $0x0
  pushl $101
801057f0:	6a 65                	push   $0x65
  jmp alltraps
801057f2:	e9 e5 f6 ff ff       	jmp    80104edc <alltraps>

801057f7 <vector102>:
.globl vector102
vector102:
  pushl $0
801057f7:	6a 00                	push   $0x0
  pushl $102
801057f9:	6a 66                	push   $0x66
  jmp alltraps
801057fb:	e9 dc f6 ff ff       	jmp    80104edc <alltraps>

80105800 <vector103>:
.globl vector103
vector103:
  pushl $0
80105800:	6a 00                	push   $0x0
  pushl $103
80105802:	6a 67                	push   $0x67
  jmp alltraps
80105804:	e9 d3 f6 ff ff       	jmp    80104edc <alltraps>

80105809 <vector104>:
.globl vector104
vector104:
  pushl $0
80105809:	6a 00                	push   $0x0
  pushl $104
8010580b:	6a 68                	push   $0x68
  jmp alltraps
8010580d:	e9 ca f6 ff ff       	jmp    80104edc <alltraps>

80105812 <vector105>:
.globl vector105
vector105:
  pushl $0
80105812:	6a 00                	push   $0x0
  pushl $105
80105814:	6a 69                	push   $0x69
  jmp alltraps
80105816:	e9 c1 f6 ff ff       	jmp    80104edc <alltraps>

8010581b <vector106>:
.globl vector106
vector106:
  pushl $0
8010581b:	6a 00                	push   $0x0
  pushl $106
8010581d:	6a 6a                	push   $0x6a
  jmp alltraps
8010581f:	e9 b8 f6 ff ff       	jmp    80104edc <alltraps>

80105824 <vector107>:
.globl vector107
vector107:
  pushl $0
80105824:	6a 00                	push   $0x0
  pushl $107
80105826:	6a 6b                	push   $0x6b
  jmp alltraps
80105828:	e9 af f6 ff ff       	jmp    80104edc <alltraps>

8010582d <vector108>:
.globl vector108
vector108:
  pushl $0
8010582d:	6a 00                	push   $0x0
  pushl $108
8010582f:	6a 6c                	push   $0x6c
  jmp alltraps
80105831:	e9 a6 f6 ff ff       	jmp    80104edc <alltraps>

80105836 <vector109>:
.globl vector109
vector109:
  pushl $0
80105836:	6a 00                	push   $0x0
  pushl $109
80105838:	6a 6d                	push   $0x6d
  jmp alltraps
8010583a:	e9 9d f6 ff ff       	jmp    80104edc <alltraps>

8010583f <vector110>:
.globl vector110
vector110:
  pushl $0
8010583f:	6a 00                	push   $0x0
  pushl $110
80105841:	6a 6e                	push   $0x6e
  jmp alltraps
80105843:	e9 94 f6 ff ff       	jmp    80104edc <alltraps>

80105848 <vector111>:
.globl vector111
vector111:
  pushl $0
80105848:	6a 00                	push   $0x0
  pushl $111
8010584a:	6a 6f                	push   $0x6f
  jmp alltraps
8010584c:	e9 8b f6 ff ff       	jmp    80104edc <alltraps>

80105851 <vector112>:
.globl vector112
vector112:
  pushl $0
80105851:	6a 00                	push   $0x0
  pushl $112
80105853:	6a 70                	push   $0x70
  jmp alltraps
80105855:	e9 82 f6 ff ff       	jmp    80104edc <alltraps>

8010585a <vector113>:
.globl vector113
vector113:
  pushl $0
8010585a:	6a 00                	push   $0x0
  pushl $113
8010585c:	6a 71                	push   $0x71
  jmp alltraps
8010585e:	e9 79 f6 ff ff       	jmp    80104edc <alltraps>

80105863 <vector114>:
.globl vector114
vector114:
  pushl $0
80105863:	6a 00                	push   $0x0
  pushl $114
80105865:	6a 72                	push   $0x72
  jmp alltraps
80105867:	e9 70 f6 ff ff       	jmp    80104edc <alltraps>

8010586c <vector115>:
.globl vector115
vector115:
  pushl $0
8010586c:	6a 00                	push   $0x0
  pushl $115
8010586e:	6a 73                	push   $0x73
  jmp alltraps
80105870:	e9 67 f6 ff ff       	jmp    80104edc <alltraps>

80105875 <vector116>:
.globl vector116
vector116:
  pushl $0
80105875:	6a 00                	push   $0x0
  pushl $116
80105877:	6a 74                	push   $0x74
  jmp alltraps
80105879:	e9 5e f6 ff ff       	jmp    80104edc <alltraps>

8010587e <vector117>:
.globl vector117
vector117:
  pushl $0
8010587e:	6a 00                	push   $0x0
  pushl $117
80105880:	6a 75                	push   $0x75
  jmp alltraps
80105882:	e9 55 f6 ff ff       	jmp    80104edc <alltraps>

80105887 <vector118>:
.globl vector118
vector118:
  pushl $0
80105887:	6a 00                	push   $0x0
  pushl $118
80105889:	6a 76                	push   $0x76
  jmp alltraps
8010588b:	e9 4c f6 ff ff       	jmp    80104edc <alltraps>

80105890 <vector119>:
.globl vector119
vector119:
  pushl $0
80105890:	6a 00                	push   $0x0
  pushl $119
80105892:	6a 77                	push   $0x77
  jmp alltraps
80105894:	e9 43 f6 ff ff       	jmp    80104edc <alltraps>

80105899 <vector120>:
.globl vector120
vector120:
  pushl $0
80105899:	6a 00                	push   $0x0
  pushl $120
8010589b:	6a 78                	push   $0x78
  jmp alltraps
8010589d:	e9 3a f6 ff ff       	jmp    80104edc <alltraps>

801058a2 <vector121>:
.globl vector121
vector121:
  pushl $0
801058a2:	6a 00                	push   $0x0
  pushl $121
801058a4:	6a 79                	push   $0x79
  jmp alltraps
801058a6:	e9 31 f6 ff ff       	jmp    80104edc <alltraps>

801058ab <vector122>:
.globl vector122
vector122:
  pushl $0
801058ab:	6a 00                	push   $0x0
  pushl $122
801058ad:	6a 7a                	push   $0x7a
  jmp alltraps
801058af:	e9 28 f6 ff ff       	jmp    80104edc <alltraps>

801058b4 <vector123>:
.globl vector123
vector123:
  pushl $0
801058b4:	6a 00                	push   $0x0
  pushl $123
801058b6:	6a 7b                	push   $0x7b
  jmp alltraps
801058b8:	e9 1f f6 ff ff       	jmp    80104edc <alltraps>

801058bd <vector124>:
.globl vector124
vector124:
  pushl $0
801058bd:	6a 00                	push   $0x0
  pushl $124
801058bf:	6a 7c                	push   $0x7c
  jmp alltraps
801058c1:	e9 16 f6 ff ff       	jmp    80104edc <alltraps>

801058c6 <vector125>:
.globl vector125
vector125:
  pushl $0
801058c6:	6a 00                	push   $0x0
  pushl $125
801058c8:	6a 7d                	push   $0x7d
  jmp alltraps
801058ca:	e9 0d f6 ff ff       	jmp    80104edc <alltraps>

801058cf <vector126>:
.globl vector126
vector126:
  pushl $0
801058cf:	6a 00                	push   $0x0
  pushl $126
801058d1:	6a 7e                	push   $0x7e
  jmp alltraps
801058d3:	e9 04 f6 ff ff       	jmp    80104edc <alltraps>

801058d8 <vector127>:
.globl vector127
vector127:
  pushl $0
801058d8:	6a 00                	push   $0x0
  pushl $127
801058da:	6a 7f                	push   $0x7f
  jmp alltraps
801058dc:	e9 fb f5 ff ff       	jmp    80104edc <alltraps>

801058e1 <vector128>:
.globl vector128
vector128:
  pushl $0
801058e1:	6a 00                	push   $0x0
  pushl $128
801058e3:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801058e8:	e9 ef f5 ff ff       	jmp    80104edc <alltraps>

801058ed <vector129>:
.globl vector129
vector129:
  pushl $0
801058ed:	6a 00                	push   $0x0
  pushl $129
801058ef:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801058f4:	e9 e3 f5 ff ff       	jmp    80104edc <alltraps>

801058f9 <vector130>:
.globl vector130
vector130:
  pushl $0
801058f9:	6a 00                	push   $0x0
  pushl $130
801058fb:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105900:	e9 d7 f5 ff ff       	jmp    80104edc <alltraps>

80105905 <vector131>:
.globl vector131
vector131:
  pushl $0
80105905:	6a 00                	push   $0x0
  pushl $131
80105907:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010590c:	e9 cb f5 ff ff       	jmp    80104edc <alltraps>

80105911 <vector132>:
.globl vector132
vector132:
  pushl $0
80105911:	6a 00                	push   $0x0
  pushl $132
80105913:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105918:	e9 bf f5 ff ff       	jmp    80104edc <alltraps>

8010591d <vector133>:
.globl vector133
vector133:
  pushl $0
8010591d:	6a 00                	push   $0x0
  pushl $133
8010591f:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105924:	e9 b3 f5 ff ff       	jmp    80104edc <alltraps>

80105929 <vector134>:
.globl vector134
vector134:
  pushl $0
80105929:	6a 00                	push   $0x0
  pushl $134
8010592b:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105930:	e9 a7 f5 ff ff       	jmp    80104edc <alltraps>

80105935 <vector135>:
.globl vector135
vector135:
  pushl $0
80105935:	6a 00                	push   $0x0
  pushl $135
80105937:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010593c:	e9 9b f5 ff ff       	jmp    80104edc <alltraps>

80105941 <vector136>:
.globl vector136
vector136:
  pushl $0
80105941:	6a 00                	push   $0x0
  pushl $136
80105943:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105948:	e9 8f f5 ff ff       	jmp    80104edc <alltraps>

8010594d <vector137>:
.globl vector137
vector137:
  pushl $0
8010594d:	6a 00                	push   $0x0
  pushl $137
8010594f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105954:	e9 83 f5 ff ff       	jmp    80104edc <alltraps>

80105959 <vector138>:
.globl vector138
vector138:
  pushl $0
80105959:	6a 00                	push   $0x0
  pushl $138
8010595b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105960:	e9 77 f5 ff ff       	jmp    80104edc <alltraps>

80105965 <vector139>:
.globl vector139
vector139:
  pushl $0
80105965:	6a 00                	push   $0x0
  pushl $139
80105967:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010596c:	e9 6b f5 ff ff       	jmp    80104edc <alltraps>

80105971 <vector140>:
.globl vector140
vector140:
  pushl $0
80105971:	6a 00                	push   $0x0
  pushl $140
80105973:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105978:	e9 5f f5 ff ff       	jmp    80104edc <alltraps>

8010597d <vector141>:
.globl vector141
vector141:
  pushl $0
8010597d:	6a 00                	push   $0x0
  pushl $141
8010597f:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105984:	e9 53 f5 ff ff       	jmp    80104edc <alltraps>

80105989 <vector142>:
.globl vector142
vector142:
  pushl $0
80105989:	6a 00                	push   $0x0
  pushl $142
8010598b:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105990:	e9 47 f5 ff ff       	jmp    80104edc <alltraps>

80105995 <vector143>:
.globl vector143
vector143:
  pushl $0
80105995:	6a 00                	push   $0x0
  pushl $143
80105997:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010599c:	e9 3b f5 ff ff       	jmp    80104edc <alltraps>

801059a1 <vector144>:
.globl vector144
vector144:
  pushl $0
801059a1:	6a 00                	push   $0x0
  pushl $144
801059a3:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801059a8:	e9 2f f5 ff ff       	jmp    80104edc <alltraps>

801059ad <vector145>:
.globl vector145
vector145:
  pushl $0
801059ad:	6a 00                	push   $0x0
  pushl $145
801059af:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801059b4:	e9 23 f5 ff ff       	jmp    80104edc <alltraps>

801059b9 <vector146>:
.globl vector146
vector146:
  pushl $0
801059b9:	6a 00                	push   $0x0
  pushl $146
801059bb:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801059c0:	e9 17 f5 ff ff       	jmp    80104edc <alltraps>

801059c5 <vector147>:
.globl vector147
vector147:
  pushl $0
801059c5:	6a 00                	push   $0x0
  pushl $147
801059c7:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801059cc:	e9 0b f5 ff ff       	jmp    80104edc <alltraps>

801059d1 <vector148>:
.globl vector148
vector148:
  pushl $0
801059d1:	6a 00                	push   $0x0
  pushl $148
801059d3:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801059d8:	e9 ff f4 ff ff       	jmp    80104edc <alltraps>

801059dd <vector149>:
.globl vector149
vector149:
  pushl $0
801059dd:	6a 00                	push   $0x0
  pushl $149
801059df:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801059e4:	e9 f3 f4 ff ff       	jmp    80104edc <alltraps>

801059e9 <vector150>:
.globl vector150
vector150:
  pushl $0
801059e9:	6a 00                	push   $0x0
  pushl $150
801059eb:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801059f0:	e9 e7 f4 ff ff       	jmp    80104edc <alltraps>

801059f5 <vector151>:
.globl vector151
vector151:
  pushl $0
801059f5:	6a 00                	push   $0x0
  pushl $151
801059f7:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801059fc:	e9 db f4 ff ff       	jmp    80104edc <alltraps>

80105a01 <vector152>:
.globl vector152
vector152:
  pushl $0
80105a01:	6a 00                	push   $0x0
  pushl $152
80105a03:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105a08:	e9 cf f4 ff ff       	jmp    80104edc <alltraps>

80105a0d <vector153>:
.globl vector153
vector153:
  pushl $0
80105a0d:	6a 00                	push   $0x0
  pushl $153
80105a0f:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105a14:	e9 c3 f4 ff ff       	jmp    80104edc <alltraps>

80105a19 <vector154>:
.globl vector154
vector154:
  pushl $0
80105a19:	6a 00                	push   $0x0
  pushl $154
80105a1b:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105a20:	e9 b7 f4 ff ff       	jmp    80104edc <alltraps>

80105a25 <vector155>:
.globl vector155
vector155:
  pushl $0
80105a25:	6a 00                	push   $0x0
  pushl $155
80105a27:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105a2c:	e9 ab f4 ff ff       	jmp    80104edc <alltraps>

80105a31 <vector156>:
.globl vector156
vector156:
  pushl $0
80105a31:	6a 00                	push   $0x0
  pushl $156
80105a33:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105a38:	e9 9f f4 ff ff       	jmp    80104edc <alltraps>

80105a3d <vector157>:
.globl vector157
vector157:
  pushl $0
80105a3d:	6a 00                	push   $0x0
  pushl $157
80105a3f:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105a44:	e9 93 f4 ff ff       	jmp    80104edc <alltraps>

80105a49 <vector158>:
.globl vector158
vector158:
  pushl $0
80105a49:	6a 00                	push   $0x0
  pushl $158
80105a4b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105a50:	e9 87 f4 ff ff       	jmp    80104edc <alltraps>

80105a55 <vector159>:
.globl vector159
vector159:
  pushl $0
80105a55:	6a 00                	push   $0x0
  pushl $159
80105a57:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105a5c:	e9 7b f4 ff ff       	jmp    80104edc <alltraps>

80105a61 <vector160>:
.globl vector160
vector160:
  pushl $0
80105a61:	6a 00                	push   $0x0
  pushl $160
80105a63:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105a68:	e9 6f f4 ff ff       	jmp    80104edc <alltraps>

80105a6d <vector161>:
.globl vector161
vector161:
  pushl $0
80105a6d:	6a 00                	push   $0x0
  pushl $161
80105a6f:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105a74:	e9 63 f4 ff ff       	jmp    80104edc <alltraps>

80105a79 <vector162>:
.globl vector162
vector162:
  pushl $0
80105a79:	6a 00                	push   $0x0
  pushl $162
80105a7b:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105a80:	e9 57 f4 ff ff       	jmp    80104edc <alltraps>

80105a85 <vector163>:
.globl vector163
vector163:
  pushl $0
80105a85:	6a 00                	push   $0x0
  pushl $163
80105a87:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105a8c:	e9 4b f4 ff ff       	jmp    80104edc <alltraps>

80105a91 <vector164>:
.globl vector164
vector164:
  pushl $0
80105a91:	6a 00                	push   $0x0
  pushl $164
80105a93:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105a98:	e9 3f f4 ff ff       	jmp    80104edc <alltraps>

80105a9d <vector165>:
.globl vector165
vector165:
  pushl $0
80105a9d:	6a 00                	push   $0x0
  pushl $165
80105a9f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105aa4:	e9 33 f4 ff ff       	jmp    80104edc <alltraps>

80105aa9 <vector166>:
.globl vector166
vector166:
  pushl $0
80105aa9:	6a 00                	push   $0x0
  pushl $166
80105aab:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105ab0:	e9 27 f4 ff ff       	jmp    80104edc <alltraps>

80105ab5 <vector167>:
.globl vector167
vector167:
  pushl $0
80105ab5:	6a 00                	push   $0x0
  pushl $167
80105ab7:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105abc:	e9 1b f4 ff ff       	jmp    80104edc <alltraps>

80105ac1 <vector168>:
.globl vector168
vector168:
  pushl $0
80105ac1:	6a 00                	push   $0x0
  pushl $168
80105ac3:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105ac8:	e9 0f f4 ff ff       	jmp    80104edc <alltraps>

80105acd <vector169>:
.globl vector169
vector169:
  pushl $0
80105acd:	6a 00                	push   $0x0
  pushl $169
80105acf:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105ad4:	e9 03 f4 ff ff       	jmp    80104edc <alltraps>

80105ad9 <vector170>:
.globl vector170
vector170:
  pushl $0
80105ad9:	6a 00                	push   $0x0
  pushl $170
80105adb:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105ae0:	e9 f7 f3 ff ff       	jmp    80104edc <alltraps>

80105ae5 <vector171>:
.globl vector171
vector171:
  pushl $0
80105ae5:	6a 00                	push   $0x0
  pushl $171
80105ae7:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105aec:	e9 eb f3 ff ff       	jmp    80104edc <alltraps>

80105af1 <vector172>:
.globl vector172
vector172:
  pushl $0
80105af1:	6a 00                	push   $0x0
  pushl $172
80105af3:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105af8:	e9 df f3 ff ff       	jmp    80104edc <alltraps>

80105afd <vector173>:
.globl vector173
vector173:
  pushl $0
80105afd:	6a 00                	push   $0x0
  pushl $173
80105aff:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105b04:	e9 d3 f3 ff ff       	jmp    80104edc <alltraps>

80105b09 <vector174>:
.globl vector174
vector174:
  pushl $0
80105b09:	6a 00                	push   $0x0
  pushl $174
80105b0b:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105b10:	e9 c7 f3 ff ff       	jmp    80104edc <alltraps>

80105b15 <vector175>:
.globl vector175
vector175:
  pushl $0
80105b15:	6a 00                	push   $0x0
  pushl $175
80105b17:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105b1c:	e9 bb f3 ff ff       	jmp    80104edc <alltraps>

80105b21 <vector176>:
.globl vector176
vector176:
  pushl $0
80105b21:	6a 00                	push   $0x0
  pushl $176
80105b23:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105b28:	e9 af f3 ff ff       	jmp    80104edc <alltraps>

80105b2d <vector177>:
.globl vector177
vector177:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $177
80105b2f:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105b34:	e9 a3 f3 ff ff       	jmp    80104edc <alltraps>

80105b39 <vector178>:
.globl vector178
vector178:
  pushl $0
80105b39:	6a 00                	push   $0x0
  pushl $178
80105b3b:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105b40:	e9 97 f3 ff ff       	jmp    80104edc <alltraps>

80105b45 <vector179>:
.globl vector179
vector179:
  pushl $0
80105b45:	6a 00                	push   $0x0
  pushl $179
80105b47:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105b4c:	e9 8b f3 ff ff       	jmp    80104edc <alltraps>

80105b51 <vector180>:
.globl vector180
vector180:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $180
80105b53:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105b58:	e9 7f f3 ff ff       	jmp    80104edc <alltraps>

80105b5d <vector181>:
.globl vector181
vector181:
  pushl $0
80105b5d:	6a 00                	push   $0x0
  pushl $181
80105b5f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105b64:	e9 73 f3 ff ff       	jmp    80104edc <alltraps>

80105b69 <vector182>:
.globl vector182
vector182:
  pushl $0
80105b69:	6a 00                	push   $0x0
  pushl $182
80105b6b:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105b70:	e9 67 f3 ff ff       	jmp    80104edc <alltraps>

80105b75 <vector183>:
.globl vector183
vector183:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $183
80105b77:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105b7c:	e9 5b f3 ff ff       	jmp    80104edc <alltraps>

80105b81 <vector184>:
.globl vector184
vector184:
  pushl $0
80105b81:	6a 00                	push   $0x0
  pushl $184
80105b83:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105b88:	e9 4f f3 ff ff       	jmp    80104edc <alltraps>

80105b8d <vector185>:
.globl vector185
vector185:
  pushl $0
80105b8d:	6a 00                	push   $0x0
  pushl $185
80105b8f:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105b94:	e9 43 f3 ff ff       	jmp    80104edc <alltraps>

80105b99 <vector186>:
.globl vector186
vector186:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $186
80105b9b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105ba0:	e9 37 f3 ff ff       	jmp    80104edc <alltraps>

80105ba5 <vector187>:
.globl vector187
vector187:
  pushl $0
80105ba5:	6a 00                	push   $0x0
  pushl $187
80105ba7:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105bac:	e9 2b f3 ff ff       	jmp    80104edc <alltraps>

80105bb1 <vector188>:
.globl vector188
vector188:
  pushl $0
80105bb1:	6a 00                	push   $0x0
  pushl $188
80105bb3:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105bb8:	e9 1f f3 ff ff       	jmp    80104edc <alltraps>

80105bbd <vector189>:
.globl vector189
vector189:
  pushl $0
80105bbd:	6a 00                	push   $0x0
  pushl $189
80105bbf:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105bc4:	e9 13 f3 ff ff       	jmp    80104edc <alltraps>

80105bc9 <vector190>:
.globl vector190
vector190:
  pushl $0
80105bc9:	6a 00                	push   $0x0
  pushl $190
80105bcb:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105bd0:	e9 07 f3 ff ff       	jmp    80104edc <alltraps>

80105bd5 <vector191>:
.globl vector191
vector191:
  pushl $0
80105bd5:	6a 00                	push   $0x0
  pushl $191
80105bd7:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105bdc:	e9 fb f2 ff ff       	jmp    80104edc <alltraps>

80105be1 <vector192>:
.globl vector192
vector192:
  pushl $0
80105be1:	6a 00                	push   $0x0
  pushl $192
80105be3:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105be8:	e9 ef f2 ff ff       	jmp    80104edc <alltraps>

80105bed <vector193>:
.globl vector193
vector193:
  pushl $0
80105bed:	6a 00                	push   $0x0
  pushl $193
80105bef:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105bf4:	e9 e3 f2 ff ff       	jmp    80104edc <alltraps>

80105bf9 <vector194>:
.globl vector194
vector194:
  pushl $0
80105bf9:	6a 00                	push   $0x0
  pushl $194
80105bfb:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105c00:	e9 d7 f2 ff ff       	jmp    80104edc <alltraps>

80105c05 <vector195>:
.globl vector195
vector195:
  pushl $0
80105c05:	6a 00                	push   $0x0
  pushl $195
80105c07:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105c0c:	e9 cb f2 ff ff       	jmp    80104edc <alltraps>

80105c11 <vector196>:
.globl vector196
vector196:
  pushl $0
80105c11:	6a 00                	push   $0x0
  pushl $196
80105c13:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105c18:	e9 bf f2 ff ff       	jmp    80104edc <alltraps>

80105c1d <vector197>:
.globl vector197
vector197:
  pushl $0
80105c1d:	6a 00                	push   $0x0
  pushl $197
80105c1f:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105c24:	e9 b3 f2 ff ff       	jmp    80104edc <alltraps>

80105c29 <vector198>:
.globl vector198
vector198:
  pushl $0
80105c29:	6a 00                	push   $0x0
  pushl $198
80105c2b:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105c30:	e9 a7 f2 ff ff       	jmp    80104edc <alltraps>

80105c35 <vector199>:
.globl vector199
vector199:
  pushl $0
80105c35:	6a 00                	push   $0x0
  pushl $199
80105c37:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105c3c:	e9 9b f2 ff ff       	jmp    80104edc <alltraps>

80105c41 <vector200>:
.globl vector200
vector200:
  pushl $0
80105c41:	6a 00                	push   $0x0
  pushl $200
80105c43:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105c48:	e9 8f f2 ff ff       	jmp    80104edc <alltraps>

80105c4d <vector201>:
.globl vector201
vector201:
  pushl $0
80105c4d:	6a 00                	push   $0x0
  pushl $201
80105c4f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105c54:	e9 83 f2 ff ff       	jmp    80104edc <alltraps>

80105c59 <vector202>:
.globl vector202
vector202:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $202
80105c5b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105c60:	e9 77 f2 ff ff       	jmp    80104edc <alltraps>

80105c65 <vector203>:
.globl vector203
vector203:
  pushl $0
80105c65:	6a 00                	push   $0x0
  pushl $203
80105c67:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105c6c:	e9 6b f2 ff ff       	jmp    80104edc <alltraps>

80105c71 <vector204>:
.globl vector204
vector204:
  pushl $0
80105c71:	6a 00                	push   $0x0
  pushl $204
80105c73:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105c78:	e9 5f f2 ff ff       	jmp    80104edc <alltraps>

80105c7d <vector205>:
.globl vector205
vector205:
  pushl $0
80105c7d:	6a 00                	push   $0x0
  pushl $205
80105c7f:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105c84:	e9 53 f2 ff ff       	jmp    80104edc <alltraps>

80105c89 <vector206>:
.globl vector206
vector206:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $206
80105c8b:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105c90:	e9 47 f2 ff ff       	jmp    80104edc <alltraps>

80105c95 <vector207>:
.globl vector207
vector207:
  pushl $0
80105c95:	6a 00                	push   $0x0
  pushl $207
80105c97:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105c9c:	e9 3b f2 ff ff       	jmp    80104edc <alltraps>

80105ca1 <vector208>:
.globl vector208
vector208:
  pushl $0
80105ca1:	6a 00                	push   $0x0
  pushl $208
80105ca3:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105ca8:	e9 2f f2 ff ff       	jmp    80104edc <alltraps>

80105cad <vector209>:
.globl vector209
vector209:
  pushl $0
80105cad:	6a 00                	push   $0x0
  pushl $209
80105caf:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105cb4:	e9 23 f2 ff ff       	jmp    80104edc <alltraps>

80105cb9 <vector210>:
.globl vector210
vector210:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $210
80105cbb:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105cc0:	e9 17 f2 ff ff       	jmp    80104edc <alltraps>

80105cc5 <vector211>:
.globl vector211
vector211:
  pushl $0
80105cc5:	6a 00                	push   $0x0
  pushl $211
80105cc7:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105ccc:	e9 0b f2 ff ff       	jmp    80104edc <alltraps>

80105cd1 <vector212>:
.globl vector212
vector212:
  pushl $0
80105cd1:	6a 00                	push   $0x0
  pushl $212
80105cd3:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105cd8:	e9 ff f1 ff ff       	jmp    80104edc <alltraps>

80105cdd <vector213>:
.globl vector213
vector213:
  pushl $0
80105cdd:	6a 00                	push   $0x0
  pushl $213
80105cdf:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105ce4:	e9 f3 f1 ff ff       	jmp    80104edc <alltraps>

80105ce9 <vector214>:
.globl vector214
vector214:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $214
80105ceb:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105cf0:	e9 e7 f1 ff ff       	jmp    80104edc <alltraps>

80105cf5 <vector215>:
.globl vector215
vector215:
  pushl $0
80105cf5:	6a 00                	push   $0x0
  pushl $215
80105cf7:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105cfc:	e9 db f1 ff ff       	jmp    80104edc <alltraps>

80105d01 <vector216>:
.globl vector216
vector216:
  pushl $0
80105d01:	6a 00                	push   $0x0
  pushl $216
80105d03:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105d08:	e9 cf f1 ff ff       	jmp    80104edc <alltraps>

80105d0d <vector217>:
.globl vector217
vector217:
  pushl $0
80105d0d:	6a 00                	push   $0x0
  pushl $217
80105d0f:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105d14:	e9 c3 f1 ff ff       	jmp    80104edc <alltraps>

80105d19 <vector218>:
.globl vector218
vector218:
  pushl $0
80105d19:	6a 00                	push   $0x0
  pushl $218
80105d1b:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105d20:	e9 b7 f1 ff ff       	jmp    80104edc <alltraps>

80105d25 <vector219>:
.globl vector219
vector219:
  pushl $0
80105d25:	6a 00                	push   $0x0
  pushl $219
80105d27:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105d2c:	e9 ab f1 ff ff       	jmp    80104edc <alltraps>

80105d31 <vector220>:
.globl vector220
vector220:
  pushl $0
80105d31:	6a 00                	push   $0x0
  pushl $220
80105d33:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105d38:	e9 9f f1 ff ff       	jmp    80104edc <alltraps>

80105d3d <vector221>:
.globl vector221
vector221:
  pushl $0
80105d3d:	6a 00                	push   $0x0
  pushl $221
80105d3f:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105d44:	e9 93 f1 ff ff       	jmp    80104edc <alltraps>

80105d49 <vector222>:
.globl vector222
vector222:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $222
80105d4b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105d50:	e9 87 f1 ff ff       	jmp    80104edc <alltraps>

80105d55 <vector223>:
.globl vector223
vector223:
  pushl $0
80105d55:	6a 00                	push   $0x0
  pushl $223
80105d57:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105d5c:	e9 7b f1 ff ff       	jmp    80104edc <alltraps>

80105d61 <vector224>:
.globl vector224
vector224:
  pushl $0
80105d61:	6a 00                	push   $0x0
  pushl $224
80105d63:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105d68:	e9 6f f1 ff ff       	jmp    80104edc <alltraps>

80105d6d <vector225>:
.globl vector225
vector225:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $225
80105d6f:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105d74:	e9 63 f1 ff ff       	jmp    80104edc <alltraps>

80105d79 <vector226>:
.globl vector226
vector226:
  pushl $0
80105d79:	6a 00                	push   $0x0
  pushl $226
80105d7b:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105d80:	e9 57 f1 ff ff       	jmp    80104edc <alltraps>

80105d85 <vector227>:
.globl vector227
vector227:
  pushl $0
80105d85:	6a 00                	push   $0x0
  pushl $227
80105d87:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105d8c:	e9 4b f1 ff ff       	jmp    80104edc <alltraps>

80105d91 <vector228>:
.globl vector228
vector228:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $228
80105d93:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105d98:	e9 3f f1 ff ff       	jmp    80104edc <alltraps>

80105d9d <vector229>:
.globl vector229
vector229:
  pushl $0
80105d9d:	6a 00                	push   $0x0
  pushl $229
80105d9f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105da4:	e9 33 f1 ff ff       	jmp    80104edc <alltraps>

80105da9 <vector230>:
.globl vector230
vector230:
  pushl $0
80105da9:	6a 00                	push   $0x0
  pushl $230
80105dab:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105db0:	e9 27 f1 ff ff       	jmp    80104edc <alltraps>

80105db5 <vector231>:
.globl vector231
vector231:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $231
80105db7:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105dbc:	e9 1b f1 ff ff       	jmp    80104edc <alltraps>

80105dc1 <vector232>:
.globl vector232
vector232:
  pushl $0
80105dc1:	6a 00                	push   $0x0
  pushl $232
80105dc3:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105dc8:	e9 0f f1 ff ff       	jmp    80104edc <alltraps>

80105dcd <vector233>:
.globl vector233
vector233:
  pushl $0
80105dcd:	6a 00                	push   $0x0
  pushl $233
80105dcf:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105dd4:	e9 03 f1 ff ff       	jmp    80104edc <alltraps>

80105dd9 <vector234>:
.globl vector234
vector234:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $234
80105ddb:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105de0:	e9 f7 f0 ff ff       	jmp    80104edc <alltraps>

80105de5 <vector235>:
.globl vector235
vector235:
  pushl $0
80105de5:	6a 00                	push   $0x0
  pushl $235
80105de7:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105dec:	e9 eb f0 ff ff       	jmp    80104edc <alltraps>

80105df1 <vector236>:
.globl vector236
vector236:
  pushl $0
80105df1:	6a 00                	push   $0x0
  pushl $236
80105df3:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105df8:	e9 df f0 ff ff       	jmp    80104edc <alltraps>

80105dfd <vector237>:
.globl vector237
vector237:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $237
80105dff:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105e04:	e9 d3 f0 ff ff       	jmp    80104edc <alltraps>

80105e09 <vector238>:
.globl vector238
vector238:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $238
80105e0b:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105e10:	e9 c7 f0 ff ff       	jmp    80104edc <alltraps>

80105e15 <vector239>:
.globl vector239
vector239:
  pushl $0
80105e15:	6a 00                	push   $0x0
  pushl $239
80105e17:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105e1c:	e9 bb f0 ff ff       	jmp    80104edc <alltraps>

80105e21 <vector240>:
.globl vector240
vector240:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $240
80105e23:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105e28:	e9 af f0 ff ff       	jmp    80104edc <alltraps>

80105e2d <vector241>:
.globl vector241
vector241:
  pushl $0
80105e2d:	6a 00                	push   $0x0
  pushl $241
80105e2f:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105e34:	e9 a3 f0 ff ff       	jmp    80104edc <alltraps>

80105e39 <vector242>:
.globl vector242
vector242:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $242
80105e3b:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105e40:	e9 97 f0 ff ff       	jmp    80104edc <alltraps>

80105e45 <vector243>:
.globl vector243
vector243:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $243
80105e47:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105e4c:	e9 8b f0 ff ff       	jmp    80104edc <alltraps>

80105e51 <vector244>:
.globl vector244
vector244:
  pushl $0
80105e51:	6a 00                	push   $0x0
  pushl $244
80105e53:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105e58:	e9 7f f0 ff ff       	jmp    80104edc <alltraps>

80105e5d <vector245>:
.globl vector245
vector245:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $245
80105e5f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105e64:	e9 73 f0 ff ff       	jmp    80104edc <alltraps>

80105e69 <vector246>:
.globl vector246
vector246:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $246
80105e6b:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105e70:	e9 67 f0 ff ff       	jmp    80104edc <alltraps>

80105e75 <vector247>:
.globl vector247
vector247:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $247
80105e77:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105e7c:	e9 5b f0 ff ff       	jmp    80104edc <alltraps>

80105e81 <vector248>:
.globl vector248
vector248:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $248
80105e83:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105e88:	e9 4f f0 ff ff       	jmp    80104edc <alltraps>

80105e8d <vector249>:
.globl vector249
vector249:
  pushl $0
80105e8d:	6a 00                	push   $0x0
  pushl $249
80105e8f:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105e94:	e9 43 f0 ff ff       	jmp    80104edc <alltraps>

80105e99 <vector250>:
.globl vector250
vector250:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $250
80105e9b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105ea0:	e9 37 f0 ff ff       	jmp    80104edc <alltraps>

80105ea5 <vector251>:
.globl vector251
vector251:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $251
80105ea7:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105eac:	e9 2b f0 ff ff       	jmp    80104edc <alltraps>

80105eb1 <vector252>:
.globl vector252
vector252:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $252
80105eb3:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105eb8:	e9 1f f0 ff ff       	jmp    80104edc <alltraps>

80105ebd <vector253>:
.globl vector253
vector253:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $253
80105ebf:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105ec4:	e9 13 f0 ff ff       	jmp    80104edc <alltraps>

80105ec9 <vector254>:
.globl vector254
vector254:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $254
80105ecb:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105ed0:	e9 07 f0 ff ff       	jmp    80104edc <alltraps>

80105ed5 <vector255>:
.globl vector255
vector255:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $255
80105ed7:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105edc:	e9 fb ef ff ff       	jmp    80104edc <alltraps>

80105ee1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105ee1:	55                   	push   %ebp
80105ee2:	89 e5                	mov    %esp,%ebp
80105ee4:	57                   	push   %edi
80105ee5:	56                   	push   %esi
80105ee6:	53                   	push   %ebx
80105ee7:	83 ec 0c             	sub    $0xc,%esp
80105eea:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105eec:	c1 ea 16             	shr    $0x16,%edx
80105eef:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105ef2:	8b 37                	mov    (%edi),%esi
80105ef4:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105efa:	74 20                	je     80105f1c <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105efc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105f02:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105f08:	c1 eb 0c             	shr    $0xc,%ebx
80105f0b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105f11:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f17:	5b                   	pop    %ebx
80105f18:	5e                   	pop    %esi
80105f19:	5f                   	pop    %edi
80105f1a:	5d                   	pop    %ebp
80105f1b:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105f1c:	85 c9                	test   %ecx,%ecx
80105f1e:	74 2b                	je     80105f4b <walkpgdir+0x6a>
80105f20:	e8 d7 c1 ff ff       	call   801020fc <kalloc>
80105f25:	89 c6                	mov    %eax,%esi
80105f27:	85 c0                	test   %eax,%eax
80105f29:	74 20                	je     80105f4b <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80105f2b:	83 ec 04             	sub    $0x4,%esp
80105f2e:	68 00 10 00 00       	push   $0x1000
80105f33:	6a 00                	push   $0x0
80105f35:	50                   	push   %eax
80105f36:	e8 d3 dd ff ff       	call   80103d0e <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105f3b:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105f41:	83 c8 07             	or     $0x7,%eax
80105f44:	89 07                	mov    %eax,(%edi)
80105f46:	83 c4 10             	add    $0x10,%esp
80105f49:	eb bd                	jmp    80105f08 <walkpgdir+0x27>
      return 0;
80105f4b:	b8 00 00 00 00       	mov    $0x0,%eax
80105f50:	eb c2                	jmp    80105f14 <walkpgdir+0x33>

80105f52 <seginit>:
{
80105f52:	f3 0f 1e fb          	endbr32 
80105f56:	55                   	push   %ebp
80105f57:	89 e5                	mov    %esp,%ebp
80105f59:	57                   	push   %edi
80105f5a:	56                   	push   %esi
80105f5b:	53                   	push   %ebx
80105f5c:	83 ec 1c             	sub    $0x1c,%esp
  c = &cpus[cpuid()];
80105f5f:	e8 b8 d2 ff ff       	call   8010321c <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105f64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80105f67:	8d 3c 09             	lea    (%ecx,%ecx,1),%edi
80105f6a:	8d 14 07             	lea    (%edi,%eax,1),%edx
80105f6d:	c1 e2 04             	shl    $0x4,%edx
80105f70:	66 c7 82 f8 27 11 80 	movw   $0xffff,-0x7feed808(%edx)
80105f77:	ff ff 
80105f79:	66 c7 82 fa 27 11 80 	movw   $0x0,-0x7feed806(%edx)
80105f80:	00 00 
80105f82:	c6 82 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%edx)
80105f89:	8d 34 07             	lea    (%edi,%eax,1),%esi
80105f8c:	c1 e6 04             	shl    $0x4,%esi
80105f8f:	8a 9e fd 27 11 80    	mov    -0x7feed803(%esi),%bl
80105f95:	83 e3 f0             	and    $0xfffffff0,%ebx
80105f98:	83 cb 1a             	or     $0x1a,%ebx
80105f9b:	83 e3 9f             	and    $0xffffff9f,%ebx
80105f9e:	83 cb 80             	or     $0xffffff80,%ebx
80105fa1:	88 9e fd 27 11 80    	mov    %bl,-0x7feed803(%esi)
80105fa7:	8a 9e fe 27 11 80    	mov    -0x7feed802(%esi),%bl
80105fad:	83 cb 0f             	or     $0xf,%ebx
80105fb0:	83 e3 cf             	and    $0xffffffcf,%ebx
80105fb3:	83 cb c0             	or     $0xffffffc0,%ebx
80105fb6:	88 9e fe 27 11 80    	mov    %bl,-0x7feed802(%esi)
80105fbc:	c6 82 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105fc3:	66 c7 82 00 28 11 80 	movw   $0xffff,-0x7feed800(%edx)
80105fca:	ff ff 
80105fcc:	66 c7 82 02 28 11 80 	movw   $0x0,-0x7feed7fe(%edx)
80105fd3:	00 00 
80105fd5:	c6 82 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%edx)
80105fdc:	8d 34 07             	lea    (%edi,%eax,1),%esi
80105fdf:	c1 e6 04             	shl    $0x4,%esi
80105fe2:	8a 9e 05 28 11 80    	mov    -0x7feed7fb(%esi),%bl
80105fe8:	83 e3 f0             	and    $0xfffffff0,%ebx
80105feb:	83 cb 12             	or     $0x12,%ebx
80105fee:	83 e3 9f             	and    $0xffffff9f,%ebx
80105ff1:	83 cb 80             	or     $0xffffff80,%ebx
80105ff4:	88 9e 05 28 11 80    	mov    %bl,-0x7feed7fb(%esi)
80105ffa:	8a 9e 06 28 11 80    	mov    -0x7feed7fa(%esi),%bl
80106000:	83 cb 0f             	or     $0xf,%ebx
80106003:	83 e3 cf             	and    $0xffffffcf,%ebx
80106006:	83 cb c0             	or     $0xffffffc0,%ebx
80106009:	88 9e 06 28 11 80    	mov    %bl,-0x7feed7fa(%esi)
8010600f:	c6 82 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106016:	66 c7 82 08 28 11 80 	movw   $0xffff,-0x7feed7f8(%edx)
8010601d:	ff ff 
8010601f:	66 c7 82 0a 28 11 80 	movw   $0x0,-0x7feed7f6(%edx)
80106026:	00 00 
80106028:	c6 82 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%edx)
8010602f:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80106032:	c1 e3 04             	shl    $0x4,%ebx
80106035:	c6 83 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%ebx)
8010603c:	0f b6 b3 0e 28 11 80 	movzbl -0x7feed7f2(%ebx),%esi
80106043:	83 ce 0f             	or     $0xf,%esi
80106046:	83 e6 cf             	and    $0xffffffcf,%esi
80106049:	83 ce c0             	or     $0xffffffc0,%esi
8010604c:	89 f1                	mov    %esi,%ecx
8010604e:	88 8b 0e 28 11 80    	mov    %cl,-0x7feed7f2(%ebx)
80106054:	c6 82 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010605b:	66 c7 82 10 28 11 80 	movw   $0xffff,-0x7feed7f0(%edx)
80106062:	ff ff 
80106064:	66 c7 82 12 28 11 80 	movw   $0x0,-0x7feed7ee(%edx)
8010606b:	00 00 
8010606d:	c6 82 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%edx)
80106074:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80106077:	c1 e3 04             	shl    $0x4,%ebx
8010607a:	c6 83 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%ebx)
80106081:	0f b6 b3 16 28 11 80 	movzbl -0x7feed7ea(%ebx),%esi
80106088:	83 ce 0f             	or     $0xf,%esi
8010608b:	83 e6 cf             	and    $0xffffffcf,%esi
8010608e:	83 ce c0             	or     $0xffffffc0,%esi
80106091:	89 f1                	mov    %esi,%ecx
80106093:	88 8b 16 28 11 80    	mov    %cl,-0x7feed7ea(%ebx)
80106099:	c6 82 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%edx)
  lgdt(c->gdt, sizeof(c->gdt));
801060a0:	8d 0c 07             	lea    (%edi,%eax,1),%ecx
801060a3:	c1 e1 04             	shl    $0x4,%ecx
801060a6:	81 c1 f0 27 11 80    	add    $0x801127f0,%ecx
  pd[0] = size-1;
801060ac:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
801060b2:	66 89 4d e4          	mov    %cx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
801060b6:	c1 e9 10             	shr    $0x10,%ecx
801060b9:	66 89 4d e6          	mov    %cx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801060bd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801060c0:	0f 01 10             	lgdtl  (%eax)
}
801060c3:	83 c4 1c             	add    $0x1c,%esp
801060c6:	5b                   	pop    %ebx
801060c7:	5e                   	pop    %esi
801060c8:	5f                   	pop    %edi
801060c9:	5d                   	pop    %ebp
801060ca:	c3                   	ret    

801060cb <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801060cb:	f3 0f 1e fb          	endbr32 
801060cf:	55                   	push   %ebp
801060d0:	89 e5                	mov    %esp,%ebp
801060d2:	57                   	push   %edi
801060d3:	56                   	push   %esi
801060d4:	53                   	push   %ebx
801060d5:	83 ec 0c             	sub    $0xc,%esp
801060d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
801060db:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801060de:	89 fb                	mov    %edi,%ebx
801060e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801060e6:	03 7d 10             	add    0x10(%ebp),%edi
801060e9:	4f                   	dec    %edi
801060ea:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801060f0:	b9 01 00 00 00       	mov    $0x1,%ecx
801060f5:	89 da                	mov    %ebx,%edx
801060f7:	8b 45 08             	mov    0x8(%ebp),%eax
801060fa:	e8 e2 fd ff ff       	call   80105ee1 <walkpgdir>
801060ff:	85 c0                	test   %eax,%eax
80106101:	74 2e                	je     80106131 <mappages+0x66>
      return -1;
    if(*pte & PTE_P)
80106103:	f6 00 01             	testb  $0x1,(%eax)
80106106:	75 1c                	jne    80106124 <mappages+0x59>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106108:	89 f2                	mov    %esi,%edx
8010610a:	0b 55 18             	or     0x18(%ebp),%edx
8010610d:	83 ca 01             	or     $0x1,%edx
80106110:	89 10                	mov    %edx,(%eax)
    if(a == last)
80106112:	39 fb                	cmp    %edi,%ebx
80106114:	74 28                	je     8010613e <mappages+0x73>
      break;
    a += PGSIZE;
80106116:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
8010611c:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106122:	eb cc                	jmp    801060f0 <mappages+0x25>
      panic("remap");
80106124:	83 ec 0c             	sub    $0xc,%esp
80106127:	68 3c 71 10 80       	push   $0x8010713c
8010612c:	e8 24 a2 ff ff       	call   80100355 <panic>
      return -1;
80106131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106136:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106139:	5b                   	pop    %ebx
8010613a:	5e                   	pop    %esi
8010613b:	5f                   	pop    %edi
8010613c:	5d                   	pop    %ebp
8010613d:	c3                   	ret    
  return 0;
8010613e:	b8 00 00 00 00       	mov    $0x0,%eax
80106143:	eb f1                	jmp    80106136 <mappages+0x6b>

80106145 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106145:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106149:	a1 a4 55 11 80       	mov    0x801155a4,%eax
8010614e:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106153:	0f 22 d8             	mov    %eax,%cr3
}
80106156:	c3                   	ret    

80106157 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106157:	f3 0f 1e fb          	endbr32 
8010615b:	55                   	push   %ebp
8010615c:	89 e5                	mov    %esp,%ebp
8010615e:	57                   	push   %edi
8010615f:	56                   	push   %esi
80106160:	53                   	push   %ebx
80106161:	83 ec 1c             	sub    $0x1c,%esp
80106164:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106167:	85 f6                	test   %esi,%esi
80106169:	0f 84 da 00 00 00    	je     80106249 <switchuvm+0xf2>
    panic("switchuvm: no process");
  if(p->kstack == 0)
8010616f:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80106173:	0f 84 dd 00 00 00    	je     80106256 <switchuvm+0xff>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106179:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
8010617d:	0f 84 e0 00 00 00    	je     80106263 <switchuvm+0x10c>
    panic("switchuvm: no pgdir");

  pushcli();
80106183:	e8 ea d9 ff ff       	call   80103b72 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106188:	e8 28 d0 ff ff       	call   801031b5 <mycpu>
8010618d:	89 c3                	mov    %eax,%ebx
8010618f:	e8 21 d0 ff ff       	call   801031b5 <mycpu>
80106194:	8d 78 08             	lea    0x8(%eax),%edi
80106197:	e8 19 d0 ff ff       	call   801031b5 <mycpu>
8010619c:	83 c0 08             	add    $0x8,%eax
8010619f:	c1 e8 10             	shr    $0x10,%eax
801061a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801061a5:	e8 0b d0 ff ff       	call   801031b5 <mycpu>
801061aa:	83 c0 08             	add    $0x8,%eax
801061ad:	c1 e8 18             	shr    $0x18,%eax
801061b0:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801061b7:	67 00 
801061b9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801061c0:	8a 4d e4             	mov    -0x1c(%ebp),%cl
801061c3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801061c9:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
801061cf:	83 e2 f0             	and    $0xfffffff0,%edx
801061d2:	83 ca 19             	or     $0x19,%edx
801061d5:	83 e2 9f             	and    $0xffffff9f,%edx
801061d8:	83 ca 80             	or     $0xffffff80,%edx
801061db:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801061e1:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801061e8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801061ee:	e8 c2 cf ff ff       	call   801031b5 <mycpu>
801061f3:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801061f9:	83 e2 ef             	and    $0xffffffef,%edx
801061fc:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106202:	e8 ae cf ff ff       	call   801031b5 <mycpu>
80106207:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010620d:	8b 5e 08             	mov    0x8(%esi),%ebx
80106210:	e8 a0 cf ff ff       	call   801031b5 <mycpu>
80106215:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010621b:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010621e:	e8 92 cf ff ff       	call   801031b5 <mycpu>
80106223:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106229:	b8 28 00 00 00       	mov    $0x28,%eax
8010622e:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106231:	8b 46 04             	mov    0x4(%esi),%eax
80106234:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106239:	0f 22 d8             	mov    %eax,%cr3
  popcli();
8010623c:	e8 71 d9 ff ff       	call   80103bb2 <popcli>
}
80106241:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106244:	5b                   	pop    %ebx
80106245:	5e                   	pop    %esi
80106246:	5f                   	pop    %edi
80106247:	5d                   	pop    %ebp
80106248:	c3                   	ret    
    panic("switchuvm: no process");
80106249:	83 ec 0c             	sub    $0xc,%esp
8010624c:	68 42 71 10 80       	push   $0x80107142
80106251:	e8 ff a0 ff ff       	call   80100355 <panic>
    panic("switchuvm: no kstack");
80106256:	83 ec 0c             	sub    $0xc,%esp
80106259:	68 58 71 10 80       	push   $0x80107158
8010625e:	e8 f2 a0 ff ff       	call   80100355 <panic>
    panic("switchuvm: no pgdir");
80106263:	83 ec 0c             	sub    $0xc,%esp
80106266:	68 6d 71 10 80       	push   $0x8010716d
8010626b:	e8 e5 a0 ff ff       	call   80100355 <panic>

80106270 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106270:	f3 0f 1e fb          	endbr32 
80106274:	55                   	push   %ebp
80106275:	89 e5                	mov    %esp,%ebp
80106277:	56                   	push   %esi
80106278:	53                   	push   %ebx
80106279:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
8010627c:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106282:	77 4b                	ja     801062cf <inituvm+0x5f>
    panic("inituvm: more than a page");
  mem = kalloc();
80106284:	e8 73 be ff ff       	call   801020fc <kalloc>
80106289:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010628b:	83 ec 04             	sub    $0x4,%esp
8010628e:	68 00 10 00 00       	push   $0x1000
80106293:	6a 00                	push   $0x0
80106295:	50                   	push   %eax
80106296:	e8 73 da ff ff       	call   80103d0e <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010629b:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801062a2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801062a8:	50                   	push   %eax
801062a9:	68 00 10 00 00       	push   $0x1000
801062ae:	6a 00                	push   $0x0
801062b0:	ff 75 08             	pushl  0x8(%ebp)
801062b3:	e8 13 fe ff ff       	call   801060cb <mappages>
  memmove(mem, init, sz);
801062b8:	83 c4 1c             	add    $0x1c,%esp
801062bb:	56                   	push   %esi
801062bc:	ff 75 0c             	pushl  0xc(%ebp)
801062bf:	53                   	push   %ebx
801062c0:	e8 c7 da ff ff       	call   80103d8c <memmove>
}
801062c5:	83 c4 10             	add    $0x10,%esp
801062c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062cb:	5b                   	pop    %ebx
801062cc:	5e                   	pop    %esi
801062cd:	5d                   	pop    %ebp
801062ce:	c3                   	ret    
    panic("inituvm: more than a page");
801062cf:	83 ec 0c             	sub    $0xc,%esp
801062d2:	68 81 71 10 80       	push   $0x80107181
801062d7:	e8 79 a0 ff ff       	call   80100355 <panic>

801062dc <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801062dc:	f3 0f 1e fb          	endbr32 
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	57                   	push   %edi
801062e4:	56                   	push   %esi
801062e5:	53                   	push   %ebx
801062e6:	83 ec 0c             	sub    $0xc,%esp
801062e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801062ec:	89 fb                	mov    %edi,%ebx
801062ee:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801062f4:	74 3c                	je     80106332 <loaduvm+0x56>
    panic("loaduvm: addr must be page aligned");
801062f6:	83 ec 0c             	sub    $0xc,%esp
801062f9:	68 3c 72 10 80       	push   $0x8010723c
801062fe:	e8 52 a0 ff ff       	call   80100355 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106303:	83 ec 0c             	sub    $0xc,%esp
80106306:	68 9b 71 10 80       	push   $0x8010719b
8010630b:	e8 45 a0 ff ff       	call   80100355 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106310:	05 00 00 00 80       	add    $0x80000000,%eax
80106315:	56                   	push   %esi
80106316:	89 da                	mov    %ebx,%edx
80106318:	03 55 14             	add    0x14(%ebp),%edx
8010631b:	52                   	push   %edx
8010631c:	50                   	push   %eax
8010631d:	ff 75 10             	pushl  0x10(%ebp)
80106320:	e8 62 b4 ff ff       	call   80101787 <readi>
80106325:	83 c4 10             	add    $0x10,%esp
80106328:	39 f0                	cmp    %esi,%eax
8010632a:	75 47                	jne    80106373 <loaduvm+0x97>
  for(i = 0; i < sz; i += PGSIZE){
8010632c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106332:	3b 5d 18             	cmp    0x18(%ebp),%ebx
80106335:	73 2f                	jae    80106366 <loaduvm+0x8a>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106337:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
8010633a:	b9 00 00 00 00       	mov    $0x0,%ecx
8010633f:	8b 45 08             	mov    0x8(%ebp),%eax
80106342:	e8 9a fb ff ff       	call   80105ee1 <walkpgdir>
80106347:	85 c0                	test   %eax,%eax
80106349:	74 b8                	je     80106303 <loaduvm+0x27>
    pa = PTE_ADDR(*pte);
8010634b:	8b 00                	mov    (%eax),%eax
8010634d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106352:	8b 75 18             	mov    0x18(%ebp),%esi
80106355:	29 de                	sub    %ebx,%esi
80106357:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010635d:	76 b1                	jbe    80106310 <loaduvm+0x34>
      n = PGSIZE;
8010635f:	be 00 10 00 00       	mov    $0x1000,%esi
80106364:	eb aa                	jmp    80106310 <loaduvm+0x34>
      return -1;
  }
  return 0;
80106366:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010636b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010636e:	5b                   	pop    %ebx
8010636f:	5e                   	pop    %esi
80106370:	5f                   	pop    %edi
80106371:	5d                   	pop    %ebp
80106372:	c3                   	ret    
      return -1;
80106373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106378:	eb f1                	jmp    8010636b <loaduvm+0x8f>

8010637a <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010637a:	f3 0f 1e fb          	endbr32 
8010637e:	55                   	push   %ebp
8010637f:	89 e5                	mov    %esp,%ebp
80106381:	57                   	push   %edi
80106382:	56                   	push   %esi
80106383:	53                   	push   %ebx
80106384:	83 ec 0c             	sub    $0xc,%esp
80106387:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010638a:	39 7d 10             	cmp    %edi,0x10(%ebp)
8010638d:	73 11                	jae    801063a0 <deallocuvm+0x26>
    return oldsz;

  a = PGROUNDUP(newsz);
8010638f:	8b 45 10             	mov    0x10(%ebp),%eax
80106392:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106398:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010639e:	eb 17                	jmp    801063b7 <deallocuvm+0x3d>
    return oldsz;
801063a0:	89 f8                	mov    %edi,%eax
801063a2:	eb 62                	jmp    80106406 <deallocuvm+0x8c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801063a4:	c1 eb 16             	shr    $0x16,%ebx
801063a7:	43                   	inc    %ebx
801063a8:	c1 e3 16             	shl    $0x16,%ebx
801063ab:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801063b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801063b7:	39 fb                	cmp    %edi,%ebx
801063b9:	73 48                	jae    80106403 <deallocuvm+0x89>
    pte = walkpgdir(pgdir, (char*)a, 0);
801063bb:	b9 00 00 00 00       	mov    $0x0,%ecx
801063c0:	89 da                	mov    %ebx,%edx
801063c2:	8b 45 08             	mov    0x8(%ebp),%eax
801063c5:	e8 17 fb ff ff       	call   80105ee1 <walkpgdir>
801063ca:	89 c6                	mov    %eax,%esi
    if(!pte)
801063cc:	85 c0                	test   %eax,%eax
801063ce:	74 d4                	je     801063a4 <deallocuvm+0x2a>
    else if((*pte & PTE_P) != 0){
801063d0:	8b 00                	mov    (%eax),%eax
801063d2:	a8 01                	test   $0x1,%al
801063d4:	74 db                	je     801063b1 <deallocuvm+0x37>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801063d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801063db:	74 19                	je     801063f6 <deallocuvm+0x7c>
        panic("kfree");
      char *v = P2V(pa);
801063dd:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801063e2:	83 ec 0c             	sub    $0xc,%esp
801063e5:	50                   	push   %eax
801063e6:	e8 ea bb ff ff       	call   80101fd5 <kfree>
      *pte = 0;
801063eb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801063f1:	83 c4 10             	add    $0x10,%esp
801063f4:	eb bb                	jmp    801063b1 <deallocuvm+0x37>
        panic("kfree");
801063f6:	83 ec 0c             	sub    $0xc,%esp
801063f9:	68 66 6a 10 80       	push   $0x80106a66
801063fe:	e8 52 9f ff ff       	call   80100355 <panic>
    }
  }
  return newsz;
80106403:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106406:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106409:	5b                   	pop    %ebx
8010640a:	5e                   	pop    %esi
8010640b:	5f                   	pop    %edi
8010640c:	5d                   	pop    %ebp
8010640d:	c3                   	ret    

8010640e <allocuvm>:
{
8010640e:	f3 0f 1e fb          	endbr32 
80106412:	55                   	push   %ebp
80106413:	89 e5                	mov    %esp,%ebp
80106415:	57                   	push   %edi
80106416:	56                   	push   %esi
80106417:	53                   	push   %ebx
80106418:	83 ec 1c             	sub    $0x1c,%esp
8010641b:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010641e:	8b 45 10             	mov    0x10(%ebp),%eax
80106421:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106424:	85 c0                	test   %eax,%eax
80106426:	0f 88 c0 00 00 00    	js     801064ec <allocuvm+0xde>
  if(newsz < oldsz)
8010642c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010642f:	39 45 10             	cmp    %eax,0x10(%ebp)
80106432:	72 11                	jb     80106445 <allocuvm+0x37>
  a = PGROUNDUP(oldsz);
80106434:	8b 45 0c             	mov    0xc(%ebp),%eax
80106437:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010643d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106443:	eb 36                	jmp    8010647b <allocuvm+0x6d>
    return oldsz;
80106445:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106448:	e9 a6 00 00 00       	jmp    801064f3 <allocuvm+0xe5>
      cprintf("allocuvm out of memory\n");
8010644d:	83 ec 0c             	sub    $0xc,%esp
80106450:	68 b9 71 10 80       	push   $0x801071b9
80106455:	e8 a3 a1 ff ff       	call   801005fd <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010645a:	83 c4 0c             	add    $0xc,%esp
8010645d:	ff 75 0c             	pushl  0xc(%ebp)
80106460:	ff 75 10             	pushl  0x10(%ebp)
80106463:	57                   	push   %edi
80106464:	e8 11 ff ff ff       	call   8010637a <deallocuvm>
      return 0;
80106469:	83 c4 10             	add    $0x10,%esp
8010646c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106473:	eb 7e                	jmp    801064f3 <allocuvm+0xe5>
  for(; a < newsz; a += PGSIZE){
80106475:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010647b:	3b 75 10             	cmp    0x10(%ebp),%esi
8010647e:	73 73                	jae    801064f3 <allocuvm+0xe5>
    mem = kalloc();
80106480:	e8 77 bc ff ff       	call   801020fc <kalloc>
80106485:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106487:	85 c0                	test   %eax,%eax
80106489:	74 c2                	je     8010644d <allocuvm+0x3f>
    memset(mem, 0, PGSIZE);
8010648b:	83 ec 04             	sub    $0x4,%esp
8010648e:	68 00 10 00 00       	push   $0x1000
80106493:	6a 00                	push   $0x0
80106495:	50                   	push   %eax
80106496:	e8 73 d8 ff ff       	call   80103d0e <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010649b:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801064a2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801064a8:	50                   	push   %eax
801064a9:	68 00 10 00 00       	push   $0x1000
801064ae:	56                   	push   %esi
801064af:	57                   	push   %edi
801064b0:	e8 16 fc ff ff       	call   801060cb <mappages>
801064b5:	83 c4 20             	add    $0x20,%esp
801064b8:	85 c0                	test   %eax,%eax
801064ba:	79 b9                	jns    80106475 <allocuvm+0x67>
      cprintf("allocuvm out of memory (2)\n");
801064bc:	83 ec 0c             	sub    $0xc,%esp
801064bf:	68 d1 71 10 80       	push   $0x801071d1
801064c4:	e8 34 a1 ff ff       	call   801005fd <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801064c9:	83 c4 0c             	add    $0xc,%esp
801064cc:	ff 75 0c             	pushl  0xc(%ebp)
801064cf:	ff 75 10             	pushl  0x10(%ebp)
801064d2:	57                   	push   %edi
801064d3:	e8 a2 fe ff ff       	call   8010637a <deallocuvm>
      kfree(mem);
801064d8:	89 1c 24             	mov    %ebx,(%esp)
801064db:	e8 f5 ba ff ff       	call   80101fd5 <kfree>
      return 0;
801064e0:	83 c4 10             	add    $0x10,%esp
801064e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801064ea:	eb 07                	jmp    801064f3 <allocuvm+0xe5>
    return 0;
801064ec:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801064f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064f9:	5b                   	pop    %ebx
801064fa:	5e                   	pop    %esi
801064fb:	5f                   	pop    %edi
801064fc:	5d                   	pop    %ebp
801064fd:	c3                   	ret    

801064fe <freevm>:

// Free a page table and all the physical memory pages
// in the user part if dodeallocuvm is not zero
void
freevm(pde_t *pgdir, int dodeallocuvm)
{
801064fe:	f3 0f 1e fb          	endbr32 
80106502:	55                   	push   %ebp
80106503:	89 e5                	mov    %esp,%ebp
80106505:	56                   	push   %esi
80106506:	53                   	push   %ebx
80106507:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010650a:	85 f6                	test   %esi,%esi
8010650c:	74 0d                	je     8010651b <freevm+0x1d>
    panic("freevm: no pgdir");
  if (dodeallocuvm)
8010650e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106512:	75 14                	jne    80106528 <freevm+0x2a>
{
80106514:	bb 00 00 00 00       	mov    $0x0,%ebx
80106519:	eb 39                	jmp    80106554 <freevm+0x56>
    panic("freevm: no pgdir");
8010651b:	83 ec 0c             	sub    $0xc,%esp
8010651e:	68 ed 71 10 80       	push   $0x801071ed
80106523:	e8 2d 9e ff ff       	call   80100355 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
80106528:	83 ec 04             	sub    $0x4,%esp
8010652b:	6a 00                	push   $0x0
8010652d:	68 00 00 00 80       	push   $0x80000000
80106532:	56                   	push   %esi
80106533:	e8 42 fe ff ff       	call   8010637a <deallocuvm>
80106538:	83 c4 10             	add    $0x10,%esp
8010653b:	eb d7                	jmp    80106514 <freevm+0x16>
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010653d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106542:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106547:	83 ec 0c             	sub    $0xc,%esp
8010654a:	50                   	push   %eax
8010654b:	e8 85 ba ff ff       	call   80101fd5 <kfree>
80106550:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106553:	43                   	inc    %ebx
80106554:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
8010655a:	77 09                	ja     80106565 <freevm+0x67>
    if(pgdir[i] & PTE_P){
8010655c:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
8010655f:	a8 01                	test   $0x1,%al
80106561:	74 f0                	je     80106553 <freevm+0x55>
80106563:	eb d8                	jmp    8010653d <freevm+0x3f>
    }
  }
  kfree((char*)pgdir);
80106565:	83 ec 0c             	sub    $0xc,%esp
80106568:	56                   	push   %esi
80106569:	e8 67 ba ff ff       	call   80101fd5 <kfree>
}
8010656e:	83 c4 10             	add    $0x10,%esp
80106571:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106574:	5b                   	pop    %ebx
80106575:	5e                   	pop    %esi
80106576:	5d                   	pop    %ebp
80106577:	c3                   	ret    

80106578 <setupkvm>:
{
80106578:	f3 0f 1e fb          	endbr32 
8010657c:	55                   	push   %ebp
8010657d:	89 e5                	mov    %esp,%ebp
8010657f:	56                   	push   %esi
80106580:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106581:	e8 76 bb ff ff       	call   801020fc <kalloc>
80106586:	89 c6                	mov    %eax,%esi
80106588:	85 c0                	test   %eax,%eax
8010658a:	74 57                	je     801065e3 <setupkvm+0x6b>
  memset(pgdir, 0, PGSIZE);
8010658c:	83 ec 04             	sub    $0x4,%esp
8010658f:	68 00 10 00 00       	push   $0x1000
80106594:	6a 00                	push   $0x0
80106596:	50                   	push   %eax
80106597:	e8 72 d7 ff ff       	call   80103d0e <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010659c:	83 c4 10             	add    $0x10,%esp
8010659f:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
801065a4:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801065aa:	73 37                	jae    801065e3 <setupkvm+0x6b>
                (uint)k->phys_start, k->perm) < 0) {
801065ac:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801065af:	83 ec 0c             	sub    $0xc,%esp
801065b2:	ff 73 0c             	pushl  0xc(%ebx)
801065b5:	50                   	push   %eax
801065b6:	8b 53 08             	mov    0x8(%ebx),%edx
801065b9:	29 c2                	sub    %eax,%edx
801065bb:	52                   	push   %edx
801065bc:	ff 33                	pushl  (%ebx)
801065be:	56                   	push   %esi
801065bf:	e8 07 fb ff ff       	call   801060cb <mappages>
801065c4:	83 c4 20             	add    $0x20,%esp
801065c7:	85 c0                	test   %eax,%eax
801065c9:	78 05                	js     801065d0 <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801065cb:	83 c3 10             	add    $0x10,%ebx
801065ce:	eb d4                	jmp    801065a4 <setupkvm+0x2c>
      freevm(pgdir, 0);
801065d0:	83 ec 08             	sub    $0x8,%esp
801065d3:	6a 00                	push   $0x0
801065d5:	56                   	push   %esi
801065d6:	e8 23 ff ff ff       	call   801064fe <freevm>
      return 0;
801065db:	83 c4 10             	add    $0x10,%esp
801065de:	be 00 00 00 00       	mov    $0x0,%esi
}
801065e3:	89 f0                	mov    %esi,%eax
801065e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065e8:	5b                   	pop    %ebx
801065e9:	5e                   	pop    %esi
801065ea:	5d                   	pop    %ebp
801065eb:	c3                   	ret    

801065ec <kvmalloc>:
{
801065ec:	f3 0f 1e fb          	endbr32 
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801065f6:	e8 7d ff ff ff       	call   80106578 <setupkvm>
801065fb:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  switchkvm();
80106600:	e8 40 fb ff ff       	call   80106145 <switchkvm>
}
80106605:	c9                   	leave  
80106606:	c3                   	ret    

80106607 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106607:	f3 0f 1e fb          	endbr32 
8010660b:	55                   	push   %ebp
8010660c:	89 e5                	mov    %esp,%ebp
8010660e:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106611:	b9 00 00 00 00       	mov    $0x0,%ecx
80106616:	8b 55 0c             	mov    0xc(%ebp),%edx
80106619:	8b 45 08             	mov    0x8(%ebp),%eax
8010661c:	e8 c0 f8 ff ff       	call   80105ee1 <walkpgdir>
  if(pte == 0)
80106621:	85 c0                	test   %eax,%eax
80106623:	74 05                	je     8010662a <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106625:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106628:	c9                   	leave  
80106629:	c3                   	ret    
    panic("clearpteu");
8010662a:	83 ec 0c             	sub    $0xc,%esp
8010662d:	68 fe 71 10 80       	push   $0x801071fe
80106632:	e8 1e 9d ff ff       	call   80100355 <panic>

80106637 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106637:	f3 0f 1e fb          	endbr32 
8010663b:	55                   	push   %ebp
8010663c:	89 e5                	mov    %esp,%ebp
8010663e:	57                   	push   %edi
8010663f:	56                   	push   %esi
80106640:	53                   	push   %ebx
80106641:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106644:	e8 2f ff ff ff       	call   80106578 <setupkvm>
80106649:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010664c:	85 c0                	test   %eax,%eax
8010664e:	0f 84 c6 00 00 00    	je     8010671a <copyuvm+0xe3>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106654:	bb 00 00 00 00       	mov    $0x0,%ebx
80106659:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
8010665c:	0f 83 b8 00 00 00    	jae    8010671a <copyuvm+0xe3>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106662:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106665:	b9 00 00 00 00       	mov    $0x0,%ecx
8010666a:	89 da                	mov    %ebx,%edx
8010666c:	8b 45 08             	mov    0x8(%ebp),%eax
8010666f:	e8 6d f8 ff ff       	call   80105ee1 <walkpgdir>
80106674:	85 c0                	test   %eax,%eax
80106676:	74 65                	je     801066dd <copyuvm+0xa6>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106678:	8b 00                	mov    (%eax),%eax
8010667a:	a8 01                	test   $0x1,%al
8010667c:	74 6c                	je     801066ea <copyuvm+0xb3>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010667e:	89 c6                	mov    %eax,%esi
80106680:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
80106686:	25 ff 0f 00 00       	and    $0xfff,%eax
8010668b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
8010668e:	e8 69 ba ff ff       	call   801020fc <kalloc>
80106693:	89 c7                	mov    %eax,%edi
80106695:	85 c0                	test   %eax,%eax
80106697:	74 6a                	je     80106703 <copyuvm+0xcc>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106699:	81 c6 00 00 00 80    	add    $0x80000000,%esi
8010669f:	83 ec 04             	sub    $0x4,%esp
801066a2:	68 00 10 00 00       	push   $0x1000
801066a7:	56                   	push   %esi
801066a8:	50                   	push   %eax
801066a9:	e8 de d6 ff ff       	call   80103d8c <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801066ae:	83 c4 04             	add    $0x4,%esp
801066b1:	ff 75 e0             	pushl  -0x20(%ebp)
801066b4:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801066ba:	50                   	push   %eax
801066bb:	68 00 10 00 00       	push   $0x1000
801066c0:	ff 75 e4             	pushl  -0x1c(%ebp)
801066c3:	ff 75 dc             	pushl  -0x24(%ebp)
801066c6:	e8 00 fa ff ff       	call   801060cb <mappages>
801066cb:	83 c4 20             	add    $0x20,%esp
801066ce:	85 c0                	test   %eax,%eax
801066d0:	78 25                	js     801066f7 <copyuvm+0xc0>
  for(i = 0; i < sz; i += PGSIZE){
801066d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066d8:	e9 7c ff ff ff       	jmp    80106659 <copyuvm+0x22>
      panic("copyuvm: pte should exist");
801066dd:	83 ec 0c             	sub    $0xc,%esp
801066e0:	68 08 72 10 80       	push   $0x80107208
801066e5:	e8 6b 9c ff ff       	call   80100355 <panic>
      panic("copyuvm: page not present");
801066ea:	83 ec 0c             	sub    $0xc,%esp
801066ed:	68 22 72 10 80       	push   $0x80107222
801066f2:	e8 5e 9c ff ff       	call   80100355 <panic>
      kfree(mem);
801066f7:	83 ec 0c             	sub    $0xc,%esp
801066fa:	57                   	push   %edi
801066fb:	e8 d5 b8 ff ff       	call   80101fd5 <kfree>
      goto bad;
80106700:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d, 1);
80106703:	83 ec 08             	sub    $0x8,%esp
80106706:	6a 01                	push   $0x1
80106708:	ff 75 dc             	pushl  -0x24(%ebp)
8010670b:	e8 ee fd ff ff       	call   801064fe <freevm>
  return 0;
80106710:	83 c4 10             	add    $0x10,%esp
80106713:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
8010671a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010671d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106720:	5b                   	pop    %ebx
80106721:	5e                   	pop    %esi
80106722:	5f                   	pop    %edi
80106723:	5d                   	pop    %ebp
80106724:	c3                   	ret    

80106725 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106725:	f3 0f 1e fb          	endbr32 
80106729:	55                   	push   %ebp
8010672a:	89 e5                	mov    %esp,%ebp
8010672c:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010672f:	b9 00 00 00 00       	mov    $0x0,%ecx
80106734:	8b 55 0c             	mov    0xc(%ebp),%edx
80106737:	8b 45 08             	mov    0x8(%ebp),%eax
8010673a:	e8 a2 f7 ff ff       	call   80105ee1 <walkpgdir>
  if((*pte & PTE_P) == 0)
8010673f:	8b 00                	mov    (%eax),%eax
80106741:	a8 01                	test   $0x1,%al
80106743:	74 10                	je     80106755 <uva2ka+0x30>
    return 0;
  if((*pte & PTE_U) == 0)
80106745:	a8 04                	test   $0x4,%al
80106747:	74 13                	je     8010675c <uva2ka+0x37>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106749:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010674e:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106753:	c9                   	leave  
80106754:	c3                   	ret    
    return 0;
80106755:	b8 00 00 00 00       	mov    $0x0,%eax
8010675a:	eb f7                	jmp    80106753 <uva2ka+0x2e>
    return 0;
8010675c:	b8 00 00 00 00       	mov    $0x0,%eax
80106761:	eb f0                	jmp    80106753 <uva2ka+0x2e>

80106763 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106763:	f3 0f 1e fb          	endbr32 
80106767:	55                   	push   %ebp
80106768:	89 e5                	mov    %esp,%ebp
8010676a:	57                   	push   %edi
8010676b:	56                   	push   %esi
8010676c:	53                   	push   %ebx
8010676d:	83 ec 0c             	sub    $0xc,%esp
80106770:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106773:	eb 25                	jmp    8010679a <copyout+0x37>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106775:	8b 55 0c             	mov    0xc(%ebp),%edx
80106778:	29 f2                	sub    %esi,%edx
8010677a:	01 d0                	add    %edx,%eax
8010677c:	83 ec 04             	sub    $0x4,%esp
8010677f:	53                   	push   %ebx
80106780:	ff 75 10             	pushl  0x10(%ebp)
80106783:	50                   	push   %eax
80106784:	e8 03 d6 ff ff       	call   80103d8c <memmove>
    len -= n;
80106789:	29 df                	sub    %ebx,%edi
    buf += n;
8010678b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
8010678e:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106794:	89 45 0c             	mov    %eax,0xc(%ebp)
80106797:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
8010679a:	85 ff                	test   %edi,%edi
8010679c:	74 2f                	je     801067cd <copyout+0x6a>
    va0 = (uint)PGROUNDDOWN(va);
8010679e:	8b 75 0c             	mov    0xc(%ebp),%esi
801067a1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801067a7:	83 ec 08             	sub    $0x8,%esp
801067aa:	56                   	push   %esi
801067ab:	ff 75 08             	pushl  0x8(%ebp)
801067ae:	e8 72 ff ff ff       	call   80106725 <uva2ka>
    if(pa0 == 0)
801067b3:	83 c4 10             	add    $0x10,%esp
801067b6:	85 c0                	test   %eax,%eax
801067b8:	74 20                	je     801067da <copyout+0x77>
    n = PGSIZE - (va - va0);
801067ba:	89 f3                	mov    %esi,%ebx
801067bc:	2b 5d 0c             	sub    0xc(%ebp),%ebx
801067bf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801067c5:	39 df                	cmp    %ebx,%edi
801067c7:	73 ac                	jae    80106775 <copyout+0x12>
      n = len;
801067c9:	89 fb                	mov    %edi,%ebx
801067cb:	eb a8                	jmp    80106775 <copyout+0x12>
  }
  return 0;
801067cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067d5:	5b                   	pop    %ebx
801067d6:	5e                   	pop    %esi
801067d7:	5f                   	pop    %edi
801067d8:	5d                   	pop    %ebp
801067d9:	c3                   	ret    
      return -1;
801067da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067df:	eb f1                	jmp    801067d2 <copyout+0x6f>
