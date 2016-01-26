#include "mruby.h"
#include "mruby/irep.h"

int main(void)
{
  mrb_state *mrb = mrb_open();
  if (!mrb) { printf("Error loading mrb\n"); }
  mrb_load_irep(mrb, words_path_mrb);
  mrb_close(mrb);
}