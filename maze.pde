
class field {
  private boolean visited;
  private boolean current;
  private boolean wall_north;
  private boolean wall_east;
  private boolean wall_south;
  private boolean wall_west;
  
  public field() {
    visited = false;
    current = false;
    wall_north = random(50) < 15 ? false : true;
    wall_east = random(50) < 15 ? false : true;    
    wall_south = random(50) < 15 ? false : true;    
    wall_west = random(50) < 15 ? false : true;
  }
  
  public boolean north() {
    return wall_north;
  }

  public boolean east() {
    return wall_east;
  }
  
  public boolean south() {
    return wall_south;
  }
  
  public boolean west() {
    return wall_west;
  }
  
  public void setnorth( boolean w ) {
    wall_north = w;
  }
  
  public void seteast( boolean w ) {
    wall_east = w;
  }

  public void setsouth( boolean w ) {
    wall_south = w;
  }
  
  public void setwest( boolean w ) {
    wall_west = w;
  }
  
  public boolean visited() {
    return visited;
  }
  
  public void visit() {
    visited = true;
  }
  
  public void setCurrent() {
    current = true;
  }
  
  public void resetCurrent() {
    current = false;
  }
  
  public boolean getCurrent() {
    return current;
  }
}

class mazeclass {
  private field[][] _maze;
  private int maxcol = 1000;
  private int maxrow = 1000;
  
  private void createmaze( int mc, int mr ) {
    _maze = new field[maxcol][maxrow];
    for( int c = 0; c < maxcol; c++ ) {
      for( int r = 0; r < maxrow; r++ ) {
        if ( _maze[c][r] == null ) {
          _maze[c][r] = new field();
          if (c == 0) {
            _maze[c][r].setwest(true);
          }
          if ((r == 0) && (c>0)) {
            _maze[c][r].setnorth(true);
          }
          if (c + 1 == maxcol) {
            _maze[c][r].seteast(true);
          }
          if ((r + 1 == maxrow) && ( c < maxcol)) {
            _maze[c][r].setsouth(true);
          }
        }
      }
    }
  }

  public mazeclass() {
    createmaze( maxcol, maxrow );
  }    
  
  public mazeclass( int mc, int mr ) {
    maxcol = mc;
    maxrow = mr;
    createmaze( maxcol, maxrow );
  }
  
  public field get( int c, int r ) {
    if ( ( c >= 0 ) && ( c < maxcol ) &&
         ( r >= 0 ) && ( r < maxrow ) ) {
      return _maze[c][r];
    } else {
      return null;
    }
  }
  
  public void visit( int c, int r ) {
    if ( ( c >= 0 ) && ( c < maxcol ) &&
         ( r >= 0 ) && ( r < maxrow ) ) {
      _maze[c][r].visit();
    }
  }
  
  public void switchCurrent( int c, int r ) {
    if ( ( c >= 0 ) && ( c < maxcol ) &&
         ( r >= 0 ) && ( r < maxrow ) ) {
      if ( _maze[c][r].getCurrent() ) {
        _maze[c][r].resetCurrent();
      } else {
        _maze[c][r].setCurrent();
      }
    }
  }
    
  public boolean visited( int c, int r ) {
    if ( ( c >= 0 ) && ( c < maxcol ) &&
         ( r >= 0 ) && ( r < maxrow ) ) {
      return _maze[c][r].visited();
    } else {
      return false;
    }
  }
  
  public boolean current( int c, int r ) {
    if ( ( c >= 0 ) && ( c < maxcol ) &&
         ( r >= 0 ) && ( r < maxrow ) ) {
      return _maze[c][r].getCurrent();
    } else {
      return false;
    }
  }
    
  public int maxCol() {
    return maxcol;
  }
  
  public int maxRow() {
    return maxrow;
  }
  
