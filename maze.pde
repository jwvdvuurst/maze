 //<>//
int mazeWidth = 800;
int mazeHeight = 800;
int dddWidth = 800;
int dddHeight = 800;


enum direction {
  north, 
    east, 
    south, 
    west
};

enum modes {
  m2d, 
    m3d
};

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
    wall_north = random(50) < 17 ? false : true;
    wall_east = random(50) < 17 ? false : true;
    wall_south = random(50) < 17 ? false : true;    
    wall_west = random(50) < 17 ? false : true;
  }

  public field( field f ) {
    visited = f.visited();
    current = f.getCurrent();
    wall_north = f.north();
    wall_east = f.east();
    wall_south = f.south();    
    wall_west = f.west();
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

  public void unvisit() {
    visited = false;
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
  private field[][] mazepart;
  private int maxcol = 2000;
  private int maxrow = 2000;
  private direction d = direction.north;
  private modes viewmode = modes.m2d;
  private int mazewidth = 5;
  private int mazeheight = 5;

  private void createmaze( int mc, int mr ) {
    _maze = new field[maxcol][maxrow];
    for ( int c = 0; c < maxcol; c++ ) {
      for ( int r = 0; r < maxrow; r++ ) {
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
//      return new field( _maze[c][r] );
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

  public void unvisit( int c, int r ) {
    if ( ( c >= 0 ) && ( c < maxcol ) &&
      ( r >= 0 ) && ( r < maxrow ) ) {
      _maze[c][r].unvisit();
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

  public direction getDirection() {
    return d;
  }

  public void setDirection( direction _d ) {
    d = _d;
  }

  public void changeViewmode() {
    if ( viewmode == modes.m2d ) {
      viewmode = modes.m3d;
    } else {
      viewmode = modes.m2d;
    }
  }

  public void setViewmode( modes m ) {
    viewmode = m;
  }

  public modes getViewmode() {
    return viewmode;
  }

  public int maxCol() {
    return maxcol;
  }

  public int maxRow() {
    return maxrow;
  }

  public void drawmaze( int fromcol, int fromrow, int tocol, int torow ) {
    if ( viewmode == modes.m2d ) {
      int cols = tocol - fromcol;
      int rows = torow - fromrow;

      int colwidth = floor( mazeWidth / cols );
      int rowheight = floor( mazeHeight / rows );

      int wallwidth = floor( (colwidth + rowheight) / 12 );

      background(255);

      strokeWeight( wallwidth );
      stroke(0);

      for ( int c = 0; c < cols; c++ ) {
        for ( int r = 0; r < rows; r++ ) {
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
              fill(0, 0, 255);
            } else {
              fill(255, 0, 0);
            }
            circle( (c+0.5)*colwidth, (r+0.5)*rowheight, (colwidth + rowheight) / 4 );
          }
        }
      }
    } else {      
      background(0);
      noStroke();
      int currx = floor((fromcol + tocol) / 2);
      int curry = floor((fromrow + torow) / 2);

      mazepart = new field[mazewidth][mazeheight];
      int xs, ys;

      switch( d ) {
      case north:
        xs = currx - ((mazewidth - 1) / 2);
        ys = curry - mazeheight;

        for ( int i = 0; i < mazewidth; i++ ) {
          for ( int j = 0; j < mazeheight; j++ ) {
            mazepart[i][j] = get( xs+i, ys+j );
            mazepart[i][j].setnorth( get( xs+i, ys+j ).north() && get( xs+i, ys+j-1 ).south() );
            mazepart[i][j].seteast( get( xs+i, ys+j ).east() && get( xs+i+1, ys+j ).west() );
            mazepart[i][j].setsouth( get( xs+i, ys+j ).south() && get( xs+i, ys+j+1 ).north() );
            mazepart[i][j].setwest( get( xs+i, ys+j ).west() && get( xs+i-1, ys+j ).east() );
          }
        }
        break;
      case east:
        xs = currx;
        ys = curry - ((mazeheight - 1) / 2);

        for ( int i = 0; i < mazeheight; i++ ) {
          for ( int j = 0; j < mazewidth; j++ ) {
            mazepart[i][j] = get( xs+i, ys+j );
            mazepart[i][j].setnorth( get( xs+j, ys+i ).north() && get( xs+j, ys+i-1 ).south() );
            mazepart[i][j].seteast( get( xs+j, ys+i ).east() && get( xs+j+1, ys+i ).west() );
            mazepart[i][j].setsouth( get( xs+j, ys+i ).south() && get( xs+j, ys+i+1 ).north() );
            mazepart[i][j].setwest( get( xs+j, ys+i ).west() && get( xs+j-1, ys+i ).east() );
          }
        }
        break;
      case south:
        xs = currx + ((mazewidth - 1)/2);
        ys = curry;

        for ( int i = 0; i < mazewidth; i++ ) {
          for ( int j = 0; j < mazeheight; j++ ) {
            mazepart[i][j] = get( xs-i, ys+j );
            mazepart[i][j].setnorth( get( xs-i, ys-j ).north() && get( xs-i, ys-j-1 ).south() );
            mazepart[i][j].seteast( get( xs-i, ys-j ).east() && get( xs+i-1, ys-j ).west() );
            mazepart[i][j].setsouth( get( xs-i, ys-j ).south() && get( xs-i, ys-j+1 ).north() );
            mazepart[i][j].setwest( get( xs-i, ys-j ).west() && get( xs-i-1, ys-j ).east() );
          }
        }
        break;
      case west:
        xs = currx;
        ys = curry + ((mazeheight - 1) / 2);

        for ( int i = 0; i < mazeheight; i++ ) {
          for ( int j = 0; j < mazewidth; j++ ) {
            mazepart[i][j] = get( xs-i, ys-j );
            mazepart[i][j].setnorth( get( xs-j, ys-i ).north() && get( xs-j, ys-i-1 ).south() );
            mazepart[i][j].seteast( get( xs-j, ys-i ).east() && get( xs-j+1, ys-i ).west() );
            mazepart[i][j].setsouth( get( xs-j, ys-i ).south() && get( xs-j, ys-i+1 ).north() );
            mazepart[i][j].setwest( get( xs-j, ys-i ).west() && get( xs-j-1, ys-i ).east() );
          }
        }
        break;
      default:
        xs = currx - ((mazewidth - 1) / 2);
        ys = curry - mazeheight;

        for ( int i = 0; i < mazewidth; i++ ) {
          for ( int j = 0; j < mazeheight; j++ ) {
            mazepart[i][j] = get( xs+i, ys+j );
            mazepart[i][j].setnorth( get( xs+i, ys+j ).north() && get( xs+i, ys+j-1 ).south() );
            mazepart[i][j].seteast( get( xs+i, ys+j ).east() && get( xs+i+1, ys+j ).west() );
            mazepart[i][j].setsouth( get( xs+i, ys+j ).south() && get( xs+i, ys+j+1 ).north() );
            mazepart[i][j].setwest( get( xs+i, ys+j ).west() && get( xs+i-1, ys+j ).east() );
          }
        }
        break;
      }

      int c = 255 - floor(128 / mazeheight);
      int nc = c + floor(128 / mazeheight);
      float f = 0.56;
      float nf = f * 1.11;
      int w = floor( width * f );
      int nw = floor( width * nf );
      int dw = floor(w / mazewidth);
      int ndw = floor( nw / mazewidth );
      xs = floor( (width - w) / 2 );
      int nxs = floor( (width - nw) / 2 );
      int h = floor( height * f * 0.5);
      int nh = floor( height * nf * 0.5);
      ys = height - floor( (height - h) / 2 );
      int nys = height - floor( (height - nh) / 2 );


      for ( int j = 0; j<mazeheight; j++ ) {
        for ( int i = 0; i<mazewidth; i++ ) {
          if ( mazepart[i][j].north() ) {
            fill(c);
            rect( xs+(dw*i), ys-h, dw, h );
          }
          if ( mazepart[i][j].west() ) {
            fill( nc );
            quad( xs+(dw*i), ys-h, nxs+(ndw*i), nys-nh, nxs+(ndw*i), nys, xs+(dw*i), ys );
          }
          if ( mazepart[i][j].east() ) {
            fill( nc-1 );
            quad( xs+(dw*(i+1)), ys-h, nxs+(ndw*(i+1)), nys-nh, nxs+(ndw*(i+1)), nys, xs+(dw*(i+1)), ys );
          }
          if ( mazepart[i][j].south() ) {
            fill(c);
            rect( nxs+(dw*i), nys-nh, ndw, nh );
          }
        }
        c = nc;
        f = nf;
        xs = nxs;
        w = nw;
        dw = ndw;
        ys = nys;
        h = nh;
        nc = c + floor(128/mazeheight);
        nf = f * 1.11;
        nw = floor( width * nf );
        ndw = floor( nw / mazewidth );
        nxs = floor( (width - nw) / 2 );
        nh = floor( height * nf * 0.5);
        nys = height - floor( (height - nh ) / 2 );
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
    //    _m.setDirection( direction.west );
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
    //    _m.setDirection( direction.east );
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
    //    _m.setDirection( direction.north );
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
    //    _m.setDirection( direction.south );
  }
}

class vector {
  public int x;
  public int y;

  public vector( int x, int y ) {
    this.x = x;
    this.y = y;
  }

  public vector( vector v ) {
    this.x = v.x;
    this.y = v.y;
  }

  public boolean equal( vector v ) {
    return ( this.x == v.x ) && ( this.y == v.y );
  }

  public boolean equal( int x, int y ) {
    return ( this.x == x ) && ( this.y == y );
  }
}

class trail {
  private mazeclass _m;
  private ArrayList<direction> _path;
  private vector curr;
  private direction _d;
  private boolean active;
  private path p;

  public trail( mazeclass m, int x, int y, direction d ) {
    _m = m;
    p = new path( m, x, y );
    _path = new ArrayList<direction>();
    vector v = new vector( x, y );
    curr = v;
    _d = d;
    _path.add( _d );
    active = true;
  }

  public trail( mazeclass m, int x, int y ) {
    _m = m;
    p = new path( m, x, y );
    _path = new ArrayList<direction>();
    vector v = new vector( x, y );
    curr = v;
    _d = direction.north;
    _path.add( _d );
    active = true;
  }

  public trail( trail t ) {
    this._m = t.getMaze();
    this._path = t.getPath();
    curr = t.getCurrent();
    p = new path( m, curr.x, curr.y );
    _d = t.getDir();
    active = true;
  }

  public trail( trail t, direction d ) {
    this._m = t.getMaze();
    this._path = t.getPath();
    curr = t.getCurrent();
    p = new path( m, curr.x, curr.y );
    _d = d;
    active = true;
  }

  public int getLength() {
    return _path.size();
  }

  //public boolean contains( vector v ) {
  //  return _path.contains( v );
  //}

  //public boolean contains( int x, int y ) {
  //  vector v = new vector(x, y);
  //  return this.contains(v);
  //}

  public String print( ArrayList<direction> p ) {
    String ds = "";

    for ( direction d : p ) {
      if ( d == direction.north ) ds = ds + "N";
      if ( d == direction.east ) ds = ds + "E";
      if ( d == direction.south ) ds = ds + "S";
      if ( d == direction.west ) ds = ds + "W";
    }

    return ds;
  }

  public direction get( int i ) {
    return _path.get(i);
  }

  public path getP() {
    return p;
  }

  public boolean equal( trail t ) {
    if ( this.getLength() == t.getLength() ) {
      boolean result = true;
      for ( int i = 0; (i<this.getLength()) && (result == true); i++ ) {
        result &= (this.get(i) == t.get(i));
      }
      return result;
    } else {
      return false;
    }
  }

  public mazeclass getMaze() {
    return _m;
  }

  public ArrayList<direction> getPath() {
    return _path;
  }

  public vector getCurrent() {
    return curr;
  }

  public boolean isActive() {
    return active;
  }

  public direction getDir() {
    return _d;
  }

  public direction goBack() {
    int last = getLength() - 1;
    direction d = _path.get( last );
    println( "Go Back! --> path "+print( _path ) );
    _d = d;
    direction rd = d;
    _path.remove( last );

    switch( d ) {
    case north: 
      rd = direction.south; 
      goSouth( false ); 
      break;
    case east: 
      rd = direction.west; 
      goWest( false ); 
      break;
    case south: 
      rd = direction.north; 
      goNorth( false ); 
      break;
    case west: 
      rd = direction.east; 
      goEast( false ); 
      break;
    default: 
      rd = direction.north;
    }

    println( "Going back in the direction "+rd );

    return rd;
  }

  public boolean goNorth() {
    return goNorth( true );
  }

  public boolean goEast() {
    return goEast( true );
  }

  public boolean goSouth() {
    return goSouth( true );
  }

  public boolean goWest() {
    return goWest( true );
  }

  public boolean goNorth( boolean checkvisit ) {
    int x = p.X();
    int y = p.Y();

    if ( y == 0 ) {
      return false;
    }

    if ( checkvisit ) {
      if ( _m.visited( x, y-1 ) ) {
        return false;
      }
    }

    p.moveUp();   

    //    _m.switchCurrent( curr.x, curr.y );

    _path.add( direction.north );
    //    _m.visit( x, y );
    curr.y = p.Y();
    ;

    //    _m.switchCurrent( curr.x, curr.y );

    println( "Go North to x="+x+" y="+y );

    return true;
  }

  public boolean goEast( boolean checkvisit ) {
    int x = p.X();
    int y = p.Y();

    if ( x == _m.maxCol() - 1 ) {
      return false;
    }

    if ( checkvisit ) {
      if ( _m.visited( x+1, y ) ) {
        return false;
      }
    }

    //    x++;
    p.moveRight();


    //    _m.switchCurrent( curr.x, curr.y );

    _path.add( direction.east );
    //    _m.visit( x, y );
    curr.x = p.X();

    //    _m.switchCurrent( curr.x, curr.y );

    println( "Go East to x="+x+" y="+y );

    return true;
  }

  public boolean goSouth( boolean checkvisit ) {
    int x = p.X();
    int y = p.Y();

    if ( y == _m.maxRow() - 1 ) {
      return false;
    }

    if ( checkvisit ) {
      if ( _m.visited( x, y+1 ) ) {
        return false;
      }
    }

    //    y++;
    p.moveDown();


    //    _m.switchCurrent( curr.x, curr.y );

    _path.add( direction.south );
    //    _m.visit( x, y );
    curr.y = p.Y();

    //    _m.switchCurrent( curr.x, curr.y );

    println( "Go South to x="+x+" y="+y );    

    return true;
  }

  public boolean goWest( boolean checkvisit ) {
    int x = p.X();
    int y = p.Y();

    if ( x == 0 ) {
      return false;
    }

    if ( checkvisit ) {
      if ( _m.visited( x-1, y ) ) {
        return false;
      }
    }

    //    x--;
    p.moveLeft();

    //    _m.switchCurrent( curr.x, curr.y );

    _path.add( direction.west );
    //    _m.visit( x, y );
    curr.x = p.X();

    //    _m.switchCurrent( curr.x, curr.y );

    println( "Go West to x="+x+" y="+y );    

    return true;
  }

  public boolean step() {
    field f = _m.get( curr.x, curr.y );

    direction ad = _d;
    boolean goahead = true;

    println( "Step x="+curr.x+" y="+curr.y+" direction = "+_d+" Active="+active );

    if ( active ) {
      switch( ad ) {
      case north: 
        goahead = !f.north(); 
        if (goahead) goahead = goNorth(); 
        break; 
      case east: 
        goahead = !f.east(); 
        if (goahead) goahead = goEast(); 
        break;
      case south: 
        goahead = !f.south(); 
        if (goahead) goahead = goSouth(); 
        break;
      case west: 
        goahead = !f.west(); 
        if (goahead) goahead = goWest(); 
        break;
      default: 
        goahead = false;
      }

      if ( !goahead ) {
        println( "Not able to continue in the direction of "+ad );

        ad = direction.north;
        goahead = false;
        int i = 0;

        while ( !goahead && i < 4 ) { 
          println( "Try to go "+ad );
          switch( ad ) {
          case north: 
            goahead = !f.north() && !_m.get( curr.x, curr.y-1 ).visited(); 
            if (goahead) goahead = goNorth(); 
            break; 
          case east: 
            goahead = !f.east() && !_m.get( curr.x+1, curr.y ).visited(); 
            if (goahead) goahead = goEast(); 
            break;
          case south: 
            goahead = !f.south() && !_m.get( curr.x, curr.y+1 ).visited();
            if (goahead) goahead = goSouth(); 
            break;
          case west: 
            goahead = !f.west() && !_m.get( curr.x-1, curr.y ).visited();
            if (goahead) goahead = goWest(); 
            break;
          default: 
            goahead = false;
          }

          direction rd;

          if ( !goahead ) {
            switch( ad ) {
            case north: 
              rd = direction.east; 
              break;
            case east: 
              rd = direction.south; 
              break;
            case south: 
              rd = direction.west; 
              break;
            case west: 
              rd = direction.north; 
              break;
            default: 
              rd = direction.north;
            }
            ad = rd;
          }

          i++;
        } 

        if ( !goahead ) {
          _d = goBack();
          goahead = true;
        }
      }
    } else {
      println( "Not active" );
    }
    return goahead;
  }
}


mazeclass m;
trail t;

void setup() {
  size(800, 800);
  //fullScreen();
  m = new mazeclass();
  //  p = new path( m, m.maxCol() / 2, m.maxRow() / 2 );
  t = new trail( m, m.maxCol() / 2, m.maxRow() / 2, direction.north );
}

void draw() {
  int sx = t.getP().X() - 20;
  int sy = t.getP().Y() - 20;
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

  m.drawmaze(sx, sy, ex, ey);
  //  t.step();
}

void keyPressed() {
  if ( m.getViewmode() == modes.m2d ) {
    if ( keyCode == UP ) {
      t.getP().moveUp();
    }
    if ( keyCode == DOWN ) {
      t.getP().moveDown();
    }
    if ( keyCode == LEFT ) {
      t.getP().moveLeft();
    }
    if ( keyCode == RIGHT ) {
      t.getP().moveRight();
    }
    if ( ( keyCode == 'V' ) || ( keyCode == 'v' ) ) {
      m.changeViewmode();
    }
    if ( keyCode == '2' ) {
      m.setViewmode( modes.m2d );
    }
    if ( keyCode == '3' ) {
      m.setViewmode( modes.m3d );
    }
    if ( ( keyCode == 'W' ) || ( keyCode == 'w' ) ) {
      m.setDirection( direction.north );
    }
    if ( ( keyCode == 'S' ) || ( keyCode == 's' ) ) {
      m.setDirection( direction.east );
    }
    if ( ( keyCode == 'Z' ) || ( keyCode == 'z' ) ) {
      m.setDirection( direction.south );
    }
    if ( ( keyCode == 'A' ) || ( keyCode == 'a' ) ) {
      m.setDirection( direction.west );
    }
  } else {
    if ( keyCode == UP ) {   //move forward in line of direction
      switch( m.getDirection() ) {
      case north:
        t.getP().moveUp();
        break;
      case east:
        t.getP().moveRight();
        break;
      case south:
        t.getP().moveDown();
        break;
      case west:
        t.getP().moveLeft();
        break;
      default: 
        t.getP().moveUp();
        break;
      }
    }
    if ( keyCode == DOWN ) { //move backwards in line of direction
      switch( m.getDirection() ) {
      case north:
        t.getP().moveDown();
        break;
      case east:
        t.getP().moveLeft();
        break;
      case south:
        t.getP().moveUp();
        break;
      case west:
        t.getP().moveRight();
        break;
      default: 
        t.getP().moveUp();
        break;
      }
    }
    if ( keyCode == LEFT ) { //move to the left respective of line of direction
      switch( m.getDirection() ) {
      case north:
        t.getP().moveLeft();
        break;
      case east:
        t.getP().moveUp();
        break;
      case south:
        t.getP().moveRight();
        break;
      case west:
        t.getP().moveRight();
        break;
      default: 
        t.getP().moveDown();
        break;
      }
    }
    if ( keyCode == RIGHT ) { //move to the right respective of line of direction
      switch( m.getDirection() ) {
      case north:
        t.getP().moveRight();
        break;
      case east:
        t.getP().moveDown();
        break;
      case south:
        t.getP().moveLeft();
        break;
      case west:
        t.getP().moveRight();
        break;
      default: 
        t.getP().moveUp();
        break;
      }
    }
    if ( ( keyCode == 'V' ) || ( keyCode == 'v' ) ) {
      m.changeViewmode();
    }
    if ( keyCode == '2' ) {
      m.setViewmode( modes.m2d );
    }
    if ( keyCode == '3' ) {
      m.setViewmode( modes.m3d );
    }
    if ( ( keyCode == 'W' ) || ( keyCode == 'w' ) ) {
      m.setDirection( direction.north );
    }
    if ( ( keyCode == 'S' ) || ( keyCode == 's' ) ) {
      m.setDirection( direction.east );
    }
    if ( ( keyCode == 'Z' ) || ( keyCode == 'z' ) ) {
      m.setDirection( direction.south );
    }
    if ( ( keyCode == 'A' ) || ( keyCode == 'a' ) ) {
      m.setDirection( direction.west );
    }
    if ( ( keyCode == 'Q' ) || ( keyCode == 'q' ) ) {
      switch( m.getDirection() ) {
      case north:
        m.setDirection( direction.west );
        break;
      case east:
        m.setDirection( direction.north );
        break;
      case south:
        m.setDirection( direction.east );
        break;
      case west:
        m.setDirection( direction.south );
        break;
      default: 
        m.setDirection( direction.north );
        break;
      }
    }
    if ( ( keyCode == 'E' ) || ( keyCode == 'e' ) ) {
      switch( m.getDirection() ) {
      case north:
        m.setDirection( direction.east );
        break;
      case east:
        m.setDirection( direction.south );
        break;
      case south:
        m.setDirection( direction.west );
        break;
      case west:
        m.setDirection( direction.north );
        break;
      default: 
        m.setDirection( direction.north );
        break;
      }
    }
  }

  println( "x= "+t.getP().X()+" y= "+t.getP().Y()+" direction= "+m.getDirection() );
}

void mouseDragged() {
  if ( mouseY < pmouseY ) {
    t.getP().moveUp();
  }
  if ( mouseY > pmouseY ) {
    t.getP().moveDown();
  }
  if ( mouseX < pmouseX ) {
    t.getP().moveLeft();
  }
  if ( mouseX > pmouseX ) {
    t.getP().moveRight();
  }

  println( "x= "+t.getP().X()+" y= "+t.getP().Y() );
}
