subroutine netcdfinput()
  implicit none
  write(*,*)"Sorry, compiled without netcdf support !"
  stop
end subroutine netcdfinput