  public void drawmaze( int fromcol, int fromrow, int tocol, int torow ) {
    int cols = tocol - fromcol;
    int rows = torow - fromrow;
    
    int colwidth = floor( width / cols );
    int rowheight = floor( height / rows );
    
    int wallwidth = floor( (colwidth + rowheight) / 12 );
    
    background(255);
    
    strokeWeight( wallwidth );
    stroke(0);
    
    for( int c = 0; c < cols; c++ ) {
      for( int r = 0; r < rows; r++ ) {
        boolean north, east, south, west;
        if ( r + fromrow > 1) {
          north = _maze[c + fromcol][r + fromrow].north() && _maze[ c + fromcol][r + fromrow - 1].south();
        } else {
          north = _maze[c + fromcol][r + fromrow].north();
        }
        if ( c + fromcol > 1) {
          west = _maze[c + fromcol][r + fromrow].west() && _maze[c + fromcol - 1][r + fromrow].east();
        } else {
          west = _maze[c + fromcol][r + fromrow].west();
        }
        if ( r + fromrow == m.maxRow() - 1 ) {
          south = _maze[ c + fromcol][r + fromrow].south();
        } else {
          south = false;
        }
        if ( c + fromcol == m.maxCol() - 1 ) {
          east = _maze[c + fromcol][r + fromrow].east();
        } else {
          east = false;
        }
        
        if ( north ) {
          line( c*colwidth, r*rowheight, (c+1)*colwidth, r*rowheight );
        }
        if ( east ) {
          line( (c+1)*colwidth - wallwidth, r*rowheight, (c+1)*colwidth - wallwidth, (r+1)*rowheight );
        }
        if ( south ) {
          line( c*colwidth, (r+1)*rowheight - wallwidth, (c+1)*colwidth, (r+1)*rowheight - wallwidth );
        }
        if ( west ) {
          line( c*colwidth, r*rowheight, c*colwidth, (r+1)*rowheight );
        }
        if ( _maze[c + fromcol][r + fromrow].visited() ) {
          if ( _maze[c + fromcol][r + fromrow].getCurrent() ) {
            fill(0,0,255);
          } else {
            fill(255,0,0);
          }
          circle( (c+0.5)*colwidth, (r+0.5)*rowheight, (colwidth + rowheight) / 4 );
        }
      }
    }
  }
}

class path {
  private mazeclass _m;
  private int px;
  private int py;
  
  public path( mazeclass m, int x, int y ) {
    _m = m;
    
    if (( x < 0 ) || ( x > _m.maxCol() ) ) {
      x = 0;
    }
    if (( y < 0 ) || ( y > _m.maxRow() ) ) {
      y = 0;
    }
    
    px = x;
    py = y;
    
    _m.visit( px, py );
    _m.switchCurrent( px, py );
  }
  
  public int X() {
    return px;
  }
  
  public int Y() {
    return py;
  }
  
  public void moveLeft() {
    _m.switchCurrent( px, py );
    if ( px > 0 ) {
      if ( ! (_m.get( px, py ).west() && _m.get( px-1, py ).east()) ) {
        px--;
      }
      
      if ( ! _m.visited( px, py ) ) {
        _m.get( px, py ).visit();
      }
    }
    _m.switchCurrent( px, py );
  }
  
  public void moveRight() {
    _m.switchCurrent( px, py );
    if ( px < _m.maxCol() - 2 ) {
      if ( ! (_m.get( px, py ).east() && _m.get( px+1, py ).west()) ) {
        px++;
      }
      
      if ( ! _m.visited( px, py ) ) {
        _m.get( px, py ).visit();
      }
    }
    _m.switchCurrent( px, py );
  }
      
  public void moveUp() {
    _m.switchCurrent( px, py );
    if ( py > 0 ) {
      if ( ! (_m.get( px, py ).north() && _m.get( px, py-1 ).south()) ) {
        py--;
      }
      
      if ( ! _m.visited( px, py ) ) {
        _m.get( px, py ).visit();
      }
    }
    _m.switchCurrent( px, py );
  }
  
  public void moveDown() {
    _m.switchCurrent( px, py );
    if ( py < _m.maxRow() - 2 ) {
      if ( ! (_m.get( px, py ).south() && _m.get( px, py+1 ).north()) ) {
        py++;
      }
      
      if ( ! _m.visited( px, py ) ) {
        _m.get( px, py ).visit();
      }
    }
    _m.switchCurrent( px, py );
  }
}
      
      
mazeclass m;
path p;


void setup() {
//  size(800,800);
  fullScreen();
  m = new mazeclass(); //<>//
  p = new path( m, m.maxCol() / 2, m.maxRow() / 2 );
}

void draw() {
  int sx = p.X() - 20;
  int sy = p.Y() - 20;
  if (sx < 0) sx = 0;
  if (sy < 0) sy = 0;
  int ex = sx + 40;
  int ey = sy + 40;
  if (ex >= m.maxCol()) {
    ex = m.maxCol();
    sx = ex - 40;
  }
  if (ey >= m.maxRow()) {
    ey = m.maxRow();
    sy = ey - 40;
  }
  
  m.drawmaze(sx,sy,ex,ey);
}

void keyPressed() {
  if ( keyCode == UP ) {
    p.moveUp();
  }
  if ( keyCode == DOWN ) {
    p.moveDown();
  }
  if ( keyCode == LEFT ) {
    p.moveLeft();
  }
  if ( keyCode == RIGHT ) {
    p.moveRight();
  }
  
  println( "x= "+p.X()+" y= "+p.Y() );
}

void mouseDragged() {
  if ( mouseY < pmouseY ) {
    p.moveUp();
  }
  if ( mouseY > pmouseY ) {
    p.moveDown();
  }
  if ( mouseX < pmouseX ) {
    p.moveLeft();
  }
  if ( mouseX > pmouseX ) {
    p.moveRight();
  }
  
  println( "x= "+p.X()+" y= "+p.Y() );
}
